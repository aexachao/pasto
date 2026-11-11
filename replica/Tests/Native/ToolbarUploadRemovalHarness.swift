import AppKit

@main struct ToolbarUploadRemovalHarness {
    static func main() {
        var checks = 0
        func check(_ condition: @autoclosure () -> Bool, _ message: String) {
            precondition(condition(), message)
            checks += 1
        }
        let supported = ToolbarLayout.canonicalOrder
        check(!supported.contains(.upload), "upload is not an offered editor action")
        check(ToolbarItemID(rawValue: "upload") == .upload, "old persisted raw value still decodes")
        check(Set(supported).count == supported.count, "canonical supported actions remain unique")
        check(Set(supported) == Set(ToolbarItemID.allCases.filter { $0 != .upload }), "all other tools remain available")

        func verify(_ layout: ToolbarLayout) {
            let combined = layout.primary + layout.side + layout.hidden
            check(!combined.contains(.upload), "upload is absent from every normalized bucket")
            check(combined.count == supported.count, "no missing or duplicate supported tool")
            check(Set(combined) == Set(supported), "supported tool inventory is preserved")
            check(layout.normalized() == layout, "normalization is stable")
            check(ToolbarLayout(dictionary: layout.dictionary).normalized() == layout, "persisted round trip is stable")
        }
        verify(.default)
        check(ToolbarLayout.default.side == [.scrollCapture, .save, .pin, .record, .close, .confirm], "default output toolbar has no empty upload slot")
        for bucket in ["primary", "side", "hidden"] {
            var old = ToolbarLayout.default.dictionary
            old[bucket, default: []].insert("upload", at: 0)
            let normalized = ToolbarLayout(dictionary: old).normalized()
            verify(normalized)
            check(normalized == .default, "old upload placement is removed without rearranging other tools")
        }
        let customized = ToolbarLayout(primary: [.save, .rectangle], side: [.pin, .confirm], hidden: [.text]).normalized()
        var legacy = customized.dictionary
        legacy["primary", default: []].insert(contentsOf: ["upload", "unknown-tool", "upload"], at: 1)
        legacy["side", default: []].insert(contentsOf: ["upload", "save"], at: 0)
        legacy["hidden", default: []].append(contentsOf: ["upload", "text"])
        let migrated = ToolbarLayout(dictionary: legacy).normalized()
        verify(migrated)
        check(migrated == customized, "migration preserves user placement and strips stale upload/unknown/duplicate values")
        verify(ToolbarLayout(primary: [.upload], side: [.upload], hidden: [.upload]).normalized())
        verify(ToolbarLayout(primary: [], side: [], hidden: []).normalized())
        print("{\"passed\":true,\"checks\":\(checks),\"boundary\":\"Actual production ToolbarLayout with presentation dependency stubs; persisted layout migration and supported-action inventory. No network, user defaults, or editor UI interaction.\"}")
    }
}
