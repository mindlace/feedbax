# P1 soak gate: 8K/60 frame-time

Design §10's P1 "Proves" column: Feedbax.app "sustains 8K/60 for ≥ 10 min at parity defaults on
a base M4 mini (p99 frame time < 16.7 ms, measured by a built-in frame-time HUD)". This doc is
that HUD's CLI form (`feedbax-dev --soak`), how to run it, and this machine's recorded numbers.

## Gate definition

- **Resolution/rate:** 7680×4320 @ 60 Hz (design §4's 8K feasibility case).
- **Duration:** ≥ 10 REAL minutes continuous (the RELEASE gate — see "Release gate" below, and
  "Simulated duration vs. wall clock" for why `--seconds 600` alone isn't automatically that).
  The `--seconds 60`/`--seconds 30` runs recorded below are dev-machine smoke tests only — they
  ran for a few real seconds each (see their `Elapsed:` lines), not 60/30 real seconds, and are
  not a substitute for the 10-real-minute run.
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
- `--seconds N` — how many **simulated** seconds to run (default 60; a positive number, can be
  fractional). **Read "Simulated duration vs. wall clock" below before treating this as a
  stopwatch** — it is not one. See "Release gate" for what value actually reaches 10 real
  minutes.
- `--accumulator-format rgba8|rgba16f` — optional; selects the accumulator's pixel format
  (design §4's "RGBA16F as a quality toggle where bandwidth allows"). Default `rgba8`, the
  original's effective depth.

The process exits 0 on PASS (frame p99 < 16.7 ms) and 1 on FAIL, so it can gate CI the same way
any other check does. A malformed or missing-value `--soak`, `--seconds`, or
`--accumulator-format` (bad `WxH@fps`, non-numeric/zero/negative seconds, unknown format name)
exits 64 with a usage message rather than silently falling through to the windowed app or
silently defaulting.

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

- **CPU ms** — host-clock (`DispatchTime`) wall time from just before creating that frame's
  command buffer through `commandBuffer.commit()` returning (command-buffer creation +
  `engine.step`'s encode + `commit()`'s submit). CPU-side cost only; excludes the blocking wait.
- **GPU ms** — the command buffer's own `gpuEndTime - gpuStartTime`. Actual device execution
  time, available once the buffer has completed.
- **Frame ms** — the full wall-clock loop iteration, encode through `waitUntilCompleted`
  returning. **This is what's graded against the 16.7 ms gate** — in this serial loop it's what
  actually bounds achievable throughput, and (per above) it's a pessimistic proxy for the real,
  overlapped number a live session would see.

After the per-frame percentiles, an **`Elapsed:`** line reports the real wall-clock time the
whole loop took, alongside the simulated duration it corresponds to — see "Simulated duration
vs. wall clock" immediately below for why that line exists and matters.

The sticker folder (`input/transparent-background/`) is empty in a fresh checkout;
`StickerSource.tick` tolerates that by returning `nil` (see its own doc comment), so the layer
draws nothing but every other stage of the frame recipe — erase, warp, composite, waveform
overlay — still runs exactly as it would with a folder full of stickers. This soak did not
synthesize a placeholder sticker image; it ran with the empty folder as-is (the brief's
explicitly-allowed simpler option).

### Simulated duration vs. wall clock

**`--seconds N` is UNPACED — it is not a stopwatch.** It sets `frameCount = N × fps`, the number
of frames the loop runs, each stamped with `time = frameIndex / fps` for the engine's own clock.
Nothing throttles the loop to actually take N real seconds: it rips through frames back-to-back
as fast as `waitUntilCompleted` allows, with zero pacing/sleep between them. On a GPU that's
comfortably under budget (as recorded below), the real wall-clock time is much SHORTER than the
simulated duration — a `--soak 7680x4320@60 --seconds 60` run recorded 60 s of *simulated*
timeline in **7.86 s of real time** on this machine (see the recorded transcript below; its
`Elapsed:` line says so directly).

The practical consequence: **`--seconds 600` does NOT run for 10 real-world minutes**, and is
therefore, by itself, **not a genuine sustained/thermal soak** — it's the same GPU work at 10x
the simulated-frame count, finished in a small fraction of 10 real minutes. That matters because
the whole point of design §10's "≥ 10 min" gate is to catch things an 8-second burst can't:
thermal throttling, driver/allocator drift, memory growth, anything that only shows up under
sustained real-time load. A high `--seconds` value alone proves none of that.

Two ways to get an actual ≥10-real-minute run, both spelled out in "Release gate" below:

1. **Run the live app**, fullscreen, at 8K/60, for 10 real minutes, watching the built-in
   frame-time HUD — design §10's own wording ("measured by a built-in frame-time HUD"). This is
   real-time by construction (paced by the display link) and is the release gate's primary,
   intended form.
2. **Or**, if driving it through `feedbax-dev --soak` specifically is preferred: pick a
   `--seconds` value large enough that the printed `Elapsed:` wall-clock time reaches ≥ 600 s on
   the TARGET machine. That value is machine- and GPU-load-dependent — it must be derived from a
   short calibration run on that specific machine, not assumed from these dev-machine numbers
   (see the worked example in "Release gate").

Either way, always check the printed `Elapsed:` line — it is the actual wall-clock time that
run took, and is the only number in this soak's output that answers "did this really run for 10
minutes."

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
CPU  : p50=0.058ms p95=0.063ms p99=0.073ms max=0.360ms
GPU  : p50=1.940ms p95=1.946ms p99=2.066ms max=8.691ms
Frame: p50=2.171ms p95=2.232ms p99=2.307ms max=20.117ms
Elapsed: 7.86s wall-clock (unpaced) for 60s simulated (3600 frames @ 60fps)
PASS: frame p99 2.307ms < 16.700ms gate
```

**PASS.** Frame p99 = 2.307 ms, ~7.2x under the 16.7 ms gate. One outlier frame hit 20.117 ms
max (a single frame over the gate threshold, likely a scheduling/first-touch hiccup — not
reflected in p99, which is what's graded). **`Elapsed: 7.86s`** — this "60 s" smoke actually
took 7.86 real seconds, not 60: see "Simulated duration vs. wall clock" above. This is a
frame-time-margin check, not a 10-minute sustained-load check.

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
CPU  : p50=0.058ms p95=0.064ms p99=0.073ms max=0.380ms
GPU  : p50=2.075ms p95=2.080ms p99=2.215ms max=8.612ms
Frame: p50=2.307ms p95=2.371ms p99=2.460ms max=20.918ms
Elapsed: 4.19s wall-clock (unpaced) for 30s simulated (1800 frames @ 60fps)
PASS: frame p99 2.460ms < 16.700ms gate
```

**PASS.** Frame p99 = 2.460 ms, ~6.8x under the gate. RGBA16F costs roughly 6-7% more GPU time
than rgba8 at the same res/rate on this machine (GPU p99 2.215 ms vs 2.066 ms) — comfortably
inside the headroom design §4's bandwidth estimate (~46 GB/s at 8K60 for RGBA16F) predicted.
**`Elapsed: 4.19s`** — same caveat as the rgba8 run above: this "30 s" run took 4.19 real
seconds.

### Short smoke + fail-loudly checks (1920×1080@60, confirming the fixed CLI behavior)

A small, fast run to show the `Elapsed:` line clearly (10 s of *simulated* 1080p60 finishes in
well under half a real second on this machine):

```
feedbax-dev --soak: 1920x1080@60 for 10s, accumulator=rgba8
  ...60/600 frames (1s simulated)
  ...120/600 frames (2s simulated)
  ...180/600 frames (3s simulated)
  ...240/600 frames (4s simulated)
  ...300/600 frames (5s simulated)
  ...360/600 frames (6s simulated)
  ...420/600 frames (7s simulated)
  ...480/600 frames (8s simulated)
  ...540/600 frames (9s simulated)
  ...600/600 frames (10s simulated)
CPU  : p50=0.036ms p95=0.066ms p99=0.075ms max=0.263ms
GPU  : p50=0.397ms p95=0.583ms p99=0.591ms max=1.199ms
Frame: p50=0.619ms p95=0.917ms p99=0.996ms max=3.380ms
Elapsed: 0.38s wall-clock (unpaced) for 10s simulated (600 frames @ 60fps)
PASS: frame p99 0.996ms < 16.700ms gate
```

And three deliberately-malformed `--seconds` values, all now failing loudly (exit 64) instead
of silently falling back to the 60 s default:

```
$ feedbax-dev --soak 1920x1080@60 --seconds bogus
feedbax-dev: couldn't parse --seconds value 'bogus' — expected a positive number of simulated seconds
$ echo $?
64

$ feedbax-dev --soak 1920x1080@60 --seconds -5
feedbax-dev: couldn't parse --seconds value '-5' — expected a positive number of simulated seconds
$ echo $?
64

$ feedbax-dev --soak 1920x1080@60 --seconds
feedbax-dev: --seconds requires a value, e.g. --seconds 600
$ echo $?
64
```

### Full test suite

`swift test --package-path app` — 91 tests, 0 failures, after the `Engine.init` signature
change (added `accumulatorFormat` as a defaulted parameter) and the `--soak`/`--seconds`
CLI-parsing fixes. No regressions.

## Release gate (separate, manual — not done here)

Design §10's actual P1 gate is **10 real minutes at 7680×4320@60 on a base M4 mini** — a
specific machine at a performance venue, not this development machine, and (per "Simulated
duration vs. wall clock" above) **NOT the same thing as `--soak ... --seconds 600`** — that
invocation alone does not run for 10 real minutes and is not a genuine sustained/thermal soak.
Two ways to actually satisfy the gate, either is acceptable:

**Option A — run the live app (the release gate's primary, intended form).** Launch
`Feedbax.app` (or `feedbax-dev` without `--soak`) fullscreen at 7680×4320@60 with parity
defaults, and let it run for 10 real minutes while watching the built-in frame-time HUD —
design §10's own wording. This is real-time by construction (the display link paces it), so
there's no calibration step needed; just watch the HUD's p99 stay under 16.7 ms for the full 10
minutes.

**Option B — `feedbax-dev --soak` with a calibrated `--seconds`.** If driving it through the
CLI specifically is preferred, `--seconds` must be picked so the printed `Elapsed:` line reaches
≥ 600 s on the TARGET machine — not assumed from this doc's numbers. Calibrate with a short run
first:

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  swift run --package-path app -c release feedbax-dev --soak 7680x4320@60 --seconds 60
# read its "Elapsed: X.XXs wall-clock ... for 60s simulated" line, then:
#   secondsNeeded = 600 * 60 / X   (round up)
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  swift run --package-path app -c release feedbax-dev --soak 7680x4320@60 --seconds <secondsNeeded>
# confirm the run's own "Elapsed:" line actually reads >= 600s before trusting the PASS/FAIL
```

Worked example from THIS document's own calibration run (`Elapsed: 7.86s` for `--seconds 60`,
recorded above): `secondsNeeded = 600 * 60 / 7.86 ≈ 4580`. **This number is specific to this
dev machine and is not a prediction for the base M4 mini** — a base M4 mini has fewer GPU cores
and lower memory bandwidth, so its own `Elapsed:` ratio (and therefore the `--seconds` value
needed to reach 600 s) will very likely differ; recalibrate on that machine, don't reuse 4580.

**Neither option has been run yet, and the numbers in this document do not satisfy design §10's
gate on their own.** One of the two needs to happen, once, on the actual base M4 mini hardware
the instrument will perform on, and the result recorded (append a new section to this file, or
a follow-up doc) before design §10's P1 "Proves" claim can be considered verified. The smoke
numbers above establish the harness works and give an early frame-time-margin estimate — not a
sustained-load result, and not the release verdict.
