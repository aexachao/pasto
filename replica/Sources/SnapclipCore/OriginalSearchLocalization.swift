import Foundation

public enum OriginalSearchLocalization {
    private static let bundle = OriginalResourceBundle.bundle

    public static func text(_ key: String) -> String {
        AppBrand.replacingLegacyName(in: String(localized: LocalizedStringResource(String.LocalizationValue(stringLiteral: key),
            table: "Localizable", locale: OriginalResourceBundle.selectedLocale(), bundle: .atURL(bundle.bundleURL))))
    }
}
