import AppKit

/// Independently authored artwork; the existing picker API remains stable.
public enum OriginalSettingsIllustrations {
    @MainActor private static let images: [String: NSImage] = {
        var result: [String: NSImage] = [:]
        for directPaste in [false, true] {
            for dark in [false, true] {
                result["\(directPaste)-\(dark)"] = SnapclipAssetRenderer.settings(directPaste: directPaste, dark: dark)
            }
        }
        return result
    }()

    @MainActor public static func image(directPaste: Bool, dark: Bool) -> NSImage? {
        images["\(directPaste)-\(dark)"]
    }
}
