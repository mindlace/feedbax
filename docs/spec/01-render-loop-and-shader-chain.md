> Part of the Feedbax technical description — see [`README.md`](README.md) for the overview,
> conventions (object-id citations like `[obj-36]`, `[?]` = unverified), and how the listings
> these sections cite were produced (`tools/maxpat2txt.py`). Each section ends with the audit
> notes from its verification pass.

# Render loop, feedback core, and shader chain

Scope: `patches/Feedbax.maxpat` (main patch, top-level `/`) and `patches/feedbax.shaderfx.maxpat` (subpatch `p shaderfx`, instantiated as `feedbax.shaderfx` [obj-148] in the main patch). All object ids below are from the main patch unless prefixed `sfx:` (shaderfx patch) or `v122:` (the retired chain, from the listing of archived `v122debuggingisg`, `//shaderfx#obj-148`).

## 0. Terms used below

- **jit.window** [obj-48]: the on-screen OS window.
- **jit.gl.render "foo"** [obj-49]: the GL render context bound to that window; drives the actual draw + buffer-swap.
- **jit.gl.texture "fst"** [obj-36]: full-resolution feedback texture, `@dim 1920 1080`, used when fullscreen.
- **jit.gl.texture "dst"** [obj-46]: small preview feedback texture, `@dim 320 180`, used when windowed.
- **jit.gl.videoplane "foo"** [obj-44]: the single full-screen textured quad everything is drawn onto (`@automatic 0`, i.e. it only redraws when banged).
- **mIniCtlSmooth** (`p mIniCtlSmooth`, ~13 instances in shaderfx alone): one inlet in, one outlet out. Internally: `pack 0. 200` combines the incoming target value with the current `controlSmoothMs` (received from bus `controlSmoothMs`, default **100 ms**, set at load by `[loadmess 100]`[obj-26]→`number`[obj-104]→`s controlSmoothMs`[obj-103]) into a `[target, time]` list, which drives a `line 0.` ramp generator (linear interpolation to the new target over `time` ms). A third input, bus `lineSmoothGrain` (source not in these two files — **[?]**), sets the ramp's step grain. **Net effect: every parameter that passes through mIniCtlSmooth is linearly ramped to its new value over ~100 ms (default), not snapped.** This is the *only* smoothing stage in the chain — everything downstream of it (the `pak param …` boxes, the shader) is fed already-smoothed values.

---

## 1. Per-frame sequence

### Clock

`metro @interval 60 hz` [obj-51], gated on/off by `toggle`[obj-47] (defaults **on**, `loadmess 1`[obj-75]→toggle). Its right inlet (the interval) is set by bus `FPSconfig`: preset messages `30`/`60`/`90`/`100`/`120` (msgs [obj-66][obj-65][obj-124][obj-59][obj-125] respectively — **note there are five presets, not four**; `100` is easy to miss because its message box, obj-59, sits slightly off from the other four in the layout, but the wire is unambiguous: `[obj-59 "100"]:0 -> [obj-52 number]:0`) → `number`[obj-52] (default **60**, via `loadmess 60`[obj-97]) → `pak interval 120 hz`[obj-16] → `s FPSconfig`[obj-210] → `r FPSconfig`[obj-211] → metro right inlet. **Default frame rate: 60 Hz.**

### The trigger fan-out

Each metro tick fires `t to_texture b b b b b b erase`[obj-50] (io 1→8). A Max `trigger` fires its outlets **right-to-left**, so despite left-to-right listing order the *execution* order is:

| Fires | Outlet | Token | Destination | Effect |
|---|---|---|---|---|
| 1st | 7 (rightmost) | `erase` (symbol) | → jit.gl.render [obj-49] | sends message `erase`: clears/fades the framebuffer using the render context's current `erase_color` (§2). |
| 2nd | 6 | bang | → `gswitch2`[obj-194] inlet 1 | routes the bang to whichever of fst/dst is currently active (selector set by the fullscreen toggle, §1 "fullscreen switch" below); that texture object outputs a `jit_gl_texture <name>` reference, which flows through `switch 2`[obj-37] into `feedbax.shaderfx`[obj-148] → the whole shader chain (§4) runs synchronously right here → its output sets the videoplane's texture. |
| 3rd | 5 | bang | → `s imgbang`[obj-23] | fires bus `imgbang` (drives `feedbax.picsvid` — images/video layer; not covered in this section). |
| 4th | 4 | bang | → `s audiobang`[obj-19] | fires bus `audiobang` (drives `feedbax.sound2` — waveform drawing; not covered here). |
| 5th | 3 | bang | → `s ctrlbang`[obj-29] | fires bus `ctrlbang`, which (inside shaderfx) also drives the Leap-hands-timeout check (`r ctrlbang`[sfx:obj-77] → `timer`[sfx:obj-59] inlet 1, §4 control-source arbitration). |
| 6th | 2 | bang | → jit.gl.videoplane [obj-44] | tells the (`@automatic 0`) videoplane to actually draw itself, using the texture the shaderfx chain just set in step 2. |
| 7th | 1 | bang | → jit.gl.render [obj-49] | a bare bang to the (`@automatic 0`) render context: performs the GL draw + buffer swap. |
| 8th (last) | 0 (leftmost) | `to_texture` (symbol) | → jit.gl.render [obj-49] | sends message `to_texture`: captures the just-rendered framebuffer into the render context's *currently bound* target texture (fst or dst — see "usetexture" below) for use as `prevFrame` on the *next* tick. |

This confirms and details the the overview (`docs/spec/README.md`) clock description with exact object ids and fires-first/fires-last ordering: **erase happens before the feedback texture is even requested**, and **the capture (`to_texture`) happens dead last**, after the draw has actually occurred.

### The two feedback textures and the fullscreen switch

A single toggle, `toggle "FS"`[obj-39] (key 27/Esc toggles it: `key`[obj-32]→`sel 27`[obj-40]→toggle), gangs together **four** things simultaneously:

1. `msg "fullscreen $1"`[obj-33] → `s fswindow`[obj-53] → `r fswindow`[obj-54] → jit.window[obj-48]: actually flips the OS window fullscreen state.
2. `sel 0 1`[obj-34]: on 1 (fullscreen) → `msg "usetexture fst"`[obj-35] → jit.gl.render[obj-49]; on 0 (windowed) → `msg "usetexture dst"`[obj-45] → jit.gl.render[obj-49]. This sets which texture `to_texture` (§ above) captures into, and which texture the render context reads/writes as its target.
3. `+ 1`[obj-38] → `switch 2`[obj-37] inlet 0 (selector): picks whether the *previous-frame texture reference* fed into `feedbax.shaderfx` comes from switch-inlet **2** (fst, connected from obj-36) or inlet **1** (dst, connected from obj-46) — **the inlet numbers are swapped relative to what you'd naively guess**, verified directly from the connection list: `[obj-36 fst]:0 -> [obj-37 switch 2]:2` and `[obj-46 dst]:0 -> [obj-37 switch 2]:1`. Combined with the `+1` selector (toggle 0→selector 1, toggle 1→selector 2), the net outcome is unchanged from what you'd expect: fullscreen (toggle=1) → selector 2 → fst; windowed (toggle=0) → selector 1 → dst.
4. `gswitch2`[obj-194] inlet 0 (selector): routes the per-tick "give me the texture" bang (trigger outlet 6, above) to fst[obj-36] or dst[obj-46] specifically.

So **fullscreen = full-res (1920×1080 by default) round-trip through `fst`; windowed = 320×180 round-trip through `dst`.** `jit.window`[obj-48]'s own default size is `@size 320 180` — the window itself starts at preview resolution.

`fst`[obj-36]: `jit.gl.texture @type long @name fst @dim 1920 1080 @filter none @erase_color 0. 0. 0. 1. @anisotropy 2 @filter linear` (filter is set twice in the creation string — `linear` wins, being later; the texture's own `@erase_color` is also set here, matching `pak`[obj-105]'s default and reinforcing that it's inert — see §2). Its `@dim` is also directly wired to the `resolution` bus (`r resolution`[obj-186] → obj-36), so picking a resolution preset resizes the feedback buffer live.

`dst`[obj-46]: `jit.gl.texture @name dst @dim 320 180`.

**Resolution presets** (all plain click-to-send `message` boxes → `s resolution`[obj-185]): 1024×768, 1280×720, 1280×800 (16:9), 1366×1024 (iPad), 1920×1080, 2560×1080, 2560×1440 (ACD), 2560×1600, 2880×1620 ("+oversample"), 3440×1440 (ultrawide), 3840×2160 (4K), 5120×1440 (ultrawide/ACD; two duplicate msg boxes feed `s resolution`: [obj-135][obj-163]), 7680×4320, 8192×8192 ("EXTREME"). **A third, visually identical `msg "dim 5120 1440"`[obj-123] box is NOT wired to `s resolution` at all** — checked directly: it feeds `t b`[obj-160]→`msg "size 5120 1440"`[obj-137]→`jit.window`[obj-48] (resizes the *OS window*, not the render/feedback resolution) and *also* connects straight into `dst`[obj-46]'s left inlet, bypassing the resolution bus entirely. It sits with a separate ultrawide-window-mode cluster (`border $1`, `pos -5120 0` messages nearby) — don't conflate it with [obj-135]/[obj-163] as a third resolution preset. **No `loadmess`/`loadbang` sends an initial `dim` message** to any of the `s resolution`-bound boxes — none of them fire automatically at patch load. So at load, `fst`'s dimensions stay at its creation default **1920×1080**, and the `xyratio` bus (below) is only ever updated once a preset is clicked.

`xyratio`: `r resolution`[obj-187] → `unpack dim 0 0`[obj-15] (outlets 1,2 = W,H) → `/ 1.`[obj-180] (W/H) → `s xyratio`[obj-212] and a display `flonum`[obj-181]. **`xyratio` = current resolution's width/height aspect ratio**, only updated on a resolution-preset click (never automatically on load).

---

## 2. jit.gl.render settings — erase, blend, depth

Creation attrs of `jit.gl.render "foo"`[obj-49]:
`@erase_color 0 0 0 1. @blend_enable 1 @blend_mode 6 7 @automatic 0 @depth_enable 0 @shadow_caster 0 @auto_material 0 @two_sided 0`.

Live-bound `attrui`s duplicate several of these for runtime tweaking: `attrui blend`[obj-127] (attribute name literally `blend`, presumably an alias/companion of `blend_enable` on this object — **[?]** exact Jitter semantics not re-derivable from the listing), `attrui depth_enable`[obj-171], `attrui depth_write`[obj-168], `attrui lighting_enable`[obj-172], `attrui lens_angle`[obj-173], `attrui camera`[obj-178], `attrui automatic`[obj-156].

A `pak blend_enable 0`[obj-25] ← `toggle`[obj-20] ← `loadmess 1`[obj-3] chain (the render-context twin of the videoplane's own blend_enable pattern documented in §3) also fires at load and sends `blend_enable 1` to the render context[obj-49] — consistent with, not overriding, its `@blend_enable 1` creation attribute. So both the render context and the videoplane are confirmed live-`blend_enable=1` at load, which the translucent-erase mechanism below depends on.

### erase_color / erasetransparency mapping

Two independent `pak erase_color 0. 0. 0. 1.` boxes exist:

- `pak`[obj-105] → feeds **`fst`'s own** `@erase_color` attribute [obj-36]. Nothing in either file ever sends an explicit `erase` message *to the texture object itself* — only the render context [obj-49] is banged with `erase` each tick (§1). **This texture-level erase_color is therefore vestigial/inert for the live loop** — it configures a clear color that is never used, because the texture is never independently erased.
- `pak`[obj-56] → feeds the **render context's** `erase_color`, i.e. the one that actually matters. Its inlet 4 (alpha) has **two** live sources landing on the same inlet: a manual `flonum`[obj-57] (range 0–1, UI-only slider, no automatic driver) and — the one asked about — the `erasetransparency` bus.

**`erasetransparency` mapping:** `r erasetransparency`[obj-119] → `scale 0 1. 0.8 1. 3.`[obj-84] → `pak erase_color`[obj-56] inlet 4 → jit.gl.render[obj-49]. **No smoothing** (this path does not go through mIniCtlSmooth).

`scale lo hi lo2 hi2 exp` with `lo=0 hi=1 lo2=0.8 hi2=1.0 exp=3`. **Measured on the running patch (2026-08-24), not derived:** `scale` defaults to `@classic 1`, and in classic mode an exponent `>1` gives an *exponential* curve, `alpha = 0.8 + 0.2 · 3^(f−1)`, not the modern-mode power curve `0.8 + 0.2 · f³` this paragraph previously claimed. The curve is therefore biased **high**, not low: `f=0.25 → 0.888`; `f=0.5 → 0.9155` (measured); `f=0.75 → 0.952`; `f=0.9 → 0.979`; `f=1.0 → 1.0`. The port's `ShaderMath/MaxScale.swift` is the reference implementation (it was corrected against the live patch in commit `b336206`; the earlier modern-mode reading survived review and was frozen into the golden suite — see `docs/superpowers/specs/2026-08-24-whiteout-next-steps.md`, "Method note").

**Which erase the port must implement — the retrofit changed it.** Since the Max 9 retrofit (`docs/diagnosis-2026-08-23.md`), the loop's render target is a `jit.gl.node @name fb @capture 1`, and `pak erase_color`[obj-56] feeds **that node's** `erase_color`, not `jit.gl.render`[obj-49] (whose own `@erase_color 0 0 0 1.` is now static). A `jit.gl.node`'s erase is a **hard clear of its FBO to `erase_color`, RGB and alpha** — nothing of the previous frame survives the erase; persistence comes entirely from the feedback plane (§3) redrawing the captured previous frame. `erasetransparency` therefore only sets the destination alpha of pixels nothing draws on, and because the plane composites with `(SRC_ALPHA, DST_ALPHA)` over an RGB-black clear, it has **no effect on loop gain**. A port must clear hard: `framebuffer = vec4(erase.rgb, eraseAlpha)`.

Do **not** implement the residual described in the next paragraph. Combined with the plane's additive `(SRC_ALPHA, DST_ALPHA)` composite, a `(1−a)` residual of the previous frame is *added to* the redrawn warped copy rather than blended under it, so per-frame retention becomes `1 + A_dst·(1−a)` — above unity for every `a<1`. The port's first implementation did exactly this, and a mid-grey field with no content at all climbed to clipped white by frame 30 at `a≈0.92` (measured, `LoopStabilityTests.testRetentionWithoutInjectionNeverExceedsUnityAcrossEraseValues`). The loop's only loss terms are the HSL lightness delta (§4) and content transported off-frame; the erase is not one of them.

**What the gl2-era erase did (historical; pre-retrofit `jit.gl.render` path only):** `erase` with `erase_color` alpha `a<1` and blending on draws a translucent black quad over the previous frame instead of clearing it. A pixel's contribution from `n` frames ago survives at `(1-a)^n` of its original value (each tick multiplies the residual by `(1-a)`). Because `a` never goes below **0.8**, the residual after one frame is at most `0.2`, after two frames at most `0.04`, after three frames at most `0.008` — **this design cannot produce long, slowly-decaying feedback trails via the erase channel alone**; trails from the erase stage are always short (2–3 frames), and for most of the `erasetransparency` control's range (`a≈0.8–0.9`) they're even shorter, with the erase becoming a near-hard clear (`a→1`) only at the extreme top of the knob. Any longer-lived "infinite echo" look in Feedbax therefore has to come from the geometric transform feedback (rotate/zoom accumulating structure across frames), not from slow erase decay. Whether the gl2 path's residual ever actually reached the composite as a gain term (a default gl2 window framebuffer without alpha planes would have read `A_dst = 1`, making the residual purely additive as analysed above) is not recoverable from the listing; the retrofit patch is the reference now, and it clears hard.

The starting/default value of `erasetransparency` itself is set by `feedbax.webui` (not in these two files) — **[?] unknown default**.

---

## 3. Main videoplane [obj-44]

Creation attrs: `jit.gl.videoplane @automatic 0 @scale -1.78 1. 1. @color 1. 1. 1. 1. @blend_enable 1 @blend_mode 6 7 @position 0. 0. -0.4 @shadow_caster 0 @two_sided 0 @interp 0 @auto_material 0`.

Every one of `scale`, `position`, `rotatexyz`, `color`, `blend_enable`, `blend_mode` also has a live `pak` wired to the same inlet, and several of those `pak`s are fired once at load by a `loadmess`/`loadbang` upstream — meaning **the load-time final state is not simply the creation-attribute string**; whichever fires last (creation vs. loadbang'd pak) wins. Traced below.

### blend_mode: loadbang'd pak (6 8) wins over the creation attr (6 7)

`loadbang`[obj-4] → `pak blend_mode 6 8`[obj-90] (banging a `pak`'s leftmost inlet re-emits its current stored list) → videoplane[obj-44]. `pak`'s inlets 1/2 (the two mode ints) are also wired from `number`[obj-89]→inlet1 and `number`[obj-88]→inlet2, but **neither number box has any inbound wiring**, so they never fire on their own — the pak's actual output at load is its creation-arg list, unmodified: **`blend_mode 6 8`**.

Since `loadbang` fires *after* all objects (including the videoplane) have been instantiated with their creation attributes, **the final blend_mode at load is `6 8`, not the `6 7` baked into the creation string.** Per the given enum, `6 8` = `(GL_SRC_ALPHA, GL_DST_ALPHA)` — **not** the standard premultiplied-alpha pair (which would be `6 7` = `(src_alpha, 1-src_alpha)`). With `(src_alpha, dst_alpha)`, *neither* blend factor is a complement, so at high alphas on both sides the composite can brighten/accumulate rather than cleanly interpolate — a non-standard, additive-leaning blend. Corroborating evidence that this was deliberate: an unconnected scratch message box `msg "blend_mode 6 8 0.92 interesting"`[obj-13] sits in the patch — vestigial (no wire in or out) but clearly the artist's own note-to-self that `6 8` (paired with erase alpha ≈0.92) was a look he'd found and wanted to remember. **Port recommendation: use blend func `(src_alpha, dst_alpha)` for the main plane, not standard alpha-over.** Note this override is **local to the videoplane object** — nothing in either file sends a `blend_mode` message to the render context[obj-49] itself, so `jit.gl.render`'s own `@blend_mode` stays at its creation value `6 7` (standard alpha-over); only what the *plane* draws uses `6 8`.

### scale: xyratio coupling, and a probable mirroring conflict — flag prominently

`pak scale 1.78 1. 1.`[obj-77] (inlets: 0=`scale` literal, 1=x, 2=y, 3=z) feeds the videoplane.

- **z** ← `flonum`[obj-73], no inbound wiring — static/manual, whatever's saved in the file.
- **y** ← `flonum`[obj-76] ← directly from `flonum`[obj-79] (base-scale control; `loadmess 1.`[obj-80] sets it to **1.0** at load).
- **x** ← `flonum`[obj-74] ← `* 1.78`[obj-78]. Inlet 0 (left/hot) of this multiply is fed by (a) `flonum`[obj-79] itself (same base-scale value, 1.0 at load) and (b) `button`[obj-122] (manual re-fire). Inlet 1 (the multiplier, default **1.78** from the object's creation arg) is fed by `r xyratio`[obj-213] via `t b f`[obj-193] (float-then-bang, so the new multiplier is stored *before* the recompute bang fires).

  So: **`scale.x = baseScale(flonum[obj-79], default 1.0) × currentMultiplier`**, where `currentMultiplier` starts at the creation-arg **1.78** and is only replaced by the live `xyratio` value once a resolution preset has been clicked (§1 — never happens automatically at load). At load, then, `scale.x = 1.0 × 1.78 = 1.78` and `scale.y = 1.0`.

  **This value is positive (+1.78), not negative.** The creation attribute `@scale -1.78 1. 1.` (negative x = horizontally mirrored, standard Jitter behaviour) is present only until this `pak` fires — and it fires at load, because `loadmess 1.`[obj-80] feeds directly into the x-scale computation chain. **Net effect as traced: by the time the patch finishes loading, the videoplane's x-scale is `+1.78`, which *un-mirrors* the plane relative to what the bare creation attribute implies.** This directly contradicts the "mirrored main videoplane" framing in the established the overview (`docs/spec/README.md`). **This is not actually ambiguous on inspection:** `loadmess 1.`[obj-80] unconditionally sends the literal `1.` into `flonum`[obj-79] on *every* load, regardless of whatever value the box last had saved — so there is no "saved-value" escape hatch here, and the conclusion doesn't depend on load-order either (all loadbangs fire only after every object, including the videoplane, has already been instantiated with its creation attributes — see the identical reasoning already used for `blend_mode` above). The only things that could still change this at runtime, neither visible in a static listing: (a) a performer manually re-entering a value into `flonum`[obj-79]/[obj-74] or clicking `button`[obj-122] mid-session (reverts on the next load regardless), or (b) `xyratio`[obj-213] receiving a value from some other, unexamined file (webui/leapgemini/misc) auto-firing a resolution preset before the videoplane's first draw — not observed in either of these two files. **Port recommendation: treat the videoplane as effectively un-mirrored (`scale.x ≈ +1.78`) by default, matching what the wiring actually produces, not the creation-attribute string.**

### position: worldBump → z coupling

`pak position 0. 0. 0.`[obj-72]: x ← `flonum`[obj-69] (static/manual, no inbound wire), y ← `flonum`[obj-71] (static/manual), **z** ← `+ 0.`[obj-93], whose left/stored operand starts from `flonum`[obj-67] ← `loadmess -0.414`[obj-81] (fires at load, base z = **-0.414**), and whose right operand is set by `r worldBump`[obj-146] via `t b f`[obj-98] (float-then-bang, same pattern as xyratio). **`position.z = -0.414 + worldBump`.** `worldBump` has no sender in either file examined (likely driven by LeapGemini hand-depth — **[?]**); absent that, z stays pinned at the load-time default **-0.414**, close to but not identical to the creation attribute's `-0.4`.

### rotatexyz and color.alpha: static, not automated

`pak rotatexyz 0. 0. 0.`[obj-12]: all three axes (`flonum`s [obj-117][obj-120][obj-121]) are fed only by `msg "0"`[obj-82], which itself has **no inbound trigger anywhere in the file** — so this message never fires automatically, and the rotation flonums simply hold whatever the patch file last saved (almost certainly `0 0 0`). **rotatexyz is not wired to any live control bus; treat it as always `(0,0,0)`** for the current build.

`pak color 1. 1. 1. 1.`[obj-91]: alpha ← `flonum`[obj-92], no inbound wiring — static, matches the pak's own creation default of `1.`.

`pak blend_enable 0`[obj-9] ← `toggle`[obj-8] ← `loadmess 1`[obj-5]: fires at load, sends `blend_enable 1`, consistent with (not overriding) the creation attribute — no conflict here.

---

## 4. Shader chain (current repo, v123) — and the retired v122 chain

**Both chains share the same `gswitch`[sfx:obj-30]/11-slot-`unpack`[sfx:obj-11] structure, but NOT the same selector logic.** In the current repo (v123, examined here): bus `shadeCtl` (from `feedbax.webui`) and `shadeCtlLeap` (from `feedbax.leapgemini`) both feed `gswitch`[sfx:obj-30] inlets 1/2; the selector (inlet 0) comes from `toggle`[sfx:obj-82], itself driven by a "Leap is primary, reverts to iPad after 2s of no hands" watchdog: `r leap2HandsActive`[sfx:obj-57] → `t b`[sfx:obj-68] → `timer`[sfx:obj-59] (polled every tick via `r ctrlbang`[sfx:obj-77] into its right inlet) → `< 2000`[sfx:obj-78] → `change`[sfx:obj-80] → toggle[sfx:obj-82]. **In the retired v122 build** (section `//shaderfx#obj-148` of the listing of archived `v122debuggingisg`), the same `gswitch`[obj-30]'s selector was instead fed *directly* by `r leapOverrideUI`[obj-45] — a single manual-override bus, no timer/timeout logic at all: `[obj-45 r leapOverrideUI]:0 -> [obj-30 gswitch]:0` (plus a dead-end display `toggle`[obj-23] off the same bus, with no further wiring). The `leap2HandsActive`-driven auto-timeout watchdog is therefore a v123 addition; `leapOverrideUI` does not appear anywhere in the current repo's cross-reference (the bus cross-reference (`docs/spec/06-bus-reference.md`)) and is presumed retired between versions. **Only the value-routing structure (which of the two 11-float lists reaches `unpack`) is shared between versions — the logic deciding which one is authoritative was rewritten.** The selected 11-float list is split by `unpack 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0.`[sfx:obj-11] into the slots defined in the overview (`docs/spec/README.md`) (0 hue … 10 ancy) — this part is identical byte-for-byte between the two files.

**Only 7 of the 11 slots are actually wired**: hue(0), bias(1), xshift(3), yshift(4), scale/zoom(5), theta(6), sat(8). **Unwired/dead slots: scalebright(2), NC(7) — explicitly commented `// NYI`[sfx:obj-38] — ancx(9), ancy(10).** The anchor param of the rotate shader is instead driven by two orphan `flonum`s (`obj-13`,`obj-17` → `pak param anchor`[sfx:obj-10]) with **no inbound wiring at all** — i.e. anchor is a manual, non-automated UI control that (if never touched) never fires, leaving the shader's built-in default `anchor = (0.5, 0.5)` (texture-normalized center) in effect for the whole session. The `ancx`/`ancy` slots in the control vector appear to have been intended to drive this and never got connected.

### SInvert (scaleInvtoggle)

`r scaleInvtoggle`[sfx:obj-43] → `sel 0 1`[sfx:obj-42]: input `0` → `msg "1."`[sfx:obj-41]; input `1` → `msg "-1."`[sfx:obj-40]. Both also `→ s SInvert`[sfx:obj-34]. So **`SInvert = +1` when `scaleInvtoggle` is off (0, presumed default), `SInvert = -1` when on (1).** Two separate `r SInvert` receivers pick this up: [sfx:obj-44] feeds the xshift/yshift multiply stage, [sfx:obj-35] feeds the zoom negate stage (see below).

### td.rota.jxs (rotate/zoom shader) — parameter derivation

| Shader param (type) | Source slot | Formula | Smoothed? |
|---|---|---|---|
| `zoom` (vec2, default `1 1`) | slot 5 ("scale") | `scale(-1,1 → 0.4,1.2)`[sfx:obj-164] → mIniCtlSmooth[sfx:obj-21] → `× SInvert`[sfx:obj-28, args reversed by live right-inlet r SInvert[sfx:obj-35]] → `pak param zoom`[sfx:obj-91] | Yes (100ms default) |
| `offset.x` (vec2) | slot 3 ("xshift") | `× SInvert`[sfx:obj-32] → `scale(-1,1 → -2000,2000)`[sfx:obj-69] → mIniCtlSmooth[sfx:obj-19] → `pak param offset`[sfx:obj-88] inlet 2 | Yes |
| `offset.y` (vec2) | slot 4 ("yshift") | `× SInvert`[sfx:obj-33] → `scale(-1,1 → -2000,2000)`[sfx:obj-72] → mIniCtlSmooth[sfx:obj-20] → pak[sfx:obj-88] inlet 3 | Yes |
| `theta` (float) | slot 6 | `scale(-1,1 → 3.1415,-3.1415)`[sfx:obj-93] (note **reversed** hi/lo — raw+1 maps to −π, raw−1 maps to +π) → mIniCtlSmooth[sfx:obj-22] → `pak param theta`[sfx:obj-92] | Yes |
| `anchor` (vec2, default `0.5 0.5`) | slots 9/10 (unwired) | orphan flonums[sfx:obj-13/17], never auto-fire | n/a — effectively static at shader default |
| `boundmode` (int, default `0`) | none | `loadmess 4`[sfx:obj-7] → `number`[sfx:obj-70] → `msg "param boundmode $1"`[sfx:obj-56] — **fires once at load, no live control ever wired to it again** | n/a — fixed at **4** for the whole session |

**On the SInvert × multiply order for zoom:** `* -1.`[sfx:obj-28]'s creation argument is literally `-1.`, but its right inlet is continuously overridden by the live `SInvert` bus (`+1`/`-1`), so the object's *effective* multiplier is `SInvert`, not the fixed `-1` in its name — i.e. **`zoom_final = smooth(scale(raw,0.4..1.2)) × SInvert`.** When `SInvert=+1` (default), zoom stays in `[0.4, 1.2]` as expected. When `SInvert=-1` (scaleInvtoggle on), zoom becomes **negative**, in `[-1.2, -0.4]`.

Because the shader computes `sca = mat2(1/zoom.x, 0, 0, 1/zoom.y)` (§ below), a negative zoom flips the sign of both diagonal entries — i.e. **it's not just an inverted zoom range, it's an X/Y point-mirror of the sampled region about the anchor, compounded with whatever rotation is also applied that frame.** Feeding this back into itself every tick is what produces the "kaleidoscope" character named in the shader's own `<description>`.

### td.rota.jxs — exact transform math

From `Max's bundled td.rota.jxs` (coordinates are texture-rectangle pixel coords via `sampler2DRect`/`texdim0`, **not** normalized 0–1 UV):

```glsl
vec2 sizea = texdim0;              // texture size in pixels
vec2 point = texcoord0;            // this fragment's own pixel coord

mat2 sca = mat2(1./zoom.x, 0., 0., 1./zoom.y);                 // scale by 1/zoom
mat2 rot = mat2(cos(theta), sin(theta), -sin(theta), cos(theta)); // rotation

vec2 no = ((((point - anchor*sizea) * rot) * sca) + anchor*sizea) + offset;
```

Reading (this is a **backward/inverse warp**: for each output pixel `point`, `no` is the pixel coordinate to *sample from* in the source texture):
1. `point - anchor*sizea` — recenter around the anchor, in pixels (`anchor` is a 0–1 fraction of `sizea`, default center `0.5,0.5`).
2. `× rot` — rotate about that anchor by `theta`.
3. `× sca` — scale by `1/zoom`: **`zoom>1` samples a smaller neighborhood → magnify/zoom in; `zoom<1` samples a larger neighborhood → zoom out.** `zoom` negative additionally mirrors both axes (see SInvert above).
4. `+ anchor*sizea` — translate back.
5. `+ offset` — pan, in raw pixels (range up to ±2000 px, § table above).

Because this is a source-space (inverse) transform, a positive `theta` rotates the *sampled content* by `+theta`, which — depending on your renderer's Y-axis convention — can look like the *opposite* rotation on screen from what you'd get if you rotated the destination geometry forward. **Verify handedness empirically when porting; don't assume screen-space rotation direction from the sign of theta alone.**

**Boundmode (fixed at 4 — folded/mirrored, per §load trace above):**
```glsl
vec2 no2 = mod(no, sizea);                                                  // wrap
vec2 no4 = mix(mod(no,sizea), sizea-mod(no,sizea), floor(mod(no,sizea*2.)/sizea)); // folded/ping-pong
vec2 tc = no*(bm==0) + no*(bm==1) + no2*(bm==2) + no*(bm==3) + no4*(bm==4);
```
With `boundmode==4`, `tc = no4`: this is a **mirror-repeat** wrap — coordinates that overshoot the texture bounds are reflected back in with period `2×sizea`, rather than clamping, wrapping plainly, or going transparent. Since the sampled coordinate under `no4` is always folded back in-bounds, the shader's secondary "out of bounds → blend with `tex1`(the untransformed original) or clear" logic (used only by boundmode 0/1) never engages for this patch: `gl_FragColor = texture2DRect(tex0, no4)` unconditionally. **This is the single most important visual mechanism in the feedback loop: every tick, the previous frame is rotated/scaled about the anchor and any part that would fall off the edge is folded back in as a mirror image, rather than clamped or cleared — compounding over many frames into the characteristic folded/kaleidoscopic structure.**

**Second texture input (`tex1`) is never fed, in either build:** `jit.gl.slab`[sfx:obj-6] has `io=2/2`; inlet 1 (right, `tex1`) has no inbound wire anywhere in the shaderfx file — every connection into obj-6 (the three `pak param …` boxes, `msg "param boundmode $1"`, and the incoming texture reference from the parent inlet[sfx:obj-144]) lands on inlet 0. Since the `tex1`-blend/clear logic is only reachable via boundmode 0/1 anyway (never used here — boundmode is fixed at 4), this doesn't change the current output, but it does mean **the shader's built-in "blend with untransformed original at the edges" and "clear at the edges" behaviors are entirely unreachable in this patch, not merely unused for the current boundmode setting.** A port only needs the single-texture, `boundmode==4` path; `tex1`/mode 0/1 can be dropped entirely.

Note: `zoom` is a `vec2` shader param but the Max side only ever sends **one** float (`pak param zoom 0.`[sfx:obj-91] — literally `param`, `zoom`, one number). Per standard Jitter param-message behavior, a shorter list than the declared vector broadcasts the last value to the remaining components, so this sets `zoom = (v, v)` (uniform zoom, not independent x/y zoom) — **[?] not independently re-derivable from this listing, standard-behavior assumption.**

### HSL jit.gl.pix [sfx:obj-25] — the actual output of the current (v123) chain

Subpatch `//jit.gl.pix#obj-25`: `in 1`[·obj-1] → `rgb2hsl`[·obj-3] → `+`[·obj-2] (adds a `vec(hue_shift, saturation, lightness)`[·obj-7], sourced from three declared `param`s: `hue_shift 0.02`[·obj-6], `saturation 0.5`[·obj-9], `lightness 0.5`[·obj-10]) → `hsl2rgb`[·obj-5] → `out 1`[·obj-4]. So this is **additive HSL offset**, not multiplicative: `hsl' = hsl_in + (hue_shift, saturation_delta, lightness_delta)`, then converted back to RGB. `hsl2rgb`'s hue component is expected to wrap modulo 1 (standard HSL semantics) — repeated per-frame `hue_shift` additions on feedback content therefore continuously cycle hue over many frames rather than saturating, giving the slow color-drift/rainbow character typical of this kind of feedback patch.

**The three `param` objects' own declared defaults are a fact worth surfacing on their own** (they aren't just naming placeholders — they're the values in effect until the *first* live control message ever arrives): `hue_shift 0.02`, `saturation 0.5`, `lightness 0.5`. The hue default (0.02) sits comfortably inside its live-driven range (±0.05, per the table below) — "slow drift always on" even before any control input. The saturation/lightness defaults (**0.5 each**) are not small by comparison: as *additive* offsets they'd push S and L most of the way toward their ceiling. In practice this only matters for however many frames elapse between patch load and the first `shadeCtl`/`shadeCtlLeap` list arriving — `mIniCtlSmooth`'s `line` ramp (§0) produces no output at all until its first target value is unpacked, so the `hue_shift $1`/`saturation $1`/`lightness $1` messages don't fire, and the pix's own baked defaults are what's on screen for that window. Likely negligible in a live session (control values probably arrive within the first frame or two) but worth reproducing exactly if a port cares about faithful cold-start behavior.

| pix param | source slot | formula (creation-arg defaults; see note on manual overrides) | smoothed? |
|---|---|---|---|
| `hue_shift` | slot 0 ("hue") | `scale(-1,1 → -0.05,0.05, exp 0.1)`[sfx:obj-31] → mIniCtlSmooth[sfx:obj-26] → `msg "hue_shift $1"`[sfx:obj-29] | Yes |
| `lightness` | slot 1 ("bias") | `scale(-1,1 → -0.04,0.02, exp 0.05)`[sfx:obj-36] (asymmetric — biased toward darkening) → mIniCtlSmooth[sfx:obj-27] → `msg "lightness $1"`[sfx:obj-8] | Yes |
| `saturation` | slot 8 ("sat") | `scale(0,1 → -0.05,0.05, exp 0.1)`[sfx:obj-51] → mIniCtlSmooth[sfx:obj-50] → `msg "saturation $1"`[sfx:obj-4] | Yes |

**Ambiguity flagged:** the `saturation` scale object's input domain is `0..1`, not `-1..1` like the others, even though the overview (`docs/spec/README.md`) states control-vector slots are "most... in -1..1". If slot 8 is actually delivered in `-1..1` like its siblings, negative inputs extrapolate below the object's own `lo` bound (Max's `scale` does not clip by default) — the resulting curve for negative inputs is not verifiable from this listing alone. **[?]**

Each `scale` object above also has manual per-instance overrides for its `lo2`/`hi2`/`exp` arguments wired from bare `flonum`s — and `lo2` is not independent of `hi2`: each pair routes a single flonum through a `* -1.` before it lands on the `lo2` inlet, so **`lo2 = -hi2`** (one knob trims both ends symmetrically, not two independent knobs). Concretely: hue — `flonum`[sfx:obj-54] → (`hi2`/inlet 4 directly, `lo2`/inlet 3 via `*-1.`[sfx:obj-52]), `flonum`[sfx:obj-73] → `exp`/inlet 5; lightness — `flonum`[sfx:obj-64] → (inlet 4 directly, inlet 3 via `*-1.`[sfx:obj-65]), `flonum`[sfx:obj-76] → inlet 5; saturation — `flonum`[sfx:obj-61] → (inlet 4 directly, inlet 3 via `*-1.`[sfx:obj-62]), `flonum`[sfx:obj-1] → inlet 5. **None of these flonums have any inbound wiring**, so they're live-tweakable-by-hand UI trim controls only; the creation-arg values in the table are what's actually in effect absent manual intervention during a performance.

### v123 (current repo): brcosa is present but disconnected — flag prominently

`jit.gl.pix @gen brcosa`[sfx:obj-47] exists in the patch and **receives** `brightness $1`/`contrast $1`/`saturation $1` parameter messages (from live.dials [sfx:obj-121][sfx:obj-129][sfx:obj-142] and — oddly — also from a separate, labeled-vestigial "Color Invert (unused atm)"[comment sfx:obj-53] `slider`[sfx:obj-12] that also feeds its `contrast` input via [sfx:obj-3]/[sfx:obj-14]). **But it has no texture input wired to its inlet 0, and its output outlet is not connected to anything** — no wire from [sfx:obj-47] appears anywhere in the connection list. It is a fully dead end: parameter messages land on it and do nothing observable. **The HSL pix [sfx:obj-25] output connects directly to the subpatch outlet[sfx:obj-147], which is the shaderfx output that feeds the videoplane.** So in the current build, `hue_shift`/`lightness`/`saturation` (HSL) are the **last** stage that visibly affects the image; brightness/contrast/color-saturation via brcosa have **no effect whatsoever** on-screen, even though their UI controls still work and even though there's a "// Color Invert (unused atm)" note suggesting yet another half-built control on top.

### v122 (retired, the listing of archived `v122debuggingisg`): the same chain, but with brcosa wired in

In Sean's last Max 8 build, the identical HSL pix `[v122:obj-25]` output instead fed **into** brcosa: `[obj-25 jit.gl.pix]:0 -> [obj-47 jit.gl.pix @gen brcosa]:0`, and **brcosa's output was the subpatch's outlet**: `[obj-47 jit.gl.pix @gen brcosa]:0 -> [obj-147 outlet]:0`. So the v122 chain was:

```
td.rota (rotate/zoom, folded bounds)
  → jit.gl.pix HSL (additive hue/sat/lightness shift)
    → jit.gl.pix @gen brcosa (brightness/contrast/saturation)
      → videoplane
```

vs. the current v123 chain:

```
td.rota (rotate/zoom, folded bounds)
  → jit.gl.pix HSL (additive hue/sat/lightness shift)
    → videoplane            [brcosa still receives param messages, but is wired to nothing]
```

**This is a real, confirmed regression/removal between the two versions, not a listing artifact** — both files were re-checked and the wiring difference (one connection present vs. absent) is the entire difference. A faithful port of the *current* build should **omit brightness/contrast/color-saturation entirely**; a port that wants to match the earlier, brcosa-inclusive look should re-insert that stage using the math below.

**A second, entirely separate dead chain exists too, in both files:** a subpatcher `p oldconrtrol`[sfx:obj-2] sits at the top of the shaderfx patch with `io=0/0` — zero inlets, zero outlets — meaning it is structurally unreachable from the rest of the patch, not merely unwired to it. Inside it (`//oldconrtrol#obj-2`, 20 boxes) is a *third*, self-contained brightness/contrast/saturation control chain: its own `live.dial`s, its own `mIniCtlSmooth`s, its own `jit.gl.pix @gen brcosa`[obj-47], plus a `scale`/`bias` pair driving a *different* shader (`jit.gl.slab @file cc.scalebias.jxs`, not `td.rota.jxs`) — a complete miniature duplicate of the color-correction control surface, fully abandoned. Not relevant to a port; noted only so it isn't mistaken for a second live signal path if someone opens the raw JSON.

### brcosa (`@gen brcosa`) — gen graph math

Rendered from `src/brcosa.genjit`:

```
luma_weights = vec3(0.2125, 0.7154, 0.0721)   // Rec.709 luma
rgb   = in.rgb                                  // swiz rgb, drops alpha
l     = dot(rgb, luma_weights)                  // scalar luma
lumaV = vec3(l, l, l)
colorSat = mix(lumaV, rgb, saturation)          // param saturation, default 1
gray  = vec3(0.62, 0.62, 0.62)                  // param luma, default (0.62,0.62,0.62) — contrast pivot
graded = mix(gray, colorSat, contrast)          // param contrast, default 1
bright = graded * brightness                    // param brightness, default 1  (uniform scalar multiply)
out.rgb = bright.rgb
out.a   = in.a                                  // alpha passed through untouched, from the ORIGINAL input, not from any of the above
```

`mix(a,b,t) = a·(1−t) + b·t`. So: `saturation=0` → grayscale; `saturation=1` (default) → unchanged; `>1` → oversaturate. `contrast=0` → flat 0.62 gray; `contrast=1` (default) → unchanged; `>1` → contrast stretched around the 0.62 pivot (extrapolated, can exceed [0,1]). `brightness` is a plain post-multiply, default 1 (no-op). Alpha is never modified by this stage, sourced from the *pre-brcosa* input, independent of the RGB pipeline above.

---

## 5. HSL gen math — wrap behavior

`rgb2hsl` → add `(hue_shift, saturation_delta, lightness_delta)` → `hsl2rgb` (see §4 table above for the exact per-frame values). Standard HSL conventions (not visible in the listing itself, but implied by `rgb2hsl`/`hsl2rgb` being paired conversions and by the additive-hue-drift design): hue is a value on `[0,1)` representing an angle around the color wheel and wraps modulo 1 on conversion back to RGB; saturation and lightness are expected in `[0,1]` and would clip/desaturate at the extremes rather than wrap. Given `hue_shift` is only ever in `±0.05` per frame (§4 table) but is applied to **feedback content** (the output of one frame becomes the input hue of the next), the wrap means sustained hue drift compounds into a full rainbow cycle over enough frames rather than saturating at red or violet.

---

## 6. Minimal port pseudocode (one frame, GLSL-ish)

```glsl
// Constants / per-frame uniforms already smoothed+scaled per §4 tables:
// zoom (scalar, broadcast to vec2), theta (radians), offsetPx (vec2, ±2000px),
// anchor = vec2(0.5, 0.5) (static — not automated in this build, §4),
// hueShift, lightDelta, satDelta (HSL additive deltas, §4),
// eraseAlpha = mix(0.8, 1.0, pow(erasetransparencyRaw, 3.0))   // never below 0.8, §2

vec2 sizePx = textureSizeOfFeedbackBuffer();  // 1920x1080 (fullscreen) or 320x180 (windowed)

// --- Stage 1: td.rota — rotate + zoom about anchor, folded (mirror) bounds ---
vec2 rotateZoom(vec2 fragPx, sampler2DRect prevFrame) {
    mat2 sca = mat2(1.0/zoom, 0.0, 0.0, 1.0/zoom);
    mat2 rot = mat2(cos(theta), sin(theta), -sin(theta), cos(theta));
    vec2 centered = fragPx - anchor * sizePx;
    vec2 srcPx = ((centered * rot) * sca) + anchor * sizePx + offsetPx;

    // boundmode 4: fold/mirror-repeat with period 2*sizePx
    vec2 wrapped = mod(srcPx, sizePx);
    vec2 folded  = mix(wrapped, sizePx - wrapped, floor(mod(srcPx, sizePx*2.0) / sizePx));
    return folded;   // sample prevFrame at this coordinate (pixel-rect, not normalized UV)
}

// --- Stage 2: HSL additive shift (this IS the current output stage) ---
vec3 hsl = rgb2hsl(color.rgb);
hsl += vec3(hueShift, satDelta, lightDelta);
hsl.x = fract(hsl.x);           // hue wraps
color.rgb = hsl2rgb(hsl);
// color.a unchanged

// [v122 only — omit for a v123-faithful port, see §4]:
// float luma = dot(color.rgb, vec3(0.2125,0.7154,0.0721));
// vec3 colorSat = mix(vec3(luma), color.rgb, satBc);
// vec3 graded   = mix(vec3(0.62), colorSat, contrast);
// color.rgb = graded * brightness;

// --- Stage 3: composite onto the main plane ---
// NOT mirrored: the -1.78 creation scale is overridden to +1.78 by a
// loadmess'd pak that always fires at load — see §3.
drawFullscreenQuad(color, blendFunc = (SRC_ALPHA, DST_ALPHA));  // NOT standard alpha-over, §3

// --- Stage 4: HARD erase, THEN capture for next frame ---
// jit.gl.node clears its FBO to erase_color (rgb AND alpha) — no residual of the
// previous frame. Done BEFORE stages 1-3 draw each tick (§1 order). See §2: a
// mix()/residual erase here, under the additive composite of stage 3, is a gain > 1.
framebuffer = vec4(0, 0, 0, eraseAlpha);
// ... draw stages 1-3 into framebuffer ...
feedbackTexture = captureFramebuffer();  // "to_texture", fires LAST each tick (§1)
```

What actually produces the Feedbax "look," in priority order: (1) the fold/mirror boundmode on the rotate/zoom stage compounding structure at the edges every frame, far more than the erase does; (2) rotate+zoom about a fixed center anchor, both smoothed over ~100ms so changes glide rather than snap; (3) additive per-frame hue drift that wraps into slow rainbow cycling; (4) an erase that is a hard clear (post-retrofit) — persistence and its decay come from the plane redraw plus the HSL lightness delta, not from the erase; (5) a non-standard `(src_alpha, dst_alpha)` blend on the final composite, which can brighten rather than cleanly dissolve; (6) confirmed loss of horizontal mirroring at runtime (§3) despite the plane's mirrored creation attribute — `scale.x` ends up `+1.78`, not `-1.78`.

---

## Open questions / things the listing cannot tell us

1. **Does the videoplane end up mirrored or not?** Resolved as far as the listing allows: §3's trace shows the live-computed x-scale is `+1.78` at load (not `-1.78`), because `loadmess 1.`[obj-80] unconditionally forces `flonum`[obj-79]→1.0 on every load, independent of any saved state — so this is not a saved-value ambiguity. The **residual** uncertainty is only whether a live performer manually touched `flonum`[obj-79]/[obj-74] or `button`[obj-122] mid-session (invisible to a static listing either way, and reverts on the next load regardless).
2. **`worldBump`** has no sender in either file — presumably from LeapGemini hand tracking. Its live range/behavior is unknown; without it, `position.z` is static at `-0.414`.
3. **`lineSmoothGrain`** (the ramp-generator grain/step inside every `mIniCtlSmooth`) is sent from `feedbax.misc`, not examined here — its value (and thus the smoothing's actual step resolution, as opposed to its 100ms duration) is unknown.
4. **`erasetransparency`'s default/starting value** comes from `feedbax.webui`, not examined here.
5. **`scaleInvtoggle`'s default state** (assumed off → `SInvert=+1`) is likewise a `feedbax.webui` UI default not visible in these two files.
6. **Slot 8 ("sat") domain**: the HSL-pix saturation `scale` object's input range is declared `0..1` while the the overview (`docs/spec/README.md`) says most slots run `-1..1` — unresolved whether this is intentional (sat is genuinely 0..1) or an inconsistency that causes out-of-range extrapolation for negative inputs.
7. **`gswitch`/`gswitch2` exact index semantics**: I've described their *functional* routing (which bus/texture wins based on toggle state) from the wire graph, but the precise numeric-index ↔ toggle-value mapping for these two-input switch objects is asserted from context, not from Max/Jitter documentation reproduced here.
8. **Zoom scalar broadcast to vec2**: `pak param zoom`[sfx:obj-91] sends a single float to a `vec2` shader param; the assumption that Jitter broadcasts it to both components (rather than, say, leaving y at its last value or erroring) is standard behavior but not independently verifiable from this listing.
9. **`attrui blend`[obj-127]'s exact target attribute** on `jit.gl.render` (named `blend`, not `blend_enable`) — likely an alias, not independently confirmed.
10. Manual/UI-only controls noted throughout (anchor flonums, rotatexyz flonums, color-alpha flonum, several `scale` object lo2/exp trim flonums, the brcosa "Color Invert" slider, jit.gl.handle "reset" buttons) are described as *currently* unwired to any automated source based on the absence of inbound connections in the listing — this reflects the wiring at the time the listing was generated and would change if a live performer manually entered values into those boxes during a session (such values wouldn't be visible in this static listing either way).
11. **`leapOverrideUI` (v122's Leap-selector bus) is presumed retired**, based only on its absence from the bus cross-reference (`docs/spec/06-bus-reference.md`) (the current repo's cross-file bus index). That index wasn't built from the listing of archived `v122debuggingisg`, so this is inference from absence, not a direct confirmation that no file anywhere still sends it.
12. **Why does `td.rota.jxs` declare a `tex1`/two-texture blend-or-clear path at all**, if nothing in any examined version of this patch ever wires a second texture into it? Possibly a leftover from an earlier design (blending against a *live* untransformed camera/image feed at the edges, rather than folding) that was abandoned in favor of the boundmode-4 fold approach — not verifiable from these files.

---

### Audit notes (verification pass)

Corrections made against the source listings (the `Feedbax.maxpat` listing, the `feedbax.shaderfx.maxpat` listing, `td.rota.jxs`, `brcosa.genjit`, the listing of archived `v122debuggingisg`, the bus cross-reference (`docs/spec/06-bus-reference.md`)):

- **`switch 2`[obj-37] inlet numbers were swapped**: the doc had said fst→inlet 1, dst→inlet 2; the connection list shows the opposite (fst[obj-36]→inlet 2, dst[obj-46]→inlet 1). The overall fullscreen=fst/windowed=dst outcome was still correct, only the specific inlet labels were wrong.
- **FPS presets: five values, not four.** A `msg "100"`[obj-59] also feeds the FPS `number`[obj-52] alongside 30/60/90/120 — missed entirely in the original pass.
- **Resolution presets: a third `"dim 5120 1440"` box (obj-123) is not a duplicate preset.** It doesn't connect to `s resolution` at all — it resizes the OS window and directly resizes `dst`, on a separate wire path from the two genuine duplicates ([obj-135],[obj-163]).
- **`fst`'s quoted creation-attribute string was incomplete** — `@erase_color 0. 0. 0. 1.` was present in the object box but dropped from the quote.
- **The videoplane-mirroring "ambiguity" was over-hedged.** `loadmess 1.`[obj-80] unconditionally overwrites `flonum`[obj-79] on every load regardless of saved state, so the "maybe a saved non-default value explains it" alternative reading doesn't hold up; the `+1.78`/un-mirrored conclusion is solid, not a coin-flip. Downstream references to this (the priority-order list, the pseudocode comment, open question #1) were updated to match.
- **§4's "both chains share the same input arbitration" claim was wrong.** The 11-slot `unpack`/`gswitch` value-routing structure is identical between v122 and v123, but the *selector* logic is not: v122 drove it directly from a manual bus (`leapOverrideUI`); v123 replaced that with an automatic 2-second-no-hands timeout watchdog (`leap2HandsActive`→`timer`→`<2000`→`change`). This is a real design change between versions, not noted at all in the original pass.
- **Missing/added material facts** (present in the listings, absent from the original draft): the render context's own `pak blend_enable 0`[obj-25]/`toggle`[obj-20]/`loadmess 1`[obj-3] chain (parallel to the videoplane's, confirming `blend_enable=1` live at load for both); the render context's `blend_mode` is *not* touched by the videoplane's `6 8` override (stays `6 7`) — worth stating explicitly since the two are easy to conflate; the HSL pix's own `param` defaults (`hue_shift 0.02`, `saturation 0.5`, `lightness 0.5`) that apply before the first control-vector message ever arrives; `td.rota.jxs`'s second texture input (`tex1`) is never wired to anything in either file, so the shader's edge blend/clear modes (boundmode 0/1) are not just unused but unreachable; the `lo2 = -hi2` coupling (via a `*-1.` multiply) on every HSL-pix `scale` object's manual trim flonums; a fully disconnected (`io=0/0`) vestigial subpatcher `p oldconrtrol` containing a third, abandoned brightness/contrast/saturation control chain built on a different shader (`cc.scalebias.jxs`).

Residual uncertainties (unchanged from, or added to, the original "Open questions" list): `worldBump`, `lineSmoothGrain`, `erasetransparency`'s and `scaleInvtoggle`'s UI defaults, and slot 8's 0..1-vs-±1 domain all still depend on files (`feedbax.webui`, `feedbax.leapgemini`, `feedbax.misc`) outside this section's stated scope and were not opened. The `gswitch`/`gswitch2`/`switch` index-to-selector-value mapping and the zoom scalar-to-vec2 broadcast are asserted from standard Max/Jitter behavior, not re-derivable from the text listings alone. Whether `leapOverrideUI` is truly retired (vs. just absent from the current repo's cross-reference) and why `td.rota.jxs` carries a never-wired `tex1` path are new open items surfaced during this pass, not resolvable from the given files.
