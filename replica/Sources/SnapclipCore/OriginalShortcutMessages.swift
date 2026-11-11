import Foundation

/// Shortcut copy uses the same owned-resource language policy as other Core copy.
enum OriginalShortcutMessages {
    private static let bundle = OriginalResourceBundle.bundle

    static func value(_ key: String) -> String {
        String(localized: LocalizedStringResource(String.LocalizationValue(key), table: "Localizable",
            locale: OriginalResourceBundle.selectedLocale(), bundle: .atURL(bundle.bundleURL)))
    }

    static func menuConflict(_ title: String) -> String {
        String(localized: LocalizedStringResource("shortcut-recorder.error.used-in-menu",
            defaultValue: "\(title)", table: "Localizable", locale: OriginalResourceBundle.selectedLocale(),
            bundle: .atURL(bundle.bundleURL)))
    }
}
