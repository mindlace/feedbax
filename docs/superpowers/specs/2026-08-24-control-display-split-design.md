# Control/Display Split — Design

**Status:** draft for review
**Date:** 2026-08-24

## Problem

The instrument is currently one window: `ContentView` puts `PreviewView` and
`OperatorPanel` side by side in an `HSplitView`. A performer cannot put the
output on a projector and keep the controls on the laptop screen, because the
two are the same window.

Worse, the window *is* the engine. `MetalHostView` owns the `FrameClock`, owns
the `OutputStage`, and is the only thing that calls `engine.step`. No window
means no rendering — and for a feedback instrument, no rendering means the
accumulator stops evolving. The image is the state.

## Goals

1. Output and controls are separate windows, placeable on separate screens.
2. The engine keeps running when either window (or both) is closed.
3. Either window can be brought back from the Window menu.
4. Keyboard and gamepad bindings work whenever the app is frontmost, regardless
   of which window has focus.
5. Both entry points — `feedbax-dev` and the `Feedbax.app` bundle — behave
   identically (design §8).

## Non-goals

- No live preview in the control window. The performer watches the projector.
- No display-picker UI. Drag the output window to the projector and use native
  fullscreen.
- No networked or remote control surface. Both windows are in one process on
  one machine, sharing engine state directly in memory.

## Architecture

The central move is **inverting the ownership between the engine and the
window**. Today the render view owns the clock and pulls frames. After this
change the engine owns the clock and pushes frames to whatever is attached.

### `EngineHost` (new, in `FeedbaxKit`)

Owns the `Engine` and the frame clock. Steps the engine once per tick, forever,
from the moment the app launches until it quits. Holds an optional render
target; when one is attached, it presents each completed frame into it.

This is the unit that makes goal 2 true. Nothing about stepping the engine
depends on a window existing.

```
EngineHost
  ├─ engine: Engine
  ├─ driver: FrameDriver        (swapped when a target attaches/detaches)
  ├─ target: RenderTarget?      (the output window's layer, when open)
  └─ tick():  step engine → present into target if there is one
```

### `FrameDriver` (new protocol, two implementations)

`CAMetalDisplayLink` is bound to a `CAMetalLayer` and cannot exist without one,
so windowless operation needs a second clock:

- **`DisplayLinkDriver`** — wraps today's `FrameClock`. Used whenever the output
  window is open. Vsync-locked to whichever display that window is on, which is
  what we want on a projector, and it hands us the drawable directly.
- **`TimerDriver`** — a `DispatchSourceTimer` at `engine.frameRate`, used when no
  output window exists. Steps the engine and presents nothing.

`EngineHost` swaps drivers on attach/detach. The swap is the only stateful part
of this design and is where the tests should concentrate.

### Scenes

Both entry points currently declare a duplicate `ContentView` and a duplicate
`FeedbaxApp`. Replace both with one shared `FeedbaxScenes` in `FeedbaxKit`:

- `Window("Output", id: "output")` — hosts `RenderView`, the stripped-down
  presenter. Resizable, titled, native-fullscreen capable.
- `Window("Controls", id: "controls")` — hosts `OperatorPanel` alone.

`Window` (as opposed to `WindowGroup`) is single-instance and gets a Window-menu
entry for free, which is goal 3. Closing either window tears down only its view;
`EngineHost` is untouched and keeps stepping. Reopening reattaches.

`feedbax-dev` keeps its `NSApplicationDelegateAdaptor` activation-policy
workaround — that stays a genuine difference between an unbundled executable and
a Launch Services-launched bundle.

### `RenderView` (was `MetalHostView`)

Loses almost everything. It no longer owns a clock, no longer calls
`engine.step`, and no longer handles input. It becomes: a `CAMetalLayer`, a
drawable-size sync on resize, and an `attach`/`detach` pair that registers its
layer with `EngineHost`.

`OutputStage` moves to `EngineHost` — it is per-engine, not per-view. Note that
today it is built with `try?` and silently disables rendering forever if it
throws (`PreviewView.swift:100` + `:129`). Moving it up is the chance to make
that failure loud instead of silent.

### Input

Input moves from the render view to an app-level `NSEvent` local monitor
installed by `EngineHost`, forwarding `keyDown`/`keyUp`/`flagsChanged`/
`scrollWheel`/`magnify` to `KeyboardTrackpadSurface`. That is goal 4: focus
stops mattering.

**Care needed:** a local monitor sees events destined for the control panel's own
text fields. The monitor must pass events through untouched when the first
responder is an `NSText`-family view, or typing a preset name will trigger
keyboard bindings.

## Fix carried along

`EngineViewModel.poll` calls `refreshMirrorsFromTruth`, which writes eight
`@Published` properties **every frame**, firing `objectWillChange` at 60 Hz and
re-evaluating `OperatorPanel.body` 60 times a second
(`EngineViewModel.swift:157-167`). That is wasteful today and worse once the
panel is a window of its own. `refreshMirrorsFromTruth` should compare before
assigning and publish only on actual change.

This is in scope because the split is what makes it bite.

## Testing

The valuable tests here are headless and do not need a window:

- `EngineHost` keeps stepping with no target attached (drives `TimerDriver`),
  asserted by frame count advancing over a fixed wall-clock interval.
- Attaching and detaching a target swaps drivers without dropping or
  double-stepping a frame.
- The accumulator's contents survive a detach/reattach cycle — this is the test
  that encodes "closing the output window doesn't lose your image."
- The key monitor forwards a synthesized `keyDown` to the surface, and does
  *not* forward when a text responder is first responder.

Window placement, fullscreen and the Window menu are AppKit behavior and get
verified by hand, not by tests.

## Migration notes

`PreviewView.swift` is 220 lines that become roughly three separate things
(`EngineHost`, `FrameDriver`, `RenderView`). It should not survive as one file.

## Open question

Whether `TimerDriver` should run at full `engine.frameRate` when nothing is
being displayed, or throttle. Full rate keeps the feedback evolution
time-accurate — the image you get back on reopening is the one you would have
had. Throttling saves GPU but makes the loop's evolution depend on whether
anyone was watching, which for a feedback instrument is a behavioral change, not
an optimization. Recommend full rate.
