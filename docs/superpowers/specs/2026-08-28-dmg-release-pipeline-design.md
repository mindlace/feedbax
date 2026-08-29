# Feedbax DMG Release Pipeline — Design

Date: 2026-08-28
Status: Draft for review

## Goal

Turn `Feedbax.app` into a signed, notarized `.dmg` that is attached to a GitHub
Release, and put a release process around it modeled on `../planafoot` —
release-please driving version and CHANGELOG from conventional commits.

Today none of this exists: there is no `.github/` directory, no build script of
any kind in the repo, no code-signing configuration, and `version.txt` (`1.2.3`)
is inert — nothing reads it, while `app/App/Info.plist` hardcodes
`CFBundleShortVersionString` `1.0` and `CFBundleVersion` `1`.

## Decisions taken

| Question | Decision |
|---|---|
| Versioning | release-please, manifest mode, `release-type: simple` (its version file *is* `version.txt`) |
| First version | `0.123.0` — pre-1.0, and a port of Max patch `1.2.3` |
| Pipeline shape | One workflow: ubuntu release-please job + dependent `macos-15` job gated on `release_created` |
| Signing | Developer ID Application + notarization, secrets in GitHub Actions |
| Build host | GitHub-hosted `macos-15` (free: `mindlace/feedbax` is a public repo) |
| App icon | Out of scope — ships with the generic macOS icon |

### Why not planafoot's GitHub App token

planafoot mints an `actions/create-github-app-token` token for release-please
solely because GitHub suppresses workflow runs for events emitted by
`GITHUB_TOKEN` — its `deploy-prod.yml` listens on `release: published` and would
never fire. Feedbax has no such downstream listener: the DMG job is a `needs:`
job in the *same* workflow, gated on release-please's `release_created` output.
No App registration, no extra secrets, and the default `GITHUB_TOKEN` suffices.

### Why releases are not gated on CI tests

`app/README.md` is explicit that the engine tests build real Metal pipelines
against the default GPU and "are not headless-CI friendly", and
`GoldenFrameTests.testAllScenariosMatchReferences` fails by design against the
empty `GoldenReferences/`. This mirrors planafoot, which also does not gate
releases on a CI test job — it gates on a locally-posted signoff status. Feedbax
adopts the same posture in a lighter form: tests stay a local, documented
obligation (`DEVELOPER_DIR=… swift test --package-path app --skip GoldenFrameTests`),
and CI proves only that the artifact *builds, signs, and notarizes*.

## Architecture

Three units, each usable without the others:

```
tools/release/build-dmg.sh      ← the whole packaging pipeline, runs identically
                                   on your Mac and on the runner
tools/release/ExportOptions.plist
.github/workflows/release-please.yml
  job: release-please (ubuntu-latest)  → version.txt, CHANGELOG.md, tag, release
  job: dmg (macos-15, needs: ↑, if: release_created)
       → import certs → build-dmg.sh → gh release upload
docs/dev/releasing.md           ← first-time ADC + secrets setup, cutting a release
```

CI is a thin wrapper around the script. Anything CI can do, you can do locally
with the same command — which is also the fallback if Actions is down or a
notarization needs babysitting.

### Unit 1 — `tools/release/build-dmg.sh`

Single entry point. Contract:

- **Input**: repo checkout; `VERSION` (defaults to `cat version.txt`);
  `DEVELOPMENT_TEAM`; signing identity present in the active keychain;
  notarization credentials (see below). `DEVELOPER_DIR` must point at a real
  Xcode — `xcodebuild` is unavailable under CommandLineTools, the same trap that
  bites `swift test`.
- **Output**: `dist/Feedbax-<VERSION>.dmg`, signed, notarized, stapled.
- **Depends on**: `xcodegen` (already present via Homebrew), Xcode's
  `xcodebuild`, `hdiutil`, `codesign`, `xcrun notarytool`, `xcrun stapler`. No
  `create-dmg` dependency — plain `hdiutil` keeps the toolchain to Xcode plus
  Homebrew-xcodegen.

Steps:

1. `cd app && xcodegen generate` — `app/Feedbax.xcodeproj` is gitignored and
   must be regenerated every time.
2. `xcodebuild archive -scheme Feedbax -configuration Release
   -archivePath build/Feedbax.xcarchive
   MARKETING_VERSION="$VERSION" CURRENT_PROJECT_VERSION="$BUILD_NUMBER"
   DEVELOPMENT_TEAM="$DEVELOPMENT_TEAM" CODE_SIGN_STYLE=Manual
   CODE_SIGN_IDENTITY="Developer ID Application" ENABLE_HARDENED_RUNTIME=YES`
3. `xcodebuild -exportArchive -exportOptionsPlist tools/release/ExportOptions.plist`
   (`method: developer-id`, `signingStyle: manual`, `teamID`) → a correctly
   signed, hardened `Feedbax.app`.
4. Stage: `staging/Feedbax.app` plus `ln -s /Applications staging/Applications`.
5. `hdiutil create -volname "Feedbax" -srcfolder staging -ov -format UDZO
   dist/Feedbax-$VERSION.dmg`
6. `codesign --sign "Developer ID Application: …" --timestamp dist/…dmg`
7. `xcrun notarytool submit --wait` with an App Store Connect API key, then
   `xcrun stapler staple dist/…dmg`.

Notarizing the DMG covers the app nested inside it, so one submission suffices;
stapling the DMG is what makes first launch clean with no network round trip.

**Build number**: `CURRENT_PROJECT_VERSION` is the CI run number in CI and the
commit count (`git rev-list --count HEAD`) locally — monotonic in both cases,
and never a value a human has to maintain.

### Unit 2 — version plumbing

Two edits make the version real instead of decorative:

- `app/project.yml` gains a `settings.base` block declaring `MARKETING_VERSION`
  and `CURRENT_PROJECT_VERSION` (it has no `settings:` block at all today), and
  its `info.properties` block gains `CFBundleShortVersionString:
  "$(MARKETING_VERSION)"` and `CFBundleVersion: "$(CURRENT_PROJECT_VERSION)"`.
- `version.txt` becomes release-please's managed file, reseeded at `0.123.0`.

**`app/App/Info.plist` is not edited by hand.** Despite being checked in, it is
*generated output*: XcodeGen's `info:` key writes the plist at `info.path` on
every `xcodegen generate`, and its defaults are exactly the `1.0` / `1` values
sitting there now. Verified empirically — setting
`CFBundleShortVersionString` to `9.9` by hand and regenerating reverts it to
`1.0`. Version keys therefore have to enter through `project.yml`, and the
regenerated plist carries the literal `$(MARKETING_VERSION)` reference that
Xcode expands during "Process Info.plist".

Whether to keep the generated plist checked in at all is a judgement call left
as-is: it is committed today, and the plan keeps it committed (regenerated, so
the `$(…)` references land in git) rather than expanding the diff.

`version.txt` is thus the single source of truth, release-please owns writing
it, and `build-dmg.sh` reads it. Nothing else in the repo hardcodes a version.

The Swift code stays version-agnostic — no generated `Version.swift`. If an
About box ever needs the number it reads `Bundle.main.infoDictionary`, which is
correct by construction.

### Unit 3 — `.github/workflows/release-please.yml`

```yaml
on: { push: { branches: [main] }, workflow_dispatch: {} }
concurrency: { group: release-please, cancel-in-progress: false }
permissions: { contents: write, pull-requests: write }

jobs:
  release-please:
    runs-on: ubuntu-latest
    outputs:
      release_created: ${{ steps.rp.outputs.release_created }}
      tag_name:        ${{ steps.rp.outputs.tag_name }}
    steps:
      - uses: googleapis/release-please-action@v5.0.0
        id: rp
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          config-file: release-please-config.json
          manifest-file: .release-please-manifest.json

  dmg:
    needs: release-please
    if: needs.release-please.outputs.release_created == 'true'
    runs-on: macos-15
    steps:
      - uses: actions/checkout@v5
      - <import signing certificate into a temporary keychain>
      - run: tools/release/build-dmg.sh
      - run: gh release upload "$TAG" dist/Feedbax-*.dmg
```

Action versions are pinned, following planafoot's convention.

**Certificate import** is hand-rolled with `security` (create a temporary
keychain, `security import` the base64-decoded `.p12`, set the partition list,
delete the keychain in an `always()` step) rather than taking a third-party
action as a dependency — it is roughly ten auditable lines.

**`workflow_dispatch`** allows a dry run of the DMG job without cutting a
release; the `dmg` job takes an optional input so it can be forced independently
of `release_created`.

### Unit 4 — release-please configuration

`release-please-config.json`:

```json
{
  "packages": {
    ".": {
      "release-type": "simple",
      "package-name": "feedbax",
      "bump-minor-pre-major": true,
      "changelog-path": "CHANGELOG.md"
    }
  }
}
```

`.release-please-manifest.json`: `{ ".": "0.123.0" }`.

`release-type: simple` is the strategy whose version file is `version.txt` —
exactly the file feedbax already has. `bump-minor-pre-major` keeps breaking
changes at a minor bump while below 1.0, so `feat:` → `0.124.0`, `fix:` →
`0.123.1`, `feat!:` → `0.124.0`. Tags are bare `vX.Y.Z` (single package, no
component prefix). `CHANGELOG.md` at the repo root is new.

Conventional Commits are already this repo's committing convention, so the
changelog is meaningful from day one.

## First-time Apple Developer setup (`docs/dev/releasing.md`)

Written for a freshly renewed ADC membership, in order:

1. **Team ID** — from the Apple Developer account page. Goes in the repo
   *variable* `DEVELOPMENT_TEAM`, not a secret; it is not sensitive.
2. **Developer ID Application certificate** — create a CSR via Keychain Access,
   request the certificate in the developer portal (Certificates → `+` →
   Developer ID Application), download and install it, then export the
   certificate *and its private key* as a `.p12` with a strong password.
   `base64 -i cert.p12 | pbcopy` → secret `DEVELOPER_ID_CERT_P12`; the password
   → secret `DEVELOPER_ID_CERT_PASSWORD`.
   *This machine currently reports 0 codesigning identities, so this step is a
   hard prerequisite for even a local run.*
3. **App Store Connect API key for notarization** — App Store Connect → Users
   and Access → Integrations → Keys, role Developer. The `.p8` downloads once.
   Secrets: `NOTARY_KEY_P8` (base64), `NOTARY_KEY_ID`, `NOTARY_ISSUER_ID`.
   An API key is preferred over Apple-ID plus app-specific password because it
   does not break when the account's password or 2FA changes.
4. **Local verification** — run `tools/release/build-dmg.sh` end to end on your
   Mac before the first CI release, then check the result with
   `spctl -a -vvv -t install dist/Feedbax-*.dmg` and by opening the mounted app
   on a machine that has never seen the source.

The doc also covers cutting a release: land conventional commits on `main`,
release-please opens a release PR, merge it, and the tag, release, and DMG
follow automatically.

## Distribution notes

- **Microphone.** `app/App/Feedbax.entitlements` already carries
  `com.apple.security.device.audio-input`, which is the right key under the
  hardened runtime, and `Info.plist` already has `NSMicrophoneUsageDescription`.
  A Finder-launched `.app` gets its own TCC identity rather than inheriting a
  terminal's — the DMG path is cleaner here than `swift run`.
- **No app sandbox.** The entitlements file has no `app-sandbox` key, which is
  correct for Developer ID distribution and is what lets the app write stills to
  `~/Pictures/Feedbax/`.
- **Working directory.** A Finder-launched app has CWD `/`, so the
  `input/transparent-background/` sticker path never resolves and the
  `~/Pictures/Feedbax/stickers/` fallback in `AppBootstrap.swift` always applies.
  That fallback already exists; the release notes should say where to put
  stickers. No code change.
- **Runtime shader compilation.** `.metal` files ship as source in the SwiftPM
  resource bundle and are compiled by `MetalContext` at launch. Deliberate, and
  unchanged by packaging: it costs launch time, not correctness.
- **Deployment target** stays macOS 14.0, pinned in two places
  (`Package.swift`, `project.yml`) that must not drift.

## Testing

The pipeline is shell and YAML, so the story is verification rather than unit
tests:

- `build-dmg.sh` runs locally end to end before the first CI release — that is
  the real test, and a prerequisite for merging.
- The script fails loudly: `set -euo pipefail`, plus an explicit preflight that
  checks for `xcodegen`, a usable `DEVELOPER_DIR`, a matching signing identity,
  and the notarization credentials *before* starting a multi-minute build.
- `spctl -a -vvv -t install` and `codesign --verify --deep --strict` assertions
  run at the end of the script, so a mis-signed DMG fails the build rather than
  failing on a user's Mac.
- The first CI run is exercised via `workflow_dispatch` against `main` before any
  release PR is merged.

## Out of scope

App icon and custom DMG window art; Sparkle or any auto-update mechanism; a
Homebrew cask; a CI test job; Max patch artifacts — `patches/` and `assets/`
stay out of the DMG entirely.

## Correction: the DMG is Apple silicon only

This section originally listed universal binaries as a non-question, on the
assumption that a Release archive covers arm64 and x86_64 by default. It does —
and the x86_64 slice does not compile:

```
MetalContext.swift:60:33: error: type 'Float16' does not conform to protocol 'SIMDScalar'
MetalContext.swift:93:45: error: type 'Float16' does not conform to protocol 'SIMDScalar'
```

Swift has no SIMD `Float16` on x86_64, so the engine has never been buildable
for Intel. It went unnoticed because `swift build` and `swift run` compile only
the host architecture, and nothing had ever asked for a fat binary. Adding
`ARCHS=arm64` to the archive gives `** ARCHIVE SUCCEEDED **`.

`build-dmg.sh` therefore pins `ARCHS=arm64` and the DMG requires Apple silicon.
This documents an existing limit rather than imposing a new one — an Intel Mac
cannot run Feedbax today either. Lifting it means refactoring `MetalContext`'s
Float16 SIMD usage, which is engine work, not packaging work.
