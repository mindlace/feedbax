import SwiftUI

/// The Controls Reference window's content (design §8.2): `ControlReference`'s sections as
/// read-only tables. Observes the view model so a pad reassignment shows up immediately —
/// `vm.bindings` is `@Published`.
public struct ControlsReferenceView: View {
  @ObservedObject private var vm: EngineViewModel

  public init(vm: EngineViewModel) {
    self.vm = vm
  }

  public var body: some View {
    let reference = ControlReference.build(from: vm.bindings)
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
  }
}
