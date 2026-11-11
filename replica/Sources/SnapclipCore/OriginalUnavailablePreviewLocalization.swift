import Foundation

/// The unsupported preview uses the original localizable keys and bundle fallback.
public enum OriginalUnavailablePreviewLocalization {
    private static let resourceBundle = OriginalResourceBundle.bundle

    private static func resource(_ key: String) -> LocalizedStringResource {
        LocalizedStringResource(String.LocalizationValue(stringLiteral: key),
                                table: "Localizable", locale: OriginalResourceBundle.selectedLocale(),
                                bundle: .atURL(resourceBundle.bundleURL))
    }

    public static func f_1001daf54() -> LocalizedStringResource { resource("preview.unavailable.title") }
    public static func f_1001dadd4() -> LocalizedStringResource { resource("preview.unavailable.subtitle") }
}
