#!/usr/bin/env bash
# Builds, signs, and notarizes dist/Feedbax-<version>.dmg.
# Runs identically on a developer Mac and on a GitHub macos-15 runner.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

: "${DEVELOPER_DIR:=/Applications/Xcode.app/Contents/Developer}"
export DEVELOPER_DIR
: "${VERSION:=$(cat version.txt)}"
: "${BUILD_NUMBER:=$(git rev-list --count HEAD)}"
: "${SIGNING_IDENTITY:=Developer ID Application}"
: "${NOTARY_PROFILE:=feedbax-notary}"
: "${NOTARY_KEYCHAIN:=}"
: "${SKIP_NOTARIZE:=}"

die() { echo "error: $*" >&2; exit 1; }
step() { echo; echo "==> $*"; }

# CI keeps the notarization profile in a throwaway keychain rather than the
# login keychain, and every notarytool call then has to name it.
notary_args=(--keychain-profile "$NOTARY_PROFILE")
if [[ -n "$NOTARY_KEYCHAIN" ]]; then
  notary_args+=(--keychain "$NOTARY_KEYCHAIN")
fi

preflight() {
  step "Preflight"

  [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] \
    || die "VERSION '$VERSION' is not a bare semver"

  command -v xcodegen >/dev/null \
    || die "xcodegen not found — brew install xcodegen"

  [[ -x "$DEVELOPER_DIR/usr/bin/xcodebuild" ]] \
    || die "DEVELOPER_DIR='$DEVELOPER_DIR' has no xcodebuild — point it at a full Xcode, not CommandLineTools"

  [[ -n "${DEVELOPMENT_TEAM:-}" ]] \
    || die "DEVELOPMENT_TEAM is unset — see docs/dev/releasing.md §1.1"

  security find-identity -v -p codesigning | grep -q "$SIGNING_IDENTITY" \
    || die "no '$SIGNING_IDENTITY' identity in the keychain — see docs/dev/releasing.md §1.4"

  if [[ -z "$SKIP_NOTARIZE" ]]; then
    xcrun notarytool history "${notary_args[@]}" >/dev/null 2>&1 \
      || die "notarytool profile '$NOTARY_PROFILE' unusable — see docs/dev/releasing.md §1.5, or set SKIP_NOTARIZE=1"
  fi

  echo "version         $VERSION ($BUILD_NUMBER)"
  echo "team            $DEVELOPMENT_TEAM"
  echo "identity        $SIGNING_IDENTITY"
  echo "notarize        $([[ -n "$SKIP_NOTARIZE" ]] && echo 'skipped' || echo "$NOTARY_PROFILE")"
}

preflight

archive_path="app/build/Feedbax.xcarchive"
export_dir="app/build/export"

generate_project() {
  step "Generating Feedbax.xcodeproj"
  (cd app && xcodegen generate --quiet)
}

archive() {
  step "Archiving Feedbax $VERSION ($BUILD_NUMBER)"
  rm -rf "$archive_path"
  xcodebuild archive \
    -project app/Feedbax.xcodeproj \
    -scheme Feedbax \
    -configuration Release \
    -archivePath "$archive_path" \
    -destination 'generic/platform=macOS' \
    MARKETING_VERSION="$VERSION" \
    CURRENT_PROJECT_VERSION="$BUILD_NUMBER" \
    DEVELOPMENT_TEAM="$DEVELOPMENT_TEAM" \
    CODE_SIGN_STYLE=Manual \
    CODE_SIGN_IDENTITY="$SIGNING_IDENTITY" \
    ENABLE_HARDENED_RUNTIME=YES \
    OTHER_CODE_SIGN_FLAGS='--timestamp'
}

export_app() {
  step "Exporting signed app"
  rm -rf "$export_dir"
  local opts="app/build/ExportOptions.plist"
  mkdir -p app/build
  cp tools/release/ExportOptions.plist "$opts"
  /usr/libexec/PlistBuddy -c "Add :teamID string $DEVELOPMENT_TEAM" "$opts"

  xcodebuild -exportArchive \
    -archivePath "$archive_path" \
    -exportOptionsPlist "$opts" \
    -exportPath "$export_dir"

  step "Verifying the exported app"
  codesign --verify --deep --strict --verbose=2 "$export_dir/Feedbax.app"
  codesign -dv --verbose=4 "$export_dir/Feedbax.app" 2>&1 | grep -q 'flags=.*runtime' \
    || die "exported app is not hardened-runtime signed"

  local got
  got="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' \
    "$export_dir/Feedbax.app/Contents/Info.plist")"
  [[ "$got" == "$VERSION" ]] \
    || die "bundle says version '$got', expected '$VERSION'"
}

generate_project
archive
export_app

step "Done: $export_dir/Feedbax.app"
