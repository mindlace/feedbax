# Feedbax

**A real-time audiovisual feedback instrument by Sean Stevens**

Feedbax is a live visual performance tool built in [Max](https://cycling74.com/products/max) (Cycling '74). It takes camera or video input, processes it through GPU shaders and audio-reactive feedback loops, and renders the result to a display. The core visual effect comes from a texture feedback loop — the rendered output is continuously fed back through a chain of color, rotation, and scaling transformations, creating evolving, accumulating imagery that responds to sound and gestural input.

Sean developed Feedbax over roughly 15 years (2009–2025), using it for live performances, installations, and projected visual art. This repository contains the monitor/display-focused version of the instrument, cleaned up for portability. Earlier versions of Feedbax also drove LED arrays via Open Pixel Control; those components are not included here.

Sean Stevens died of cancer on March 9, 2026.

## Getting Started

### Requirements

- **Max 9** (the main patch was saved in Max 9.0.7). Download from [cycling74.com](https://cycling74.com/downloads). Max can open and run patches in its free mode without a license.
- **A camera** — any USB webcam will work. NDI network camera input is also supported.
- **A microphone or audio input** — Feedbax is audio-reactive. The built-in mic works, or use a line-in / audio interface.

### Optional

- **Mira** — Cycling '74's iPad app for wireless touch control of Max patches. Feedbax uses Mira for multitouch XY control, pinch, and rotation gestures. Without Mira, you can control parameters directly in the Max patch UI.
- **Ultraleap (Leap Motion)** — hand tracking controller. Install the Ultraleap package from Max's Package Manager if you have the hardware. Without it, the patch falls back to iPad/UI control after a 2-second timeout.

### Running It

1. Open `patches/Feedbax v123.maxpat` in Max 9.
2. The patch opens with a small preview window (320×180). To go fullscreen or change resolution, use the resolution presets in the patch (options from 1280×720 up to 7680×4320, including 3840×2160 for 4K monitors).
3. Click the toggle at the top to start the metro (frame clock). You should see the render window appear.
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
  │                 → cc.scalebias.jxs (scale + bias)
  │                 → jit.gl.pix brcosa (brightness / contrast / saturation)
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

All shader files referenced (`td.rota.jxs`, `cc.scalebias.jxs`, `co.chromakey.hsv.jxs`, `co.lumakey.jxs`) are standard Max/Jitter builtins. The `brcosa` gen patcher and the custom HSL-shift `jit.gl.pix` are compiled inline in the `.maxpat` JSON.

## File Structure

```
patches/
  Feedbax v123.maxpat          ← main patch (Max 9, Oct 2025)
  variants/
    Feedbax v116 iPad UI.maxpat       ← enhanced Mira/iPad controls (Max 8, Aug 2025)
    Feedbax v119 Langton.maxpat       ← cellular automata variant (Max 8, Nov 2024)
    Feedbax v121 Ultrawide.maxpat     ← ultrawide monitor support (Max 8, Jan 2025)
    Feedbax v116 CAS Fork.maxpat      ← CAS collaboration fork (Max 8, May 2025)
    Feedbax v122 CAS Images.maxpat    ← CAS with image features (Max 8, Apr 2025)
    Synesthesia Analog 2.0 Mira.maxpat ← related instrument (Max 8, Dec 2024)
    Video2Sound.maxpat                 ← utility patch (Max 8, Dec 2024)
assets/
  NormalFullAlpha1080p1.png    ← full-frame opaque alpha mask (loaded on startup)
  circleGradiant1080p6.png     ← circular gradient alpha mask (vignette effect)
docs/
  *.png                        ← screenshots of each subpatcher for reference
```

The variant patches were saved in Max 8.6.x but should open in Max 9. They represent different feature branches that Sean maintained in parallel — the v123 "DeployabilityCleanup" is the canonical, streamlined build.

### Asset Setup

The main patch expects the alpha mask images to be findable by Max's search path. The simplest approach: in Max, go to Options → File Preferences and add the `assets/` folder to the search path. Alternatively, copy the two PNG files into the same directory as the patch.

## History

Feedbax evolved through several generations:

- **2009–2013** — early versions driving LED arrays via Processing and Color Kinetics hardware
- **2010–2016** — "Feedbax LED" series (v3.86 through v4.4b15), using Jitter matrix processing for LED output via Open Pixel Control and DMX/ArtNet
- **2013–2019** — "Synesthesia Analog Analog" — a related instrument focused on audio-to-visual synthesis
- **2019–2024** — "Feedbax gl + image" series, rebuilt around Jitter's GPU/OpenGL pipeline (`jit.gl.pix`, `jit.gl.slab`, `jit.gl.render`) for high-resolution monitor output
- **2024–2025** — "DeployabilityCleanup" builds (v121–v123), streamlining the patch for portability and ease of use

## License

[Choose a license — MIT, GPL, or Creative Commons are common choices for artistic software]

## Credits

Created by **Sean Stevens** of Recollective / Sustainable Magic.

Open-sourced posthumously by Ethan Jucovy.
