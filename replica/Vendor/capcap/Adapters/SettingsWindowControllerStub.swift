// TEMP-STUB (P1-A)
//
// Why this file exists: `Translation/OCRTranslatePanel.swift` calls
// `SettingsWindowController.shared.showAsSettings()` from its "open settings"
// button. `Settings/SettingsWindowController.swift` builds the whole capcap
// settings window (SettingsView + every pane, incl. permissions/updates/trigger
// panes) and is out of the vendoring scope.
//
// Behaviour: `showAsSettings(...)` is a no-op — tapping "open settings" in the
// OCR/translate panel closes the panel and opens nothing.

import AppKit
import Foundation

/// TEMP-STUB (P1-A) — see file header.
class SettingsWindowController: NSWindowController {
    static let shared = SettingsWindowController()

    /// Upstream signature: `showAsSettings(focusingPermissions: Bool? = nil)`.
    func showAsSettings(focusingPermissions: Bool? = nil) {
        _ = focusingPermissions
    }
}
