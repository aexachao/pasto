import Foundation

private final class OriginalResourceBundleFinder: NSObject { }

/// Locates the owned resources packaged with the Core module.
enum OriginalResourceBundle {
    /// Unsupported languages deliberately use English copy and English plural rules.
    static func selectedLocale(preferredLanguages: [String] = Locale.preferredLanguages) -> Locale {
        let first = preferredLanguages.first { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty } ?? "en"
        return Locale(identifier: first.lowercased().hasPrefix("zh") ? "zh-Hans" : "en")
    }

    static let bundle: Bundle = {
        let directories = [Bundle.main.resourceURL,
                           Bundle(for: OriginalResourceBundleFinder.self).resourceURL,
                           Bundle.main.bundleURL].compactMap { $0 }
        for directory in directories {
            if let bundle = Bundle(url: directory.appendingPathComponent("Snapclip_SnapclipCore.bundle")) {
                return bundle
            }
        }
        return Bundle.module
    }()
}
