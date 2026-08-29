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
Land one commit on `main` with a `Release-As: 0.123.0` footer — release-please's
documented mechanism for setting an exact next version regardless of what commit
history would otherwise compute. This is the same mechanism as "Forcing a
specific version" below; it just needs to happen once, first, because there is
no prior tag for the normal path to build on. Do not repeat this after the
first release ships — subsequent versions come from Conventional Commits alone.

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
`SKIP_NOTARIZE`) but does not create a release; the resulting
`dist/Feedbax-<version>.dmg` is uploaded as a workflow run artifact named
`Feedbax-dmg` instead of being attached anywhere.

### When notarization fails

`xcrun notarytool submit --wait` exits nonzero. `build-dmg.sh` catches this
itself: it parses the submission ID out of the failed submission's output and
runs `xcrun notarytool log <id>` automatically, printing Apple's log inline
before the script exits — no manual log fetch is needed.

The usual causes are a missing hardened runtime, an unsigned nested binary, or a
signature without a secure timestamp — all three are set by `build-dmg.sh`, so a
failure here usually means the certificate or its chain is wrong. Re-check
`security find-identity -v -p codesigning`.

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
