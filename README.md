# Feedbax

**A real-time audiovisual feedback instrument by Sean Stevens**

Feedbax is a live visual performance tool built in [Max](https://cycling74.com/products/max) (Cycling '74). It takes camera or video input, processes it through GPU shaders and audio-reactive feedback loops, and renders the result to a display. The core visual effect comes from a texture feedback loop — the rendered output is continuously fed back through a chain of color, rotation, and scaling transformations, creating evolving, accumulating imagery that responds to sound and gestural input.

Sean developed Feedbax over roughly 15 years (2009–2025), using it for live performances, installations, and projected visual art. This repository contains the monitor/display-focused version of the instrument, cleaned up for portability. Earlier versions of Feedbax also drove LED arrays via Open Pixel Control; those components are not included here.

Sean Stevens passed on March 9, 2026.

## Getting Started

### Requirements

- **Max 8.6.5 or Max 9** (the patch was saved in Max 9.0.7 and opens in Max 8.6.5). Download from [cycling74.com](https://cycling74.com/downloads). Max can open and run patches in its free mode without a license.
  **Status (Aug 2026):** the feedback loop now runs on Max 9. The original capture used the legacy `usetexture`/`to_texture` messages, which are silent no-ops on the modern `glcore`/`gl3` GL engine (Max 8.6 default, Max 9's only engine), so the loop never closed on a stock install — this is why it "worked for Sean" (who ran Max 8 with the legacy `gl2` engine) but not for others. The capture has been retrofitted to `jit.gl.node @capture 1` and validated on Max 9.1.5 (the loop closes and recirculates through the shader chain, at ~60 fps with no errors). See [docs/diagnosis-2026-08-23.md](docs/diagnosis-2026-08-23.md) for the full evidence, the exact edits, and the remaining fidelity follow-ups (trail-fade tuning).
- **A camera** — any USB webcam will work. NDI network camera input is also supported.
- **A microphone or audio input** — Feedbax is audio-reactive. The built-in mic works, or use a line-in / audio interface.

### Optional

- **Mira** — Cycling '74's iPad app for wireless touch control of Max patches. Feedbax uses Mira for multitouch XY control, pinch, and rotation gestures. Without Mira, you can control parameters directly in the Max patch UI.
- **Ultraleap (Leap Motion)** — hand tracking controller. Install the Ultraleap package from Max's Package Manager if you have the hardware. Without it, the patch falls back to iPad/UI control after a 2-second timeout.

### Running It

1. Open `patches/Feedbax.maxpat` in Max 9.
2. The patch opens with a small preview window (320×180). To go fullscreen or change resolution, use the resolution presets in the patch (options from 1280×720 up to 7680×4320, including 3840×2160 for 4K monitors).
3. The metro (frame clock) starts at load; the render window appears automatically. The FS toggle at the top left is now initialised at load so the preview feedback path is open; toggle it (or press Esc with the render window focused) to go fullscreen, which switches to the full-resolution feedback texture.
4. In the `p picsVid` subpatcher, enable a camera input (USB or NDI) or load an image/video file.
5. Adjust shader parameters via the UI controls or Mira/Ultraleap if available.
6. Audio input is live from `adc~` — make sure Max's audio is turned on (Options → Audio Status) and your input device is selected.

### Controls Overview

The main shader parameters (accessible via the UI, Mira, or Leap Motion) are:

- **theta** — rotation angle of the feedback texture
- **zoom/scale** — zoom level of the feedback
- **xshift / yshift** — translation offset
- **hue shift** — rotates the color hue each feedback frame
- **saturation / lightness** — HSL color adjustments
- **brightness / contrast** — BRCOSA adjustments
- **scalebright / bias** — scale and bias color correction
- **transparency** — erase color alpha (controls how much of the previous frame persists)

The audio section (`p sound2`) draws waveform graphs into the GL context and generates audio-reactive "bumps" that modulate the visual parameters.

## Architecture

The patch is structured around a Jitter GL rendering pipeline with a texture feedback loop:

```
metro (configurable, default 60hz)
  │
  ├─ erase → jit.gl.render "foo"
  │
  ├─ p picsVid ─── camera/NDI/video/image input
  │                 chromakey + lumakey
  │                 → jit.gl.layer (composited into GL context)
  │
  ├─ p sound2 ──── adc~ (microphone)
  │                 → FFT analysis → jit.catch~
  │                 → jit.gl.graph (waveforms drawn into GL context)
  │                 → audio-reactive parameter modulation
  │
  ├─ p shaderfx ── receives rendered texture + control params
  │                 → td.rota.jxs (rotation / zoom / offset)
  │                 → jit.gl.pix (HSL hue shift, saturation, lightness)
  │                 → cc.scalebias.jxs (scale + bias)            [disconnected in v123]
  │                 → jit.gl.pix brcosa (brightness / contrast / saturation)  [disconnected in v123]
  │
  ├─ FEEDBACK LOOP:
  │    jit.gl.texture "fst" (full resolution, e.g. 3840×2160)
  │      ↕ switch toggles between fst/dst
  │    jit.gl.texture "dst"
  │      → p shaderfx → jit.gl.videoplane → back into GL context
  │
  └─ jit.window "foo" → display output
```

Control input flows through two paths that pack a 9-float vector (theta, scale, yshift, xshift, scalebright, bias, hue, NC, sat):

- **p webUI** — Mira iPad multitouch + on-screen controls → `s shadeCtl`
- **p LeapGemini** — Ultraleap hand tracking → `s shadeCtlLeap` (overrides iPad when hands are detected)

All shader files referenced (`td.rota.jxs`, `cc.scalebias.jxs`, `co.chromakey.hsv.jxs`, `co.lumakey.jxs`) and `brcosa.genjit` ship with Max. Note that in this version (v123) the live chain is only `td.rota.jxs → HSL jit.gl.pix`; the `cc.scalebias` slab and the `brcosa` gen stage are present in the file but disconnected (Sean's Max 8 performance builds had brcosa in the chain). The authoritative description of the pipeline is in [docs/spec](docs/spec/README.md).

## File Structure

```
patches/
  Feedbax.maxpat               ← main patch (Max 9)
  variants/
    Feedbax Ultrawide.maxpat   ← multi-monitor/ultrawide support with oversampling (Max 8)
assets/
  NormalFullAlpha1080p1.png    ← full-frame opaque alpha mask (loaded on startup)
  circleGradiant1080p6.png     ← circular gradient alpha mask (vignette effect)
input/
  transparent-background/      ← put your sticker/overlay images here (organized in subdirectories as you like)
output/                        ← screenshots save here
docs/
  spec/                        ← technical description for re-implementation (start at spec/README.md)
  diagnosis-2026-08-23.md      ← why it didn't run, what was fixed, what is left
  *.png                        ← screenshots of each subpatcher for reference
tools/
  maxpat2txt.py                ← render a .maxpat as a readable object/connection listing
  maxdiff.py                   ← structural diff of two patches (or sub-patchers)
  srxref.py                    ← cross-reference every send/receive bus across patches/
version.txt                    ← current version identifier
```

The Ultrawide variant adds multi-monitor resolution presets (e.g. 6400×1800 for dual ultrawides), oversampling controls, and dual-screen screenshot capture. It was saved in Max 8.6.x but should open in Max 9.

### Media Setup

**Sticker images**: Place your transparent-background images (PNGs with alpha channels) in `input/transparent-background/`. On load, `feedbax.pathsetup` resolves the project root and populates the sticker menu in `p pic` (inside `feedbax.picsvid`) from that folder; the "rescan" message boxes in picsVid re-run the scan if you add files while running. Select an image from that menu (or with the Video +/− buttons in the webUI) and turn on "pic enable".

**Alpha masks**: `feedbax.pathsetup` adds `assets/` to Max's search path at load, so the two mask PNGs are found without any File Preferences setup. (They only affect the live-camera path.)

**Screenshots**: Captured screenshots save to the `output/` directory in the project root.

## History

Feedbax evolved through several generations:

- **2009–2013** — early versions driving LED arrays via Processing and Color Kinetics hardware
- **2010–2016** — "Feedbax LED" series (v3.86 through v4.4b15), using Jitter matrix processing for LED output via Open Pixel Control and DMX/ArtNet
- **2013–2019** — "Synesthesia Analog Analog" — a related instrument focused on audio-to-visual synthesis
- **2019–2024** — "Feedbax gl + image" series, rebuilt around Jitter's GPU/OpenGL pipeline (`jit.gl.pix`, `jit.gl.slab`, `jit.gl.render`) for high-resolution monitor output
- **2024–2025** — "DeployabilityCleanup" builds (v121–v123), streamlining the patch for portability and ease of use

## License

[MIT](LICENSE)

## Credits

Created by [Sean Stevens](https://seanstevens.com).

Open-sourced posthumously by Ethan Fremen.
