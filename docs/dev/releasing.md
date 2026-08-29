# Releasing Feedbax

Feedbax ships as a signed, notarized `Feedbax.dmg` attached to a GitHub Release.
Versions and changelog entries are produced by release-please from conventional
commits; the DMG is built on a GitHub-hosted `macos-15` runner.

Design rationale lives in
`docs/superpowers/specs/2026-08-28-dmg-release-pipeline-design.md`.

- [Part 1 — First-time Apple Developer setup](#part-1--first-time-apple-developer-setup)
- [Part 2 — Cutting a release](#part-2--cutting-a-release)

---

## Part 1 — First-time Apple Developer setup

Done once, and again whenever the Developer ID certificate expires (they last
five years) or the notarization key is rotated.

Prerequisites: a current paid Apple Developer Program membership, and the
**Account Holder** role — Developer ID certificates cannot be created by members
with only the Developer role.

Everything here is command-line except two browser steps, both flagged 🌐.

### 1.1 — Team ID

Find it at <https://developer.apple.com/account> under Membership details. It is
a ten-character string like `A1B2C3D4E5`.

It is not a secret — it appears in every signed binary — so it goes in a repo
*variable*:

```sh
gh variable set DEVELOPMENT_TEAM --repo mindlace/feedbax --body 'A1B2C3D4E5'
```

### 1.2 — Private key and CSR

We generate the key ourselves rather than going through Keychain Access, so the
whole flow is scriptable and the key material is somewhere we can see it.

```sh
mkdir -p ~/Developer/feedbax-signing
chmod 700 ~/Developer/feedbax-signing
cd ~/Developer/feedbax-signing

openssl genrsa -out developer_id.key 2048
openssl req -new -key developer_id.key -out developer_id.csr \
  -subj "/emailAddress=ethan@mindlace.net/CN=Ethan Fremen/C=US"
```

`developer_id.key` is the private half of your signing identity. Losing it means
revoking the certificate and starting over; leaking it means someone else can
sign software as you. It never leaves this directory except as an encrypted
`.p12`.

### 1.3 — 🌐 Request the certificate

At <https://developer.apple.com/account/resources/certificates/list>:

1. `+` to add a certificate.
2. Choose **Developer ID Application** (*not* "Developer ID Installer", which
   signs `.pkg` files, and *not* "Mac Development").
3. When asked for a profile type, choose **G2 Sub-CA** (the current default).
4. Upload `~/Developer/feedbax-signing/developer_id.csr`.
5. Download the resulting `developer_id_application.cer` into
   `~/Developer/feedbax-signing/`.

### 1.4 — Assemble the `.p12`

A signing identity is the certificate plus its private key plus the Apple
intermediate that vouches for it. CI needs all three in one file, or `codesign`
will fail with an incomplete chain.

```sh
cd ~/Developer/feedbax-signing

# Apple's Developer ID intermediate (the "G2" sub-CA)
curl -fsSLO https://www.apple.com/certificateauthority/DeveloperIDG2CA.cer

openssl x509 -inform DER -in developer_id_application.cer -out developer_id.pem
openssl x509 -inform DER -in DeveloperIDG2CA.cer -out DeveloperIDG2CA.pem

# LibreSSL (/usr/bin/openssl) rather than Homebrew OpenSSL 3: it writes a
# PKCS#12 with the older encryption that macOS `security import` reliably reads.
/usr/bin/openssl pkcs12 -export \
  -inkey developer_id.key \
  -in developer_id.pem \
  -certfile DeveloperIDG2CA.pem \
  -name "Developer ID Application" \
  -out developer_id.p12
```

Choose a strong export password when prompted; you will need it twice more.

Install it locally so you can build and sign on this Mac:

```sh
security import developer_id.p12 -k ~/Library/Keychains/login.keychain-db \
  -T /usr/bin/codesign -T /usr/bin/security

# Grant the imported key to Apple's tools without a prompt. Without this, the
# first non-interactive `build-dmg.sh` run blocks on a GUI "codesign wants to
# sign using key … in your keychain" dialog. The CI workflow does exactly this
# to its throwaway keychain. Substitute your *login keychain* password (which
# is your macOS account password), not the .p12 export password.
security set-key-partition-list -S apple-tool:,apple: \
  -k '<login keychain password>' \
  ~/Library/Keychains/login.keychain-db >/dev/null

security find-identity -v -p codesigning
```

The second command must now list a `Developer ID Application: … (TEAMID)`
identity. If it lists zero identities, signing will not work — stop and fix this
before going further.

Store the same file as repository secrets:

```sh
base64 -i developer_id.p12 | \
  gh secret set DEVELOPER_ID_CERT_P12 --repo mindlace/feedbax
gh secret set DEVELOPER_ID_CERT_PASSWORD --repo mindlace/feedbax
```

### 1.5 — 🌐 Notarization key

Notarization uses an App Store Connect API key rather than your Apple ID and an
app-specific password: an API key does not break when the account password or
2FA changes, and it can be revoked on its own.

At <https://appstoreconnect.apple.com/access/integrations/api>:

1. Team Keys → `+`.
2. Name it something like `feedbax-notary`, access role **Developer**.
3. Download the `.p8`. **It downloads exactly once** — there is no second
   chance, only revoke-and-reissue.
4. Note the **Key ID** (next to the key) and the **Issuer ID** (above the
   table).

```sh
mv ~/Downloads/AuthKey_XXXXXXXXXX.p8 ~/Developer/feedbax-signing/notary.p8

base64 -i ~/Developer/feedbax-signing/notary.p8 | \
  gh secret set NOTARY_KEY_P8 --repo mindlace/feedbax
gh secret set NOTARY_KEY_ID    --repo mindlace/feedbax --body 'XXXXXXXXXX'
gh secret set NOTARY_ISSUER_ID --repo mindlace/feedbax --body '....-....-....'
```

For local builds, store the same credentials in a notarytool keychain profile so
`build-dmg.sh` can submit without arguments:

```sh
xcrun notarytool store-credentials feedbax-notary \
  --key ~/Developer/feedbax-signing/notary.p8 \
  --key-id XXXXXXXXXX \
  --issuer ....-....-....
```

### 1.6 — Xcode toolchain

`xcodebuild` is not part of the Command Line Tools, so a default developer
directory pointing at `/Library/Developer/CommandLineTools` fails with
*"tool 'xcodebuild' requires Xcode"*. This is the same trap that affects
`swift test` (which needs XCTest from a full Xcode).

```sh
xcode-select -p                 # must be a path inside Xcode.app
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept
```

`build-dmg.sh` sets `DEVELOPER_DIR` itself, so this is only needed for ad-hoc
`xcodebuild` and `swift test` invocations.

In CI the workflow pins an explicit `/Applications/Xcode_<version>.app` rather
than following the runner image's `Xcode.app` symlink, so a runner-image bump
cannot change the compiler under a release. When GitHub drops that version from
the `macos-15` image the *Select Xcode* step fails with the list of what is
installed; pick one from that list and update the step.

### 1.7 — Verify

```sh
gh secret   list --repo mindlace/feedbax   # 5 secrets
gh variable list --repo mindlace/feedbax   # DEVELOPMENT_TEAM
security find-identity -v -p codesigning   # 1+ Developer ID Application
xcrun notarytool history --keychain-profile feedbax-notary
```

The last command reaching Apple and returning a (probably empty) history proves
the notarization credentials work, without building anything.

### What ends up where

| Secret / variable | Kind | Source |
|---|---|---|
| `DEVELOPMENT_TEAM` | variable | Membership details |
| `DEVELOPER_ID_CERT_P12` | secret | §1.4, base64 |
| `DEVELOPER_ID_CERT_PASSWORD` | secret | §1.4, chosen by you |
| `NOTARY_KEY_P8` | secret | §1.5, base64 |
| `NOTARY_KEY_ID` | secret | §1.5 |
| `NOTARY_ISSUER_ID` | secret | §1.5 |

`~/Developer/feedbax-signing/` is the only durable copy of the private key and
the `.p8`. It belongs in an encrypted backup and nowhere near the repository.

---

## Part 2 — Cutting a release

### One-time step: pinning the first release

The repository has no git tags yet. release-please decides the next version by
looking at the latest tag; with none, it reports "No latest release", walks the
entire commit history, and computes the next bump *from the seeded manifest
value* in `.release-please-manifest.json` (currently `0.123.0`). A dry run
against this repo confirmed it: with nothing done, the first automated release
would propose `0.124.0` and tag `v0.124.0` — and `0.123.0`, chosen deliberately
to read as pre-1.0 and as a port of Max patch 1.2.3, would never become a tag,
a release, or a DMG.

So before the normal path below can run for the first time, pin it explicitly.
Land one commit on `main` carrying a `Release-As: 0.123.0` footer —
release-please's documented mechanism for setting an exact next version
regardless of what commit history would otherwise compute. Two details matter:

- The **subject line must itself be a Conventional Commit**. release-please
  parses the subject first; a non-conforming subject can make it skip the
  commit entirely, footer and all.
- The footer must be its own trailer line, separated from the body by a blank
  line.

```sh
git commit --allow-empty \
  -m 'chore: pin the first release to 0.123.0' \
  -m 'Release-As: 0.123.0'
```

Push it to `main` and wait for the workflow. Expect a `chore(main): release
0.123.0` PR; merging it tags `v0.123.0` and attaches the DMG.

**If no release PR appears.** This path is untested against a repo with no
tags, and `Release-As` asks for a version *equal to* the value already in
`.release-please-manifest.json` — release-please may treat that as "nothing to
do" and stay silent. The fallback is to make the requested version a genuine
bump: set `.release-please-manifest.json` to `0.122.0`, commit that, and land
the `Release-As: 0.123.0` commit again. Leave `version.txt` at `0.123.0`; the
release PR overwrites it.

Do not repeat any of this after the first release ships — subsequent versions
come from Conventional Commits alone.

### The normal path

1. Land work on `main` with Conventional Commits — `feat:` bumps the minor
   (pre-1.0), `fix:` the patch, and anything with `!` or a
   `BREAKING CHANGE:` footer also bumps the minor while below 1.0.
2. release-please opens or updates a release PR titled
   `chore(main): release <version>`, carrying the `version.txt` bump and the
   generated `CHANGELOG.md` entry. Edit the changelog in that PR if the
   generated wording needs help.
3. Merge it. That tags `v<version>`, publishes a GitHub Release, and — in the
   same workflow run — builds, signs, notarizes, and attaches
   `Feedbax-<version>.dmg`.

Releases are not gated on tests. Run them yourself before merging a release PR:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  swift test --package-path app --skip GoldenFrameTests
```

`GoldenFrameTests` is skipped by standing convention — `GoldenReferences/` is
empty, so it fails by design.

### Forcing a specific version

Add a `Release-As: 1.0.0` footer to a commit on `main`.

### Building a DMG without releasing

Locally:

```sh
DEVELOPMENT_TEAM=<team id> tools/release/build-dmg.sh
```

Add `SKIP_NOTARIZE=1` to stop after signing — much faster, and useful for local
testing, but the result is deliberately not a releasable artifact: it is named
`dist/Feedbax-<version>-unnotarized.dmg` (not the plain `Feedbax-<version>.dmg`
name), its volume label is suffixed `(UNNOTARIZED)`, and Gatekeeper will refuse
it on any other Mac.

In CI: Actions → release-please → *Run workflow*, with **force_dmg** checked.
This runs the full sign-and-notarize pipeline as a smoke test (never
`SKIP_NOTARIZE`), and the resulting `dist/Feedbax-<version>.dmg` is uploaded as
a workflow run artifact named `Feedbax-dmg`.

Note that the `release-please` job runs on `workflow_dispatch` too, so a dry run
is not inert: it will open or update the release PR exactly as a push to `main`
would. It will not normally *create* a release — but it would if a release PR
had already been merged without its tagging run completing. If a release PR is
open and unmerged, a dry run is safe; if one was just merged, let the push-
triggered run finish first.

The DMG is attached to a release only when a release was created in that same
run, so on an ordinary dry run the artifact is the only place it lands.

### Two notarization submissions, not one

`build-dmg.sh` submits twice, and a release therefore waits on Apple twice:

1. `Feedbax.app`, zipped, is notarized and the ticket is **stapled to the app**.
2. The DMG is then assembled from that stapled app, signed, notarized, and the
   ticket stapled to the DMG.

The app has to be stapled separately because stapling a DMG puts the ticket in
the DMG, not in the app inside it — so a user who drags `Feedbax.app` to
`/Applications` and first launches it offline would otherwise see "Apple cannot
check it for malicious software". And the DMG cannot ride on the app's
submission: a ticket is issued per code-directory hash, and assembling and
signing the DMG necessarily produces a hash Apple has not seen, so `stapler`
would fail with error 65. Each artifact needs its own ticket.

### When notarization fails

`xcrun notarytool submit --wait` exits nonzero. `build-dmg.sh` catches this
itself: it parses the submission ID out of the failed submission's output and
runs `xcrun notarytool log <id>` automatically, printing Apple's log inline
before the script exits — no manual log fetch is needed. The output names which
artifact was rejected, the app zip or the DMG.

The usual causes are a missing hardened runtime, an unsigned nested binary, or a
signature without a secure timestamp — all three are set by `build-dmg.sh`, so a
failure here usually means the certificate or its chain is wrong. Re-check
`security find-identity -v -p codesigning`.

### Recovering a release that published without a DMG

The tag and the GitHub Release are created by the `release-please` job; the DMG
is built and attached afterwards by the `dmg` job. If the `dmg` job fails —
notarization rejected, verification failed, the upload timed out — the release
is already public with no DMG on it.

**Use *Re-run failed jobs*. Never *Re-run all jobs*.** Re-running all jobs
re-runs `release-please`, which now sees the release it already made, reports
nothing releasable, and resolves the created flag false — which *skips* the
`dmg` job rather than failing it. The run goes green and the release stays
DMG-less, with no obvious sign anything went wrong. *Re-run failed jobs* keeps
the original `release-please` job's outputs, so the `dmg` job still sees the
right tag.

If the failure is in the build itself, fix it on `main` first — but note that
re-running the job checks out the commit the run started from, not your fix.
For a fix that has to be in the artifact, cut a new patch release.

If the DMG was built and only a later step failed, you do not have to rebuild
or re-notarize it at all: the `dmg` job uploads `dist/*.dmg` as a run artifact
named `Feedbax-dmg` unconditionally, immediately after the build, precisely so
a multi-minute notarization is never thrown away by a failure below it. Download
it from the failed run's summary page and attach it by hand:

```sh
gh run download <run-id> --repo mindlace/feedbax --name Feedbax-dmg --dir /tmp/dmg
gh release upload v<version> /tmp/dmg/Feedbax-<version>.dmg --repo mindlace/feedbax --clobber
```

Verify what you attached before trusting it:

```sh
spctl -a -vvv -t open --context context:primary-signature /tmp/dmg/Feedbax-<version>.dmg
xcrun stapler validate /tmp/dmg/Feedbax-<version>.dmg
```

### Where a user's files go

A Finder-launched app has a working directory of `/`, so the repository's
`input/transparent-background/` never resolves and the fallback in
`AppBootstrap.swift` applies: stickers are read from `~/Pictures/Feedbax/stickers/`
and stills are written to `~/Pictures/Feedbax/`. Say so in the release notes —
it is the one behavioural difference between the DMG and `swift run`.

### Apple silicon only

The DMG contains an arm64-only binary. The engine uses SIMD `Float16`, which
Swift does not provide on x86_64, so the app cannot be built for Intel Macs at
all — `build-dmg.sh` pins `ARCHS=arm64` rather than letting the archive attempt
a universal binary and fail. Say so in the release notes.
