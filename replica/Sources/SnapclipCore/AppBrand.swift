import Foundation

/// Display branding only. Persisted identifiers and storage paths remain stable across upgrades.
public enum AppBrand {
    public static let chineseName = "闪贴"
    public static let englishName = "Snapclip"

    public static var name: String {
        name(preferredLanguages: Locale.preferredLanguages)
    }

    public static func name(preferredLanguages: [String]) -> String {
        preferredLanguages.first?.lowercased().hasPrefix("zh") == true ? chineseName : englishName
    }

    public static func replacingLegacyName(in copy: String) -> String {
        copy.replacingOccurrences(of: "Pasto", with: name)
    }
}
