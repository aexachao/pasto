import AppKit
import Foundation

public enum OriginalStackCategoryIcons {
    // 0x100051d2c: these are category images, independent of the source application.
    public static func name(for kind: OriginalPasteboardContentKind) -> String {
        switch kind {
        case .files: return "icon.file"
        case .color, .text: return "icon.text"
        case .link: return "icon.link"
        case .unknown, .image: return "icon.unknown"
        }
    }

    @MainActor private static let images: [String: NSImage] = [
        "icon.file": SnapclipAssetRenderer.category(.file),
        "icon.link": SnapclipAssetRenderer.category(.link),
        "icon.text": SnapclipAssetRenderer.category(.text),
        "icon.unknown": SnapclipAssetRenderer.category(.unknown)
    ]

    @MainActor public static func image(for kind: OriginalPasteboardContentKind) -> NSImage {
        images[name(for: kind)]!
    }
}
