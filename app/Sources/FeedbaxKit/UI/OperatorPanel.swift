import SwiftUI

/// `Picker`'s `selection` requires `Hashable`; `Engine.LayerMode` (Engine.swift) only declares
/// `Equatable` — it has no associated values and no stored properties beyond its own cases, so
/// this is a trivial, always-consistent manual conformance (delegates to the enum's own
/// `presetIdentifier`, which already differs per case), not a workaround for anything the type
/// couldn't otherwise support.
extension LayerMode: Hashable {
  public func hash(into hasher: inout Hasher) { hasher.combine(presetIdentifier) }
}

/// The operator's live-performance control panel (Task 20) — plain SwiftUI forms in two
/// columns. It is the Controls window's entire content (`FeedbaxScenes`/`ControlsWindowContent`,
/// Task 5) — a separate window from the output, not beside it in a split view. Every control
/// here calls a method on `EngineViewModel`; this view never touches `Engine`/`ControlRouter`
/// directly (design §5: the operator UI is *a surface*, not a privileged path — see
/// `EngineViewModel`'s own type doc).
///
/// SwiftUI view code has no unit-test rig in this codebase (`EngineViewModelTests` covers the
/// model this view drives; there is no snapshot/UI test harness for the view itself) — this
/// file is verified by `swift build` succeeding and a manual `swift run` pass, per the task
/// brief's step 4, not by `EngineViewModelTests`.
public struct OperatorPanel: View {
  @ObservedObject var vm: EngineViewModel
  /// AppKit pins a window's first responder to the preset-name field's field editor once it's
  /// been given focus, and does NOT hand it back just because the performer clicks a slider or
  /// a checkbox afterward (`PerformerInputMonitor.isTextEditor`'s check is reading real AppKit
  /// state correctly — that monitor's "text editor has focus → pass through" rule is not the
  /// bug). Left alone, that stranded focus makes every keyboard binding silently dead from the
  /// Controls window for the rest of the session (spec goal 4) the moment a performer names a
  /// preset. `@FocusState`, cleared on Return and Escape below, is what actually tells AppKit to
  /// resign the field as first responder.
  @FocusState private var presetNameFieldFocused: Bool

  public init(vm: EngineViewModel) {
    self.vm = vm
  }

  /// The 7 live slot sliders, in `ControlSlot`'s own declaration order, labeled with the
  /// original's on-screen names where the original HAD a manual slider for that slot (spec
  /// §04 §1.2): HUE-SHIFT (slot 0), BRIGHTNESS (slot 1), ZOOM (slot 5), rotate (slot 6, sic —
  /// lowercase, matching the original's label literally), SATURATION (slot 8). `.panX`/`.panY`
  /// (slots 3/4, spec rows "xshift"/"yshift") were touch-only in the original — driven by
  /// `mira.mt.centroid`, never a manual slider widget with an on-screen label — so "PAN X"/
  /// "PAN Y" here are this port's own descriptive names, not a preserved original one.
  private static let sliderLabels: [(ControlSlot, String)] = [
    (.hue, "HUE-SHIFT"),
    (.bias, "BRIGHTNESS"),
    (.panX, "PAN X"),
    (.panY, "PAN Y"),
    (.zoom, "ZOOM"),
    (.theta, "rotate"),
    (.saturation, "SATURATION"),
  ]

  /// The image layer's four live axes (design §4) — reachable here even when neither pad is
  /// assigned to them. Upper-case to sit beside the original's shader labels.
  private static let layerSliderLabels: [(LayerAxis, String)] = [
    (.x, "IMAGE X"), (.y, "IMAGE Y"), (.scale, "IMAGE SCALE"), (.rotate, "IMAGE ROTATE"),
  ]

  /// Two plain columns (the brief's own words) via `HStack`, not another `HSplitView` — the
  /// draggable-divider split is reserved for the outer preview/panel layout in
  /// `feedbax-dev/main.swift`; nesting a second one here would give the operator two resize
  /// handles for what's conceptually one panel.
  public var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Form {
        Section("Shader Control") {
          ForEach(Self.sliderLabels, id: \.0) { slot, label in
            slider(label, slot: slot)
          }
          // TRANSPARANCY (sic — the original's spelling, spec §04 §1.4's erase-trail slider):
          // NOT one of the 9 shadeCtl slots — a direct `ControlRouter.eraseControl` write
          // (`EngineViewModel.setErase`'s own doc comment), so it isn't in `sliderLabels` above.
          LabeledContent("TRANSPARANCY") {
            HStack(spacing: 8) {
              Slider(value: Binding(get: { vm.eraseValue }, set: { vm.setErase($0) }), in: 0...1)
              Text(String(format: "%.2f", vm.eraseValue))
                .monospacedDigit()
                .foregroundStyle(.secondary)
                .frame(width: 44, alignment: .trailing)
            }
          }
        }
        Section("Toggles") {
          Toggle("SInvert", isOn: Binding(get: { vm.sInvertOn }, set: { vm.setSInvert($0) }))
          // TODO(Task 4): this toggle is being replaced by the picker's `Off` tile — selection
          // is the on/off state now (2026-08-29 design doc §3).
          Toggle("Layer Enable", isOn: Binding(get: { vm.imageShown },
                                               set: { $0 ? vm.showSelectedImage() : vm.hideImage() }))
          Toggle("Wave 1", isOn: Binding(get: { vm.wave1On }, set: { vm.setWave1Enabled($0) }))
          Toggle("Wave 2", isOn: Binding(get: { vm.wave2On }, set: { vm.setWave2Enabled($0) }))
          Toggle("World Bump", isOn: Binding(get: { vm.worldBumpOn }, set: { vm.setWorldBumpEnabled($0) }))
          Toggle("Wave Bump", isOn: Binding(get: { vm.waveBumpOn }, set: { vm.setWaveBumpEnabled($0) }))
          // "kittieBump™" is the original's own on-screen label (spec §04 §1.3) — kept plain
          // here since the brief's "use the original's names" instruction names the 6 slider
          // labels specifically, not the toggle labels.
          Toggle("Image Bump", isOn: Binding(get: { vm.imageBumpOn }, set: { vm.setImageBumpEnabled($0) }))
        }
        Section("Display") {
          Toggle("Show HUD", isOn: $vm.hudEnabled)
        }
      }
      .padding()
      .frame(minWidth: 260, idealWidth: 300)

      Form {
        // The original's two Mira pads (spec §04 §1.2–1.3), each assignable to any two live
        // axes; defaults come from the bindings table (design §7).
        Section("Surfaces") {
          HStack(alignment: .top, spacing: 16) {
            ForEach(Array(vm.bindings.pads.indices), id: \.self) { index in
              padColumn(index)
            }
          }
        }

        Section("Layer Source") {
          Picker("Mode", selection: Binding(get: { vm.layerMode }, set: { vm.setLayerMode($0) })) {
            Text("Sticker").tag(LayerMode.sticker)
            Text("Movie").tag(LayerMode.movie)
          }
          .pickerStyle(.segmented)

          ForEach(Self.layerSliderLabels, id: \.0) { axis, label in
            slider(label, axis: .layer(axis))
          }

          if vm.layerMode == .sticker {
            // Drop zone + thumbnail grid. The stepper and slider below stay: they are what the
            // keyboard/gamepad bindings drive, and the grid writes the same selection they do.
            StickerPicker(vm: vm)
            Stepper(
              "Sticker \(vm.stickerIndex + 1) / \(max(vm.stickerItemCount, 1))",
              value: Binding(get: { vm.stickerIndex }, set: { vm.setStickerIndex($0) }),
              in: 0...max(vm.stickerItemCount - 1, 0)
            )
            Slider(
              value: Binding(
                get: { vm.stickerItemCount > 0 ? Double(vm.stickerIndex) / Double(vm.stickerItemCount) : 0 },
                set: { vm.setStickerNormalized($0) }),
              in: 0...1
            )
          } else {
            Button(vm.movieFileName ?? "Choose Movie…") { vm.pickMovieFile() }
            if let name = vm.movieFileName {
              Text(name).foregroundStyle(.secondary)
            }
          }
        }

        Section("Venue") {
          Picker("Resolution", selection: Binding(get: { vm.resolution }, set: { vm.setResolution($0) })) {
            ForEach(Engine.resolutionPresets, id: \.self) { size in
              Text("\(size.x)×\(size.y)").tag(size)
            }
          }
          Picker("Frame Rate", selection: Binding(get: { vm.frameRate }, set: { vm.setFrameRate($0) })) {
            ForEach(Engine.frameRatePresets, id: \.self) { rate in
              Text("\(rate) fps").tag(rate)
            }
          }
          Picker("Feedback sampling", selection: Binding(get: { vm.warpFilter }, set: { vm.setWarpFilter($0) })) {
            Text("Nearest (parity)").tag(WarpFilter.nearest)
            Text("Linear").tag(WarpFilter.linear)
          }
        }

        Section("Presets") {
          TextField("Preset name", text: $vm.presetName)
            .focused($presetNameFieldFocused)
            // Both Return and Escape just relinquish first responder — neither actually commits
            // or reverts anything here: `$vm.presetName` has already been written character by
            // character regardless of which key ends the edit (Escape does NOT restore whatever
            // the field held before typing started), and saving the preset is still a separate,
            // explicit "Save" button press. Both keys are just "done with this field" gestures.
            // Without releasing focus on them, `f`/Escape's own fullscreen-toggle role and every
            // other binding stay dead from Controls until the app relaunches (see this
            // property's doc comment).
            .onSubmit { presetNameFieldFocused = false }
            .onExitCommand { presetNameFieldFocused = false }
          Button("Save") { vm.saveCurrentPreset() }
            .disabled(vm.presetName.isEmpty)
          if vm.presetNames.isEmpty {
            Text("No saved presets").foregroundStyle(.secondary)
          } else {
            ForEach(vm.presetNames, id: \.self) { name in
              Button(name) { vm.recallPreset(named: name) }
            }
          }
          Button("Refresh List") { vm.refreshPresetList() }
        }
      }
      .padding()
      .frame(minWidth: 260, idealWidth: 300)
    }
  }

  private func slider(_ label: String, slot: ControlSlot) -> some View {
    slider(label, axis: .slot(slot))
  }

  private func slider(_ label: String, axis: ControlAxis) -> some View {
    let raw = vm.axisValues[axis] ?? 0
    // Slot faders show the original panel's reading (EngineViewModel.maxPanelValue); layer
    // axes had no Max fader, so they show the raw value.
    let readout: Double
    if case .slot(let slot) = axis { readout = EngineViewModel.maxPanelValue(for: slot, raw: raw) } else { readout = raw }
    return LabeledContent(label) {
      HStack(spacing: 8) {
        Slider(value: axisBinding(axis), in: EngineViewModel.range(for: axis))
        Text(String(format: "%.2f", readout))
          .monospacedDigit()
          .foregroundStyle(.secondary)
          .frame(width: 44, alignment: .trailing)
      }
    }
  }

  private func axisBinding(_ axis: ControlAxis) -> Binding<Double> {
    Binding(get: { vm.axisValues[axis] ?? 0 }, set: { vm.axis(axis, changedTo: $0) })
  }

  private func padColumn(_ index: Int) -> some View {
    let pad = vm.bindings.pads[index]
    return VStack(spacing: 6) {
      XYPad(x: axisBinding(pad.x), y: axisBinding(pad.y),
            xRange: EngineViewModel.range(for: pad.x), yRange: EngineViewModel.range(for: pad.y))
        .frame(width: 160, height: 160)
      axisPicker("X", selection: pad.x) { vm.setPadAxis(pad: index, .x, to: $0) }
      axisPicker("Y", selection: pad.y) { vm.setPadAxis(pad: index, .y, to: $0) }
    }
  }

  private func axisPicker(_ label: String, selection: ControlAxis,
                          onChange: @escaping (ControlAxis) -> Void) -> some View {
    Picker(label, selection: Binding(get: { selection }, set: onChange)) {
      ForEach(ControlAxis.live, id: \.self) { axis in
        Text(axis.displayName).tag(axis)
      }
    }
    .frame(width: 160)
  }
}
