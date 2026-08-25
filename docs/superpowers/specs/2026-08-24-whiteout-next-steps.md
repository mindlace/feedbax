# Whiteout Investigation — State and Next Steps

**Date:** 2026-08-24
**Branch:** `worktree-reimplementation-proposal`
**Status:** three root causes fixed and committed; a fourth is open and blocking

## Where things stand

The instrument no longer washes to white **on the default path**. Three root
causes were found and fixed, each confirmed by measuring the running Max patch
rather than reading its JSON (see commit for detail):

1. `maxScale` implemented Max's modern-mode `scale`; the object defaults to
   `classic 1`, where fractional exponents are ignored. HSL deltas were 2–73×
   too large.
2. `startupVector` used the loadbang message, which the real patch discards
   137 ms after load.
3. The ramps' cold-start seeds treated gen `param` defaults as a glide origin,
   clipping frames 3–6 to white.

Also fixed: `GamepadSurface` re-asserted every poll and clobbered slider moves.

Correctness now lives in `EngineInvariantTests` — each invariant verified to
*fail* when its bug is reintroduced — and in `EngineWiringTests`. The golden
snapshots are demoted to labelled change-detectors.

## The open defect — loop saturates with any seed layer

**With a seed layer enabled the loop reaches 100% clipped white by frame 10.**
Layer off, it converges to mean luminance 0.772 with zero clipped pixels.

This is not a harness artifact. It is the instrument's actual purpose — content
through the loop — and it is why `GoldenReferences/` is empty: regeneration
refused to bless three references that came out as a single unique colour,
`#FFFFFFFF`.

Measured on the `rota-spiral` configuration (192×108, sticker on, erase 0.55,
zoom 0.9, theta 0.2), white by frame 9–10 under **every** variation tried:

| variation | result |
|---|---|
| real startup HSL (lightness −0.01/frame) | white by f10 |
| retired no-drift pins (lightness exactly 0) | white by f9 |
| bias raw −1 (−0.04/frame, the strongest restoring value the map can produce) | mean 0.9996, 80.8% clipped from f10 |
| erase raw 1.0 (full clear) | mean 0.9916 |
| seed layer **off** | mean 0.894, variance 0.0157, **0% clipped** |

No achievable control setting rescues it. The gain is structural, not a
mis-mapped parameter — which makes it a different *kind* of bug from the three
already fixed, and means the control-path methods that solved those won't apply.

### What we already know about the original

This is the strong constraint. The original was measured at loop gain **exactly
×1.0000 over 120 samples**, holding mean luminance 0.386 flat for 106 seconds —
**with content flowing**, since its audio waveform layer (`soundwave_enable`) is
live at load. So unity gain plus fresh content is demonstrably stable in the
original and divergent in the port. The difference is in how fresh content
composites, not in the retention of the feedback plane.

Confirmed faithful already, so *not* worth re-checking: blend mode (`6 8` =
`SRC_ALPHA`/`DST_ALPHA`), feedback plane colour alpha (1.0), erase alpha (1.0,
a hard `glClear`), texture alpha (1.0 everywhere, measured on both taps).

## Next steps, in order

### 1. Chase the alpha channel of fresh content — leading hypothesis

The feedback composite is `RGB' = As·S + Ad·D`, so **`Ad` — the destination
alpha — is the exact per-frame multiplier on retained content.** Everything
that writes into the destination before the feedback plane draws therefore sets
the loop's gain.

The suggestive detail: the port's sticker folder is literally
`input/transparent-background/`, and the original's assets are named
`NormalFullAlpha1080p1.png`. This content is authored with alpha. If drawing a
layer in the original lowers destination alpha, then `Ad < 1` and the retained
feedback is attenuated exactly where content was drawn — a per-pixel decay that
appears *only when a layer is on*, which is precisely the observed signature.

Check, in this order:
- What does the port's `.alphaOver` blend do to the **alpha channel** when
  drawing seeds/layers? Its RGB factors may be right while its alpha factors
  leave destination alpha pinned at 1.
- In the original, measure destination alpha inside the `fb` node *after* the
  layer draws and *before* the feedback plane draws. That number is the loop
  gain we're missing.
- Compare draw order and layering: original draws layers at 2/3 then the
  feedback plane over at layer 10; confirm the port's seed/waveform/feedback
  ordering and blend factors match.

### 2. Resolve the bistability discrepancy

`DriftMeasurement`'s settled (`at: -1`) no-layer run reportedly creeps to white
by frame 300, while an equivalent `applyPreset(at: -1)` run converges to 0.772.
Both cannot be right. This may be an artifact of concurrent edits during the
session, or it may mean the bounded state is fragile. Reproduce both before
trusting either. Do not explain it away.

### 3. Re-bless the golden references

Blocked on step 1. When the loop is stable with a layer, regenerate — the
regen path now refuses to write a reference whose variance is below 1e-6, so
it cannot silently re-freeze a defect. Inspect every image before accepting.

### 4. Correct `docs/spec/`

The spec is wrong in ways we have now measured, and it is the upstream source
for the port:
- §01 §2 erase-alpha figures (`f=0.5 → 0.825`, etc.) are the modern-mode curve.
  The real values are 0.9155 at half travel; the curve is biased **high**, not
  low as the prose claims.
- §01 §2's `(1−a)ⁿ` residual describes the old gl2 `jit.gl.render` path, not the
  `jit.gl.node` the patch now uses, where erase is a hard clear contributing no
  decay.
- §01 §4's mapping table needs the classic-mode note: exponents ≤ 1 are ignored.
- The startup vector section should record that the loadbang vector is
  superseded, and name the two mechanisms.

### 5. Control/display split

Design is written and awaiting review:
`docs/superpowers/specs/2026-08-24-control-display-split-design.md`.
Independent of the whiteout work; can proceed in parallel. One open question
there: whether the windowless frame clock runs at full rate (recommended —
throttling makes the loop's evolution depend on whether anyone was watching).

## Method note

Every value that reaches a shader should be **measured from the running patch**,
not read from the `.maxpat` JSON and not taken from `docs/spec`. That method has
now produced three wrong values that each survived review and got frozen into
the test suite. Probe technique, Max gotchas, and the historical patch archive
location are recorded in the session memory file
`measure-running-max-not-the-spec`.
