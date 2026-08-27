# Feedbax — the Swift port

This directory is the native macOS re-implementation of Sean's Max patch: a SwiftUI shell, a
Metal render core, and `AVAudioEngine` + vDSP for the microphone analysis. *What* it does is
specified in [`../docs/spec/`](../docs/spec/README.md); *why* it is built this way is in
[the reimplementation design](../docs/superpowers/specs/2026-08-23-feedbax-reimplementation-design.md).
This file is about how to build, run, test, and change it.

## Prerequisites

- **macOS 14 or later** (`Package.swift` pins `.macOS(.v14)`). Developed and measured on Apple
  Silicon.
- **Xcode — the full app, not just the Command Line Tools.** `swift build` and `swift run` work
  with either, but the test target needs XCTest, which only ships inside `Xcode.app` (see
  [Tests](#tests) for the one environment variable that matters). Swift tools version 5.10 or
  newer; the code is currently built with Swift 6.3.
- **[XcodeGen](https://github.com/yonaskolb/XcodeGen)** (`brew install xcodegen`) — only if you
  want the `Feedbax.app` bundle or an Xcode project. The everyday loop below needs neither.
- **A microphone.** The built-in one is fine. Feedbax is audio-reactive; with no input the
  waveforms sit flat and the bumps never fire. No camera is needed (camera input is a later
  phase, design §10).

## The development loop

From the **repository root** (not from `app/`):

```sh
swift run --package-path app feedbax-dev
```

That builds `FeedbaxKit` and the `feedbax-dev` executable in Debug and launches the
instrument. Three windows open:

| Window | What it is |
|---|---|
| **Output** | the render surface. Trackpad gestures over it drive the instrument; `f` / Esc toggles fullscreen; `s` saves a still. |
| **Controls** | the operator panel: sliders for every axis, the two XY pads, layer/waveform toggles, a *Show HUD* switch. |
| **Controls Reference** | every key, gesture, pad, and gamepad binding — generated from the live bindings table. Opens with `?`, *Help › Feedbax Controls*, or ⌘/. |

The full key/gesture table is in the [top-level README](../README.md#controls-swift-port) and
in the Controls Reference window; the window is the authoritative one because it is generated
from `Control/DefaultBindings.json` (plus your overrides) at launch.

For a Release build (what the performance numbers are measured on):

```sh
swift run --package-path app -c release feedbax-dev
```

### Why "from the repository root"

The sticker layer scans `input/transparent-background/` **relative to the current working
directory** when that folder exists — it is the repo's user-media folder (gitignored apart from
its `.gitkeep`), so a checkout with PNGs dropped in there just works. If the folder is not
found — for example a Finder-launched `Feedbax.app`, whose CWD is `/` — the app falls back to
`~/Pictures/Feedbax/stickers/`, creating it if needed (`AppBootstrap.resolveStickerFolder`).
Running from inside `app/` therefore gives you the fallback folder, not the repo one.

### What `swift run` does not give you

`feedbax-dev` is an unbundled executable — no `Info.plist`, no entitlements. Two consequences:

- **Focus.** Nothing makes a bare binary the frontmost app on its own, so `feedbax-dev`'s
  `AppDelegate` sets the activation policy to `.regular` and activates itself
  (`Sources/feedbax-dev/main.swift`). The `.app` bundle gets this from Launch Services and
  doesn't need it.
- **Microphone permission belongs to your terminal.** macOS attributes an unbundled process's
  TCC identity to the app that launched it (Terminal, iTerm, cmux, …). The first run prompts
  for *that* app; if it was ever denied, fix it in *System Settings › Privacy & Security ›
  Microphone* for the terminal you launch from. A missing device or denied permission is not
  silent: the HUD shows `mic FAILED: …` (`AppBootstrap.start()`), and otherwise shows the
  input format it is analysing. If the ring and bottom waveform stay flat, look there first.

## Tests

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app
```

**Why `DEVELOPER_DIR`.** If `xcode-select -p` prints `/Library/Developer/CommandLineTools`, a
plain `swift test` dies with `error: no such module 'XCTest'` — against whichever test file it
happens to compile first, which makes it look like that file's fault. It isn't; the Command
Line Tools simply don't ship XCTest. The variable points one command at `Xcode.app`'s toolchain
with no `sudo` and no global side effect. (`sudo xcode-select -s /Applications/Xcode.app` is
the permanent alternative.) `swift build` / `swift run` never need it.

Run one suite or one test:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app \
  --filter GestureLockTests
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test --package-path app \
  --filter 'KeyboardSurfaceTests/testModifiersSelectTheTargetAndSensitivityScales'
```

**What "green" means right now.** The suite is 264 tests and exactly one of them fails on
purpose: `GoldenFrameTests.testAllScenariosMatchReferences`. `Tests/FeedbaxKitTests/
GoldenReferences/` is deliberately empty — the header of `GoldenFrameTests.swift` explains
that the previous generation of references froze a real bug (the loop saturating to white) in
place for months, and that nothing gets blessed until that is fixed. Everything else must
pass. Do **not** set `FEEDBAX_REGEN_GOLDEN=1` to make it green: that writes references from
whatever the engine draws today and exists only for deliberately blessing a look you have
opened and judged by eye (it also refuses to write a flat or clipped frame).

The engine tests build real Metal pipelines against the default GPU, so run them on a Mac
with one — they are not headless-CI friendly.

Where tests live: `Tests/FeedbaxKitTests/`, roughly one file per source file
(`GestureLock.swift` → `GestureLockTests.swift`). `Fixtures/` holds the committed 32×32 glyph PNG and a short movie;
`TestSupport/` generates fixtures that are cheaper to synthesise than to commit.

## The `Feedbax.app` bundle (Xcode)

The everyday loop doesn't need Xcode, but the bundle is what a performer double-clicks and what
gets a proper TCC identity, `Info.plist`, and entitlements.

```sh
cd app
xcodegen generate      # writes Feedbax.xcodeproj (gitignored) from project.yml
open Feedbax.xcodeproj # or: xcodebuild -scheme Feedbax -configuration Release build
```

`project.yml` declares one `Feedbax` application target built from `App/` — the `@main`
entry (`FeedbaxApp.swift`), the `Info.plist` with the microphone usage string, and the
`audio-input` entitlement — depending on the `FeedbaxKit` product from this same
`Package.swift`. That is why `Package.swift` declares `FeedbaxKit` as an explicit library
product: XcodeGen resolves package dependencies by *product* name, not target name.

Both entry points call the same `AppBootstrap.start()` and show the same `FeedbaxScenes`, so
`feedbax-dev` and `Feedbax.app` cannot drift; each adds only what its packaging requires.
Re-run `xcodegen generate` after editing `project.yml`; source changes need nothing — the
project references the package, not individual files.

## The performance gate (soak mode)

`feedbax-dev --soak` runs the engine headless — no window, no display link — and prints frame
time percentiles against the design's P1 gate (p99 < 16.7 ms at 8K/60):

```sh
swift run --package-path app -c release feedbax-dev --soak 7680x4320@60 --seconds 60
```

`--seconds N` counts *simulated* frames (`N × fps`), not wall-clock time — the loop is unpaced
and a fast GPU finishes "60 s" in a few real seconds, so this is a frame-time-margin check,
not a thermal soak. `--accumulator-format rgba16f` selects the higher-precision accumulator.
Exit status is 0 on PASS, 1 on FAIL, 64 on a malformed flag. Numbers recorded so far, and how
to get a genuinely time-bounded run, are in
[`docs/superpowers/plans/p1-soak-gate.md`](../docs/superpowers/plans/p1-soak-gate.md).

## Layout

```
app/
  Package.swift                 SwiftPM manifest: FeedbaxKit (library), feedbax-dev, FeedbaxKitTests
  project.yml                   XcodeGen spec for the Feedbax.app target
  App/                          the bundle's @main, Info.plist, entitlements — nothing else
  Sources/
    feedbax-dev/main.swift      dev entry point + the --soak runner
    FeedbaxKit/
      Engine/                   Engine (the frame recipe), FeedbackCore, WarpPass, Compositor,
                                OutputStage, FrameClock/EngineHost (the display link), StillCapture,
                                GoldenRunner (deterministic headless stepping for tests)
      Shaders/                  the .metal sources (WarpHSL, Composite, Filters)
      ShaderMath/               CPU mirrors of every shader function — RotaFold, HSL, Brcosa,
                                Keyers, MaxScale — pinned to hand-computed values by tests
      Filters/                  TextureFilter protocol + Brcosa, LumaKey, ChromaKey
      Sources/                  SeedSource protocol + StickerSource, MovieSource
      Audio/                    AudioAnalysis (the one AVAudioEngine user), Biquad bands,
                                envelope followers, WaveBuffer
      Control/                  ControlVector/ControlRouter (the 9-slot truth), ControlAxis,
                                Bindings + DefaultBindings.json + BindingsStore, the keyboard/
                                trackpad and gamepad surfaces, GestureLock, Presets,
                                ControlReference
      UI/                       AppBootstrap, FeedbaxScenes (the three windows), OperatorPanel,
                                XYPad, ControlsReferenceView, RenderView, PerformerInputMonitor,
                                EngineViewModel
  Tests/FeedbaxKitTests/        one test file per source file, plus Fixtures/, GoldenReferences/,
                                TestSupport/
```

### Where it writes on disk

| What | Where |
|---|---|
| Stickers (read) | `input/transparent-background/` under the CWD, else `~/Pictures/Feedbax/stickers/` |
| Stills (`s`) | `~/Pictures/Feedbax/feedbaxStill-YYYY-MM-DD-HHMMSS.png` |
| Presets | `~/Library/Application Support/Feedbax/Presets/<name>.json` |
| Your bindings | `~/Library/Application Support/Feedbax/Bindings.json` — an *overlay* on the bundled `DefaultBindings.json`: only the sections it contains override, so pad assignments persist without freezing the key table |

Deleting `~/Library/Application Support/Feedbax/` returns the app to its bundled defaults.

## How to change things

- **Behaviour is specified before it is coded.** The Max original's behaviour is in
  `docs/spec/` (cite it as `spec §04 §1.1`); the port's own decisions are in
  `docs/superpowers/specs/*-design.md` (cite as `design §6.5`), each with a matching
  task-by-task plan in `docs/superpowers/plans/`. Comments in the code cite those sections —
  keep doing that, so a reader can always find the *why*. Each design doc ends with a
  "Swift notes for the reader" section; this codebase is written to teach the language as
  much as to run.
- **Keys, gestures, and pads live in data.** A new binding, a different key, or a gesture
  that reads backwards is a change to `Control/DefaultBindings.json` (a sign flip is the row's
  `sensitivity`), never to code. The Controls Reference window and the tests that check every
  row is documented pick it up automatically.
- **`Engine.step` stays pure.** No live devices, clocks, or windows inside `Engine` — that is
  what makes the determinism and golden tests possible. The microphone starts in
  `AppBootstrap`, the display link lives in `EngineHost`, and the operator UI is just another
  `ControlSurface`, not a privileged path.
- **Tests below SwiftUI, a run pass above it.** Everything under the views is unit-tested —
  write the failing test first. Views are verified by `swift build` plus a real
  `swift run --package-path app feedbax-dev` pass; trackpad pinch/twist cannot be synthesised
  (macOS has no public API for a fake magnify/rotate event), so those rows are checked by
  hand and the outcome recorded in the design doc.
- **Style.** Two-space indent, ~100-column lines, doc comments that say *why*. Commits use
  [Conventional Commits](https://www.conventionalcommits.org/) (`feat(control): …`,
  `fix(input): …`, `docs: …`). Work happens on a branch in a git worktree under
  `.claude/worktrees/` (gitignored).
