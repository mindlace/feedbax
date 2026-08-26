# Whiteout Investigation — State and Next Steps

**Date:** 2026-08-24 (rewritten later the same day)
**Branch:** `worktree-reimplementation-proposal`
**Status:** four root causes fixed; the "seed layer saturates" finding is reframed
as expected behaviour pending one like-for-like Max measurement

## Method change — read this before doing anything else

The previous pass chased stage hypotheses one at a time (alpha channel, draw
order, blend factors) for hours. That is the wrong shape for a recursive
system: no single stage's gain tells you the loop's fate. The right first step
is to write the **loop map** — the per-pixel function one whole cycle applies,
`x' = F(x; controls)` — for both the port and the original, straight from
their execution graphs, and then fuzz it. Two things that pass produced in one
derivation each, which the stage-by-stage approach missed:

1. A gain term in the port that exists for every erase value below 1.0.
2. That the scenario used as evidence for the "open defect" is one the
   original cannot sustain either.

Also: the earlier "strong constraint" — *the original holds loop gain exactly
×1.0000 with content flowing* — is an **equilibrium ratio**, not a retention
gain. At any fixed point the frame-to-frame ratio is 1.0 by definition. It said
the original sits at `x* = c/(1−g)`; it said nothing about `g`.

## The two loop maps

Per pixel, one cycle. `W` = previous frame after the rota/HSL warp, `Aw` its
alpha (measured 1.0 on both taps in the original; clamps to 1 by frame 2 in the
port), `S`/`As` = fresh content and its alpha, `a` = mapped erase alpha,
`Ad` = destination alpha when the plane draws.

**Original (post-retrofit `Feedbax.maxpat`, verified against the JSON):**

```
clear fb to (0,0,0,a)                    jit.gl.node — hard FBO clear
draw sticker   @layer 2  (jit.gl.layer, blend state unforced = Jitter default)
draw waves     @layer 3  (wave1 6 7, wave2 6 8)
draw plane     @layer 10 (6 8 = SRC_ALPHA, DST_ALPHA):  rgb' = Aw·W + Ad·D
capture → td.rota → HSL → next W

⇒  x' = T(x) + Ad·D          retention exactly 1; content is ADDED, then clipped
```

**Port before this pass (`FeedbackCore.renderFrame`):**

```
erase kernel:  rgb = mix(prev, black, a), α = a² + (1−a)·prevα   ← soft mix, gl2 model
seeds alpha-over, plane (SRC_ALPHA, DST_ALPHA) over that

⇒  x' = T(x) + Ad·(1−a)·x + Ad·As·S
                ^^^^^^^^^^^^  a second copy of the previous frame, added, not blended
```

Retention `1 + Ad·(1−a)`: 1.0 only at `a = 1` (the cold-start value), 1.07 at
erase 0.55, 1.2 at the bottom of the knob. The loop has no loss term except the
HSL lightness delta (−0.01/frame at startup) and off-frame transport, so any
control surface that lowers erase makes the app climb to white with no content
at all. This is the "bleeds to oversaturation" the app shows and the Max patch
does not — in the retrofit patch the erase control is inert on gain.

## Fixed in this pass

**Root cause 4 — erase residual added by the additive composite.** The erase
is now the render pass's hard `.clear` to `(eraseColor, eraseAlpha)`
(`FeedbackCore.renderFrame`; the `fbx_erase` kernel is gone). Measured with no
injection, identity geometry, mid-grey seed on frame 0 only
(`LoopStabilityTests.testRetentionWithoutInjectionNeverExceedsUnityAcrossEraseValues`):

| erase | mapped a | before: mean@f30 | after: mean@f30 |
|---|---|---|---|
| 1.00 | 1.000 | 0.149 (decays) | 0.149 |
| 0.90 | 0.979 | 0.502 (frozen — gain 1.02 cancelled the drift) | 0.149 |
| 0.75 | 0.952 | **1.000** | 0.149 |
| 0.55 | 0.922 | **1.000** | 0.149 |
| 0.00 | 0.800 | **1.000** | 0.149 |

Every erase value now decays along the same curve, i.e. erase no longer touches
gain — faithful to the retrofit patch. `FeedbackCoreTests` asserts the hard
clear; the old `(1−a)ⁿ` residual test (which enshrined the gl2 model) is gone.
Spec §01 §2 and §6 are corrected (mapping curve, hard clear, pseudo-code).

Consequence to be aware of: **the erase control is now inert**, exactly as in
the current Max patch. If Sean's trail-length feel is wanted back, that is a
design decision, not a bug — implement it as a brightness multiply `< 1` after
the HSL stage (`docs/diagnosis-2026-08-23.md`, "Trail-fade parity"), which is
a true retention term and cannot exceed unity.

## Reframed — a permanently drawn opaque seed saturates in both systems

With the sticker permanently enabled, the port clips by frame 2–5 under every
geometry and settles on a bright rail (startup geometry + theta 0.2: mean 0.965,
34 % of pixels white). The previous pass called this the open defect. By the
loop map above it is what the original does too: `rgb' = W + Ad·S` at every
sticker pixel every frame, clamped at 1.0 — clipping *is* the instrument's
bounded nonlinearity. Whether white then spreads is a transport question:
mapped zoom > 1 magnifies 16 %/frame at the `rota-spiral` setting (white frame
in < 10 frames); the startup zoom (0.7) shrinks content, and boundmode 4's
mirror-fold tiles the rest of the frame with reflected copies. The −0.01/frame
lightness delta fades transported copies over ~100 frames; it cannot fade a
pixel that is re-injected every frame.

The comparison the previous pass made was **port-with-sticker versus
original-with-only-the-waveform**. Like-for-like has not been measured.

What `LoopStabilityTests` asserts instead (all passing):
- Unseeded startup + rotation is bounded and non-degenerate (the owner's
  acceptance scenario — "from defaults, rotate").
- With injection removed after 20 seeded frames, the loop relaxes under 12
  fuzzed geometry/erase vectors: no clipped pixel 60 frames later, mean at
  least halved. (Real transport, real seed; distinguishes retention ≤ 1 from a
  self-sustaining gain. Failed before the erase fix for every `a < 1`.)
- Retention with no injection never exceeds unity across erase values.
"Never clips while a seed is permanently drawn" is deliberately not asserted.

## Next steps, in order

### 1. One like-for-like Max measurement (GUI — announce before launching)

Put the test glyph (`app/Tests/FeedbaxKitTests/Fixtures/glyph.png`) in
`input/transparent-background/`, enable the sticker at its default scale
(0.747) at startup geometry with theta ≈ 0.2, and capture 10–20 frames.
- Bright rail (~⅓ of pixels white, mean ≳ 0.9) → the port matches; close this
  finding and redesign the golden scenarios (step 2).
- Bounded → the difference lives in one of the two things static JSON cannot
  show: `jit.gl.layer`'s default `blend_enable`/`blend_mode`, or whether the
  HSL `jit.gl.pix` preserves alpha. Probe those with the loop-map method —
  read `Ad` inside `fb` after the sticker draws and `Aw` on the captured
  texture (`js` `getattr` for the defaults; `sprintf v%.12f` for values) — and
  compare terms, not stages.

### 2. Golden references — blocked on scenario design now, not on a port defect

Regeneration still refuses variance < 1e-6, correctly. The scenarios need a
seed that is *transient* (on for N frames, then off — the relaxation test
already runs this shape) or partially transparent and dark enough that
`Ad·S` per frame stays under the lightness loss, rather than a permanent opaque
glyph at 0.75 of the frame.

### 3. Bistability discrepancy — not reproduced this pass; mechanism removed

The only way two "equivalent" runs at different erase values could diverge was
the residual term, which no longer exists. Also: `DriftMeasurement`'s "sticker
on" variant never chdirs into a folder containing a sticker, so it has always
been a no-layer run. Re-run both post-fix before spending more on this; fix or
delete the sticker-on variant.

### 4. Remaining `docs/spec/` corrections

§01 §2 and §6 are done. Still open: §01 §4's classic-mode note (exponents ≤ 1
ignored), and the startup-vector section (loadbang vector superseded at 137 ms;
name the two mechanisms).

### 5. Control/display split — unchanged

`docs/superpowers/specs/2026-08-24-control-display-split-design.md`, awaiting
review; independent of this work.

## Method notes

- Every value that reaches a shader is measured from the running patch, not
  read from JSON or from `docs/spec` (memory: `measure-running-max-not-the-spec`).
- Every *behaviour* claimed about the loop is derived from the loop map first
  and then backed by a seeded fuzz (memory: `feedback-loop-map-not-stage-chasing`).
- Compare like with like against Max: same seed image, same control vector.
