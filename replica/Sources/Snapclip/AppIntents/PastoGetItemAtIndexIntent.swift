import AppIntents
import Foundation
import SnapclipCore

/// Reads the first original representation; it does not restore the clipboard or synthesize OCR text.
struct PastoGetItemAtIndexIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Snapclip Item at Index"

    @Parameter(title: "Index", description: "Item Index", controlStyle: .stepper)
    var index: Int

    @Parameter(title: "Snapclip")
    var pinboard: PastoPinboardEntity

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String?> {
        let store = try PastoAppIntentStore.refreshedStore()
        guard let items = pinboard.items(in: store) else {
            throw PastoIndexedItemError.pinboardNotFound
        }
        // Use the actual local collection order, without claiming the original repository order.
        guard items.indices.contains(index) else { throw PastoIndexedItemError.itemNotFound }
        let representations = (try? ClipboardStore.originalPasteboardItems(from: items[index].payloads)) ?? []
        return .result(value: representations.first?.f_10037c9a8())
    }
}

private enum PastoIndexedItemError: LocalizedError {
    case pinboardNotFound
    case itemNotFound

    var errorDescription: String? {
        switch self {
        case .pinboardNotFound: return "\(AppBrand.name) 分组不存在。"
        case .itemNotFound: return "\(AppBrand.name) 项目不存在。"
        }
    }
}
