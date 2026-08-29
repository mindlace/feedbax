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

*To be written alongside the pipeline implementation.*
