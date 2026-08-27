import SwiftUI

/// The Controls Reference window's content (design §8.2): `ControlReference`'s sections as
/// read-only tables, refreshed when — and only when — the bindings change.
///
/// `vm` is a plain `let`, NOT `@ObservedObject`. `EngineViewModel` republishes `axisValues`
/// every frame while the instrument runs, and an `@ObservedObject` subscribes to the object's
/// whole `objectWillChange`, so this view re-ran `body` and rebuilt the entire
/// `ControlReference` (every section, every row, every string interpolation) at 60 Hz to
/// display a table that changes when a pad picker moves. Subscribing to the ONE publisher
/// this window actually depends on — `vm.$bindings`, via `.onReceive` into `@State` — is the
/// same compare-before-assign discipline design §7 asks of the surfaces, applied to a view:
/// don't recompute on a signal that isn't about you.
public struct ControlsReferenceView: View {
  private let vm: EngineViewModel
  @State private var reference: ControlReference

  public init(vm: EngineViewModel) {
    self.vm = vm
    // `_reference` is the `State` wrapper itself: `State(initialValue:)` is how a `@State`
    // property gets a value computed in `init` rather than a literal default.
    _reference = State(initialValue: ControlReference.build(from: vm.bindings))
  }

  public var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        ForEach(reference.sections, id: \.title) { section in
          VStack(alignment: .leading, spacing: 6) {
            Text(section.title).font(.headline)
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 4) {
              ForEach(Array(section.rows.enumerated()), id: \.offset) { _, row in
                GridRow {
                  Text(row.modifiers + row.input)
                    .font(.system(.body, design: .monospaced))
                  Text(row.action)
                  Text(row.kind).foregroundStyle(.secondary)
                }
              }
            }
          }
        }
        Text("Trackpad gestures act on the Output window. Option targets the image layer; Shift targets colour.")
          .font(.footnote)
          .foregroundStyle(.secondary)
      }
      .padding(20)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    // The one signal this window cares about: a pad reassignment (design §7) republishes
    // `bindings`, and only then is the reference rebuilt.
    .onReceive(vm.$bindings) { reference = ControlReference.build(from: $0) }
  }
}
