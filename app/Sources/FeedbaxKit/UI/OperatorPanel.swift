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
/// columns, laid out beside `PreviewView` in `feedbax-dev/main.swift`'s `HSplitView`. Every
/// control here calls a method on `EngineViewModel`; this view never touches `Engine`/
/// `ControlRouter` directly (design §5: the operator UI is *a surface*, not a privileged path —
/// see `EngineViewModel`'s own type doc).
///
/// SwiftUI view code has no unit-test rig in this codebase (`EngineViewModelTests` covers the
/// model this view drives; there is no snapshot/UI test harness for the view itself) — this
/// file is verified by `swift build` succeeding and a manual `swift run` pass, per the task
/// brief's step 4, not by `EngineViewModelTests`.
public struct OperatorPanel: View {
  @ObservedObject var vm: EngineViewModel

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
            Slider(value: Binding(get: { vm.eraseValue }, set: { vm.setErase($0) }), in: 0...1)
          }
        }
        Section("Toggles") {
          Toggle("SInvert", isOn: Binding(get: { vm.sInvertOn }, set: { vm.setSInvert($0) }))
          Toggle("Layer Enable", isOn: Binding(get: { vm.layerOn }, set: { vm.setLayerEnabled($0) }))
          Toggle("Wave 1", isOn: Binding(get: { vm.wave1On }, set: { vm.setWave1Enabled($0) }))
          Toggle("Wave 2", isOn: Binding(get: { vm.wave2On }, set: { vm.setWave2Enabled($0) }))
          Toggle("World Bump", isOn: Binding(get: { vm.worldBumpOn }, set: { vm.setWorldBumpEnabled($0) }))
          Toggle("Wave Bump", isOn: Binding(get: { vm.waveBumpOn }, set: { vm.setWaveBumpEnabled($0) }))
          // "kittieBump™" is the original's own on-screen label (spec §04 §1.3) — kept plain
          // here since the brief's "use the original's names" instruction names the 6 slider
          // labels specifically, not the toggle labels.
          Toggle("Kitty Bump", isOn: Binding(get: { vm.kittyBumpOn }, set: { vm.setKittyBumpEnabled($0) }))
        }
        Section("Display") {
          Toggle("Show HUD", isOn: $vm.hudEnabled)
        }
      }
      .padding()
      .frame(minWidth: 260, idealWidth: 300)

      Form {
        Section("Layer Source") {
          Picker("Mode", selection: Binding(get: { vm.layerMode }, set: { vm.setLayerMode($0) })) {
            Text("Sticker").tag(LayerMode.sticker)
            Text("Movie").tag(LayerMode.movie)
          }
          .pickerStyle(.segmented)

          if vm.layerMode == .sticker {
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
        }

        Section("Presets") {
          TextField("Preset name", text: $vm.presetName)
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
    LabeledContent(label) {
      Slider(
        value: Binding(get: { vm.sliderValues[slot] ?? 0 }, set: { vm.slider(slot, changedTo: $0) }),
        in: EngineViewModel.range(for: slot)
      )
    }
  }
}
