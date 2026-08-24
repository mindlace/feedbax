# P1 soak gate: 8K/60 frame-time

Design §10's P1 "Proves" column: Feedbax.app "sustains 8K/60 for ≥ 10 min at parity defaults on
a base M4 mini (p99 frame time < 16.7 ms, measured by a built-in frame-time HUD)". This doc is
that HUD's CLI form (`feedbax-dev --soak`), how to run it, and this machine's recorded numbers.

## Gate definition

- **Resolution/rate:** 7680×4320 @ 60 Hz (design §4's 8K feasibility case).
- **Duration:** ≥ 10 minutes continuous (the RELEASE gate — see below). A 60 s run is the dev-
  machine smoke test; it is not a substitute for the 10-minute run.
- **Config:** parity defaults (`ControlRouter.applyStartupDefaults`, the same webUI-parity
  startup vector `AppBootstrap.start()` applies for a real session) + sticker layer enabled +
  waveforms at their own parity default (`wave1Enabled == true` out of the box).
- **Metric:** p99 frame time < 16.7 ms.
- **Machine:** design §4/§10 both specify "a base M4 mini" as the target hardware for the
  RELEASE gate. That is a specific, separate machine from whatever ran the numbers below.

## How to run

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  swift run --package-path app -c release feedbax-dev --soak 7680x4320@60 --seconds 60
```

- `--soak WxH@fps` — canvas size and frame rate, e.g. `7680x4320@60`.
- `--seconds N` — how long to run, in simulated seconds (default 60). **The RELEASE gate is
  `--seconds 600` (10 minutes) run on a base M4 mini** — see "Release gate" below.
- `--accumulator-format rgba8|rgba16f` — optional; selects the accumulator's pixel format
  (design §4's "RGBA16F as a quality toggle where bandwidth allows"). Default `rgba8`, the
  original's effective depth.

The process exits 0 on PASS (frame p99 < 16.7 ms) and 1 on FAIL, so it can gate CI the same way
any other check does. A malformed `--soak` value (bad `WxH@fps`, unknown accumulator format)
exits 64 with a usage message rather than silently falling through to the windowed app.

### What it measures

The soak builds a headless `Engine` (its own `MetalContext`, no `AppBootstrap`/live microphone
— the same headless convention `GoldenRunner.render` uses, not `AppBootstrap.start()`'s
windowed-app one) and drives it with a **tight loop**: encode a frame, commit, then
`waitUntilCompleted()` before starting the next. There is no display link and no cross-frame
overlap — GPU execution for frame N and CPU encoding for frame N+1 never happen concurrently,
unlike a live triple-buffered `FrameClock`. That makes this loop's numbers a **conservative
(pessimistic) stand-in** for the real, overlapped frame time the gate is actually about: a PASS
here is a safe PASS.

Three timings are collected per frame and reported as p50/p95/p99/max:

- **CPU ms** — host-clock (`DispatchTime`) wall time from starting `engine.step` through
  `commandBuffer.commit()` returning. CPU-side encode/submit cost only; excludes the blocking
  wait.
- **GPU ms** — the command buffer's own `gpuEndTime - gpuStartTime`. Actual device execution
  time, available once the buffer has completed.
- **Frame ms** — the full wall-clock loop iteration, encode through `waitUntilCompleted`
  returning. **This is what's graded against the 16.7 ms gate** — in this serial loop it's what
  actually bounds achievable throughput, and (per above) it's a pessimistic proxy for the real,
  overlapped number a live session would see.

The sticker folder (`input/transparent-background/`) is empty in a fresh checkout;
`StickerSource.tick` tolerates that by returning `nil` (see its own doc comment), so the layer
draws nothing but every other stage of the frame recipe — erase, warp, composite, waveform
overlay — still runs exactly as it would with a folder full of stickers. This soak did not
synthesize a placeholder sticker image; it ran with the empty folder as-is (the brief's
explicitly-allowed simpler option).

## This machine's recorded results (dev-machine smoke, NOT the release gate)

- **Machine:** MacBook Pro, Apple M5 Pro chip, 24 GB memory (`system_profiler
  SPHardwareDataType`).
- **CPU:** `Apple M5 Pro` (`sysctl -n machdep.cpu.brand_string`).
- **OS:** macOS 26.5.1 (build 25F80) (`sw_vers`).
- **Toolchain:** Xcode's Swift toolchain via `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer`,
  `swift build -c release`.

This is **not** the base M4 mini design §10 specifies for the release gate — it's whatever
development machine this task happened to run on, and it's a different (likely faster) chip
tier. These numbers demonstrate the harness works and give an early read; they do not satisfy
design §10's release-gate requirement on their own. See "Release gate" below.

### 60 s smoke, 7680×4320@60, rgba8 accumulator (default)

```
feedbax-dev --soak: 7680x4320@60 for 60s, accumulator=rgba8
  ...60/3600 frames (1s simulated)
  ...120/3600 frames (2s simulated)
  ...180/3600 frames (3s simulated)
  ...240/3600 frames (4s simulated)
  ...300/3600 frames (5s simulated)
  ...360/3600 frames (6s simulated)
  ...420/3600 frames (7s simulated)
  ...480/3600 frames (8s simulated)
  ...540/3600 frames (9s simulated)
  ...600/3600 frames (10s simulated)
  ...660/3600 frames (11s simulated)
  ...720/3600 frames (12s simulated)
  ...780/3600 frames (13s simulated)
  ...840/3600 frames (14s simulated)
  ...900/3600 frames (15s simulated)
  ...960/3600 frames (16s simulated)
  ...1020/3600 frames (17s simulated)
  ...1080/3600 frames (18s simulated)
  ...1140/3600 frames (19s simulated)
  ...1200/3600 frames (20s simulated)
  ...1260/3600 frames (21s simulated)
  ...1320/3600 frames (22s simulated)
  ...1380/3600 frames (23s simulated)
  ...1440/3600 frames (24s simulated)
  ...1500/3600 frames (25s simulated)
  ...1560/3600 frames (26s simulated)
  ...1620/3600 frames (27s simulated)
  ...1680/3600 frames (28s simulated)
  ...1740/3600 frames (29s simulated)
  ...1800/3600 frames (30s simulated)
  ...1860/3600 frames (31s simulated)
  ...1920/3600 frames (32s simulated)
  ...1980/3600 frames (33s simulated)
  ...2040/3600 frames (34s simulated)
  ...2100/3600 frames (35s simulated)
  ...2160/3600 frames (36s simulated)
  ...2220/3600 frames (37s simulated)
  ...2280/3600 frames (38s simulated)
  ...2340/3600 frames (39s simulated)
  ...2400/3600 frames (40s simulated)
  ...2460/3600 frames (41s simulated)
  ...2520/3600 frames (42s simulated)
  ...2580/3600 frames (43s simulated)
  ...2640/3600 frames (44s simulated)
  ...2700/3600 frames (45s simulated)
  ...2760/3600 frames (46s simulated)
  ...2820/3600 frames (47s simulated)
  ...2880/3600 frames (48s simulated)
  ...2940/3600 frames (49s simulated)
  ...3000/3600 frames (50s simulated)
  ...3060/3600 frames (51s simulated)
  ...3120/3600 frames (52s simulated)
  ...3180/3600 frames (53s simulated)
  ...3240/3600 frames (54s simulated)
  ...3300/3600 frames (55s simulated)
  ...3360/3600 frames (56s simulated)
  ...3420/3600 frames (57s simulated)
  ...3480/3600 frames (58s simulated)
  ...3540/3600 frames (59s simulated)
  ...3600/3600 frames (60s simulated)
CPU  : p50=0.058ms p95=0.064ms p99=0.072ms max=0.353ms
GPU  : p50=1.941ms p95=1.947ms p99=2.063ms max=8.578ms
Frame: p50=2.171ms p95=2.229ms p99=2.306ms max=17.073ms
PASS: frame p99 2.306ms < 16.700ms gate
```

**PASS.** Frame p99 = 2.306 ms, ~7.2x under the 16.7 ms gate. One outlier frame hit 17.073 ms
max (a single frame over the gate threshold, likely a scheduling/first-touch hiccup — not
reflected in p99, which is what's graded).

### 30 s variant, 7680×4320@60, rgba16Float accumulator (quality-toggle headroom check)

The accumulator quality toggle (design §4: "RGBA16F as a quality toggle where bandwidth
allows") is reachable via `--accumulator-format rgba16f` — `Engine.init` took an
`accumulatorFormat` parameter already threaded through to `FeedbackCore`/`QuadRenderer`/
`WaveformRenderer` (all already accepted a `pixelFormat` argument); the only change needed was
exposing it instead of hardcoding `.rgba8Unorm`.

```
feedbax-dev --soak: 7680x4320@60 for 30s, accumulator=rgba16f
  ...60/1800 frames (1s simulated)
  ...120/1800 frames (2s simulated)
  ...180/1800 frames (3s simulated)
  ...240/1800 frames (4s simulated)
  ...300/1800 frames (5s simulated)
  ...360/1800 frames (6s simulated)
  ...420/1800 frames (7s simulated)
  ...480/1800 frames (8s simulated)
  ...540/1800 frames (9s simulated)
  ...600/1800 frames (10s simulated)
  ...660/1800 frames (11s simulated)
  ...720/1800 frames (12s simulated)
  ...780/1800 frames (13s simulated)
  ...840/1800 frames (14s simulated)
  ...900/1800 frames (15s simulated)
  ...960/1800 frames (16s simulated)
  ...1020/1800 frames (17s simulated)
  ...1080/1800 frames (18s simulated)
  ...1140/1800 frames (19s simulated)
  ...1200/1800 frames (20s simulated)
  ...1260/1800 frames (21s simulated)
  ...1320/1800 frames (22s simulated)
  ...1380/1800 frames (23s simulated)
  ...1440/1800 frames (24s simulated)
  ...1500/1800 frames (25s simulated)
  ...1560/1800 frames (26s simulated)
  ...1620/1800 frames (27s simulated)
  ...1680/1800 frames (28s simulated)
  ...1740/1800 frames (29s simulated)
  ...1800/1800 frames (30s simulated)
CPU  : p50=0.059ms p95=0.063ms p99=0.071ms max=0.390ms
GPU  : p50=2.074ms p95=2.079ms p99=2.216ms max=8.690ms
Frame: p50=2.308ms p95=2.369ms p99=2.456ms max=20.250ms
PASS: frame p99 2.456ms < 16.700ms gate
```

**PASS.** Frame p99 = 2.456 ms, ~6.8x under the gate. RGBA16F costs roughly 6-7% more GPU time
than rgba8 at the same res/rate on this machine (GPU p99 2.216 ms vs 2.063 ms) — comfortably
inside the headroom design §4's bandwidth estimate (~46 GB/s at 8K60 for RGBA16F) predicted.

### Full test suite

`swift test --package-path app` — 91 tests, 0 failures, after the `Engine.init` signature
change (added `accumulatorFormat` as a defaulted parameter). No regressions.

## Release gate (separate, manual — not done here)

Design §10's actual P1 gate is **10 minutes at 7680×4320@60 on a base M4 mini** — a specific
machine at a performance venue, not this development machine. That run is:

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  swift run --package-path app -c release feedbax-dev --soak 7680x4320@60 --seconds 600
```

**This has not been run and is not satisfied by the numbers in this document.** It needs to
happen, once, on the actual base M4 mini hardware the instrument will perform on, and the
result recorded (append a new section to this file, or a follow-up doc) before design §10's P1
"Proves" claim can be considered verified. The base M4 mini is a lower GPU-core-count part than
this dev machine, so the smoke numbers above — while comfortably under gate — are not a
substitute for that run: they establish the harness works and give an early margin estimate,
not the release verdict.
