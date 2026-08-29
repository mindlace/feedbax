#!/usr/bin/env bash
# Verifies that version.txt reaches the generated Info.plist as a build-setting
# reference, so `xcodebuild MARKETING_VERSION=...` can override it at package time.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

fail() { echo "FAIL: $*" >&2; exit 1; }

# 1. version.txt holds a bare semver and nothing else.
version="$(cat version.txt)"
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] \
  || fail "version.txt is '$version', expected a bare semver"

# 2. Regenerating the project rewrites Info.plist with build-setting references.
(cd app && xcodegen generate --quiet)

plist="app/App/Info.plist"
short="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$plist")"
bundle="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' "$plist")"

[[ "$short" == '$(MARKETING_VERSION)' ]] \
  || fail "CFBundleShortVersionString is '$short', expected \$(MARKETING_VERSION)"
[[ "$bundle" == '$(CURRENT_PROJECT_VERSION)' ]] \
  || fail "CFBundleVersion is '$bundle', expected \$(CURRENT_PROJECT_VERSION)"

# 3. The settings exist in the generated project, so the command-line override
#    has something to override.
grep -q 'MARKETING_VERSION = ' app/Feedbax.xcodeproj/project.pbxproj \
  || fail "MARKETING_VERSION missing from the generated project"
grep -q 'CURRENT_PROJECT_VERSION = ' app/Feedbax.xcodeproj/project.pbxproj \
  || fail "CURRENT_PROJECT_VERSION missing from the generated project"

echo "OK: version plumbing intact (version.txt = $version)"
