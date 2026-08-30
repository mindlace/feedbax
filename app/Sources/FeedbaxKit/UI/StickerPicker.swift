import SwiftUI

/// The sticker half of the panel's "Layer Source" section: a drop zone that feeds the sticker
/// folder, and a thumbnail grid for picking among what's in it.
///
/// This exists because flipping through images with only a stepper and a 0…1 slider means
/// choosing blind — you cannot tell what index 7 *is* until it is already on the output. The
/// grid makes "how does this behave with several images, switching between them" a thing you
/// can do by looking (which is the whole reason it was asked for), while the stepper and
/// slider stay exactly as they were: they are what the keyboard and gamepad bindings drive,
/// and a click here writes the same `selectedIndex` they do — no privileged path (design §5).
///
/// The grid is collapsible and height-capped on purpose. The Controls window is already dense
/// (Shader Control, Toggles, Display, Surfaces, Layer Source, Venue, Presets in two columns),
/// so an uncapped grid of a folder with fifty stickers in it would push Venue and Presets off
/// the bottom. Capped + internally scrolling + collapsible means a big folder costs a fixed
/// amount of panel, and an operator who doesn't want the grid at all can fold it away and get
/// the old compact layout back.
///
/// Like the rest of `OperatorPanel`, this view has no unit tests (there is no SwiftUI test rig
/// in this package) — `EngineViewModel`/`StickerSource` carry the tested logic, and this is
/// verified by `swift build` plus a manual run.
struct StickerPicker: View {
  @ObservedObject var vm: EngineViewModel

  /// Survives relaunch: whether the grid is worth its panel space is a per-operator habit, not
  /// something to re-decide every session.
  @AppStorage("feedbax.stickerGridExpanded") private var isExpanded = true

  @State private var isTargeted = false

  /// The image column is ~320pt wide now that the pads have their own band (2026-08-29 design
  /// doc §5), so a `Form` row's control column fits roughly four 56pt tiles per row instead of
  /// the two the old 44pt tiles managed at a 600pt window.
  private static let tileSize: CGFloat = 56
  /// ~3 rows. The cap is no longer about protecting Venue and Presets from being pushed off
  /// the bottom of a 950pt column — it is about the grid not crowding the stepper and slider
  /// directly beneath it.
  private static let gridMaxHeight: CGFloat = 200

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      dropZone
      if let message = vm.stickerImportMessage {
        Text(message)
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      DisclosureGroup(isExpanded: $isExpanded) {
        gridBody
        Text(vm.imageShown ? (vm.selectedStickerName ?? "—") : "No image")
          .font(.caption)
          .foregroundStyle(.secondary)
          .lineLimit(1)
          .truncationMode(.middle)
          .frame(maxWidth: .infinity, alignment: .leading)
      } label: {
        Text("Images (\(vm.stickerNames.count))")
      }
    }
    // On the whole section, not just the dashed rectangle: once you know the panel takes
    // drops, aiming at a specific target is friction. The rectangle is the affordance; the
    // section is the target.
    .dropDestination(for: URL.self) { urls, _ in
      vm.importStickers(urls)
      return true
    } isTargeted: { isTargeted = $0 }
  }

  /// Zone and button are stacked, not side by side: side by side, the narrow trailing column
  /// truncates both down to "Dro…" and "A…" — verified on the real panel, not guessed.
  private var dropZone: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack(spacing: 6) {
        Image(systemName: "square.and.arrow.down")
          .foregroundStyle(.secondary)
        Text("Drop images here")
          .lineLimit(1)
          .minimumScaleFactor(0.8)
      }
      if let folder = vm.stickerFolder {
        Text(folder.lastPathComponent)
          .font(.caption)
          .foregroundStyle(.secondary)
          .lineLimit(1)
          .truncationMode(.head)
          .help(folder.path)   // the full path, on hover — the panel has no room for it
      }
      Button("Add Images…") { vm.pickStickerFiles() }
        .controlSize(.small)
    }
    .padding(8)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 6)
        .fill(isTargeted ? Color.accentColor.opacity(0.15) : Color.clear)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 6)
        .strokeBorder(isTargeted ? Color.accentColor : Color.secondary.opacity(0.4),
                      style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
    )
  }

  @ViewBuilder
  private var gridBody: some View {
    if vm.stickerNames.isEmpty {
      Text("No images in this folder yet.")
        .font(.caption)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 6)
    } else {
      ScrollView {
        LazyVGrid(
          columns: [GridItem(.adaptive(minimum: Self.tileSize), spacing: 6, alignment: .leading)],
          alignment: .leading,
          spacing: 6
        ) {
          offTile
          ForEach(vm.stickerNames, id: \.self) { name in
            tile(name)
          }
        }
        .padding(.vertical, 4)
      }
      .frame(maxHeight: Self.gridMaxHeight)
    }
  }

  private func tile(_ name: String) -> some View {
    let isSelected = vm.imageShown && name == vm.selectedStickerName
    // No per-tile filename: at 44 pt a caption truncates to "cir…ng", which tells the operator
    // nothing. The name lives in the tooltip and in the selected-image line under the grid.
    return Button {
      vm.selectSticker(named: name)
    } label: {
      ZStack {
        // Stickers are mostly transparent PNGs; a flat neutral tile is what makes their alpha
        // readable here instead of dissolving into the window background.
        RoundedRectangle(cornerRadius: 4)
          .fill(Color.secondary.opacity(0.12))
        if let thumbnail = vm.stickerThumbnails[name] {
          Image(nsImage: thumbnail)
            .resizable()
            .scaledToFit()
            .padding(3)
        } else {
          // File is listed but wouldn't decode — say so rather than showing an empty tile.
          Image(systemName: "exclamationmark.triangle")
            .foregroundStyle(.secondary)
        }
      }
      .frame(width: Self.tileSize, height: Self.tileSize)
      .overlay(
        RoundedRectangle(cornerRadius: 4)
          .strokeBorder(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
      )
    }
    .buttonStyle(.plain)
    .help(name)
  }

  /// The replacement for the old "Layer Enable" checkbox. It is a UI affordance, NOT an entry
  /// in `StickerSource.items` — it shifts no index, `itemCount` does not count it, and the
  /// stepper and normalized slider never reach it (2026-08-29 design doc §3.1). Those three
  /// are the index space the keyboard and gamepad drive; a sentinel in them would offset every
  /// selection a performer has memorised.
  private var offTile: some View {
    let isSelected = !vm.imageShown
    return Button {
      vm.hideImage()
    } label: {
      ZStack {
        RoundedRectangle(cornerRadius: 4)
          .fill(Color.secondary.opacity(0.08))
        Image(systemName: "nosign")
          .foregroundStyle(.secondary)
      }
      .frame(width: Self.tileSize, height: Self.tileSize)
      .overlay(
        RoundedRectangle(cornerRadius: 4)
          .strokeBorder(isSelected ? Color.accentColor : Color.secondary.opacity(0.35),
                        style: StrokeStyle(lineWidth: isSelected ? 2 : 1, dash: isSelected ? [] : [3, 2]))
      )
    }
    .buttonStyle(.plain)
    .help("Show no image")
  }
}
