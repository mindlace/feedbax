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

  [[ "$BUILD_NUMBER" =~ ^[0-9]+$ ]] \
    || die "BUILD_NUMBER '$BUILD_NUMBER' is not a non-empty digit string"

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
app_path="$export_dir/Feedbax.app"

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
    OTHER_CODE_SIGN_FLAGS='--timestamp' \
    ARCHS=arm64 # the engine uses SIMD Float16, which has no x86_64 lowering in Swift,
                # so the default universal-binary archive can't compile that slice;
                # Apple silicon only until the engine drops Float16 SIMD
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
  codesign --verify --deep --strict --verbose=2 "$app_path"
  codesign -dv --verbose=4 "$app_path" 2>&1 | grep -q 'flags=.*runtime' \
    || die "exported app is not hardened-runtime signed"

  local plist="$app_path/Contents/Info.plist" got
  got="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$plist")"
  [[ "$got" == "$VERSION" ]] \
    || die "bundle says version '$got', expected '$VERSION'"

  # CFBundleVersion is what macOS compares when deciding whether one copy of
  # the app is newer than another, so a stale or placeholder build number is
  # as wrong as a stale marketing version.
  got="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' "$plist")"
  [[ "$got" == "$BUILD_NUMBER" ]] \
    || die "bundle says build '$got', expected '$BUILD_NUMBER'"
}

# An unnotarized SKIP_NOTARIZE build must never look like a releasable
# artifact. It gets a distinct filename so a human browsing dist/ or a CI
# upload glob targeting "Feedbax-$VERSION.dmg" can't mistake one for the
# other; the notarized name stays exactly "Feedbax-$VERSION.dmg" because
# Task 5's upload step depends on it unchanged.
if [[ -n "$SKIP_NOTARIZE" ]]; then
  dmg_path="dist/Feedbax-$VERSION-unnotarized.dmg"
else
  dmg_path="dist/Feedbax-$VERSION.dmg"
fi
staging_dir="app/build/dmg-staging"

# Submits one already-signed artifact (a .zip or a .dmg) to Apple and blocks
# until it is accepted or rejected. Never staples — the caller decides what to
# staple, because the ticket for a zipped app has to be applied to the app
# itself, not to the zip that carried it.
submit_for_notarization() {
  local target="$1"

  step "Notarizing $target (this takes a few minutes)"
  # --wait blocks until Apple accepts or rejects; a rejection is a nonzero
  # exit. Capture output (instead of letting it stream straight to the
  # terminal) so a rejection's submission ID can be pulled back out for the
  # log fetch below; it's echoed back afterwards either way, so nothing is
  # lost from the log.
  local submit_output submit_status=0
  submit_output="$(xcrun notarytool submit "$target" "${notary_args[@]}" --wait 2>&1)" \
    || submit_status=$?
  echo "$submit_output"

  if [[ "$submit_status" -ne 0 ]]; then
    local submission_id
    submission_id="$(printf '%s\n' "$submit_output" \
      | grep -m1 -E '^\s*id:' | awk '{print $2}')" || true

    if [[ -n "$submission_id" ]]; then
      step "Notarization failed — fetching Apple's log for $submission_id"
      # Never let a failure here (network blip, expired credentials) mask
      # the real failure above or turn this branch into a success.
      xcrun notarytool log "$submission_id" "${notary_args[@]}" || true
    else
      step "Notarization failed and no submission ID could be parsed from its output"
    fi

    die "notarization rejected for $target — see log above"
  fi
}

# The app is notarized and stapled *before* the DMG is assembled, so the copy a
# user drags to /Applications carries its own ticket and launches offline
# without "Apple cannot check it for malicious software".
#
# This is a separate submission from the DMG's. A notarization ticket is issued
# per cdhash, and assembling and re-signing the DMG below necessarily produces a
# DMG cdhash Apple has never seen — so a single submission of the DMG could
# yield a ticket for the app but never one for the DMG that actually ships.
# Stapling the app first and then notarizing the finished DMG is the only order
# in which both artifacts end up stapled.
notarize_app() {
  if [[ -n "$SKIP_NOTARIZE" ]]; then
    step "SKIP_NOTARIZE set — not notarizing Feedbax.app"
    return
  fi

  local zip_path="app/build/Feedbax-notarize.zip"
  step "Zipping Feedbax.app for notarization"
  # notarytool only accepts .zip, .pkg and .dmg; ditto's archive is the format
  # Apple documents for submitting a bundle.
  rm -f "$zip_path"
  ditto -c -k --keepParent "$app_path" "$zip_path"

  submit_for_notarization "$zip_path"

  step "Stapling the ticket to Feedbax.app"
  xcrun stapler staple "$app_path"
  xcrun stapler validate "$app_path" \
    || die "notarization ticket is not stapled to $app_path"
  # Stapling writes into the bundle; prove it did not disturb the signature.
  codesign --verify --deep --strict --verbose=2 "$app_path"
}

make_dmg() {
  step "Assembling $dmg_path"
  rm -rf "$staging_dir"
  mkdir -p "$staging_dir" dist
  # ditto, not cp -R: it is the documented way to copy a signed bundle with
  # its extended attributes and any hard links intact.
  ditto "$app_path" "$staging_dir/Feedbax.app"
  codesign --verify --deep --strict --verbose=2 "$staging_dir/Feedbax.app" \
    || die "staging broke the signature of the copied Feedbax.app"
  ln -s /Applications "$staging_dir/Applications"

  local volname="Feedbax $VERSION"
  [[ -n "$SKIP_NOTARIZE" ]] && volname="Feedbax $VERSION (UNNOTARIZED)"

  rm -f "$dmg_path"
  hdiutil create \
    -volname "$volname" \
    -srcfolder "$staging_dir" \
    -fs HFS+ \
    -format UDZO \
    -ov \
    "$dmg_path"

  step "Signing $dmg_path"
  codesign --sign "$SIGNING_IDENTITY" --timestamp --force "$dmg_path"
}

notarize_dmg() {
  if [[ -n "$SKIP_NOTARIZE" ]]; then
    step "SKIP_NOTARIZE set — $dmg_path is an unnotarized smoke-test build, NOT for release"
    return
  fi

  submit_for_notarization "$dmg_path"

  step "Stapling the ticket to $dmg_path"
  xcrun stapler staple "$dmg_path"
}

verify_dmg() {
  step "Verifying $dmg_path"
  [[ -f "$dmg_path" ]] || die "no DMG at $dmg_path"

  # `-t open --context context:primary-signature` is Apple's documented
  # Gatekeeper assertion for a disk image; `-t install` is the
  # installer-package type and does not necessarily evaluate a DMG the same
  # way. Run both and require at least one to accept *and* to report a
  # notarized Developer ID source — an un-notarized DMG satisfies neither, so
  # this still fails closed.
  local -a forms=(
    '-a -vvv -t open --context context:primary-signature'
    '-a -vvv -t install'
  )
  local form out status accepted=0
  for form in "${forms[@]}"; do
    status=0
    # Deliberately unquoted: $form is a fixed, script-owned argument list.
    # shellcheck disable=SC2086
    out="$(spctl $form "$dmg_path" 2>&1)" || status=$?
    echo "spctl $form → exit $status"
    echo "$out"
    if [[ "$status" -eq 0 ]] \
      && printf '%s\n' "$out" | grep -q 'source=Notarized Developer ID'; then
      accepted=1
    fi
  done
  [[ "$accepted" -eq 1 ]] \
    || die "Gatekeeper does not see $dmg_path as notarized"

  xcrun stapler validate "$dmg_path" \
    || die "notarization ticket is not stapled to $dmg_path"

  # The app inside must carry its own ticket too, or a user who drags it to
  # /Applications and first launches it offline gets a Gatekeeper warning.
  xcrun stapler validate "$app_path" \
    || die "notarization ticket is not stapled to $app_path"
}

generate_project
archive
export_app
notarize_app
make_dmg
notarize_dmg
[[ -n "$SKIP_NOTARIZE" ]] || verify_dmg

step "Done: $dmg_path"
