// TEMP-STUB (P1-A)
//
// Why this file exists: vendored capcap code (Editor/EditorShortcutRegistry,
// Capture/OverlayWindowController) references `HotkeyManager`, which lives in
// `Trigger/HotkeyManager.swift` — the whole `Trigger/` directory is explicitly
// excluded from the vendoring scope.
//
// Behaviour: the modifier/key formatting helpers are kept (they are pure
// functions and the editor shortcut display needs a readable string), but every
// global-hotkey accessor reports "no custom hotkey configured", so
// `hotkeyConflictMessage(...)` always returns nil (no conflict) and the
// `eventMatches*` predicates only ever match the hard-coded capcap defaults.
// No Carbon hotkey is ever registered.

import AppKit
import Foundation

/// TEMP-STUB (P1-A) — see file header.
final class HotkeyManager {
    static let shared = HotkeyManager()

    private init() {}

    /// Carbon modifier masks. Duplicated here so the stub does not need to
    /// import Carbon; values are identical to `cmdKey`/`shiftKey`/`optionKey`/`controlKey`.
    private static let carbonCommand: UInt32 = 1 << 8   // 256
    private static let carbonShift: UInt32 = 1 << 9     // 512
    private static let carbonOption: UInt32 = 1 << 11   // 2048
    private static let carbonControl: UInt32 = 1 << 12  // 4096

    /// Carbon virtual key codes used by the capcap defaults.
    private static let keyS: UInt32 = 1
    private static let keyComma: UInt32 = 43
    private static let keyPeriod: UInt32 = 47

    /// Mirrors the upstream slot enum so call sites compile unchanged.
    enum HotkeySlot {
        case screenshot
        case quickPin
        case selectedImagePin
        case clipboardImagePin
        case clipboardTextPin
        case selectedImageEdit
        case clipboardImageEdit
        case textRecognition
        case copyImageText
        case screenshotTranslation
        case record
        case imageMerge
        case finderUpload
        case fullScreenScreenshot
        case colorPicker
        case clipboard
        case fileSave
        case previousHistoryImage
        case nextHistoryImage
        case historyPanel
    }

    // MARK: - Current bindings (always the built-in defaults; nothing is custom)

    func currentClipboardHotkey() -> (keyCode: UInt32, modifiers: UInt32)? {
        nil
    }

    func currentFileSaveHotkey() -> (keyCode: UInt32, modifiers: UInt32) {
        (Self.keyS, Self.carbonCommand)
    }

    func currentPreviousHistoryImageHotkey() -> (keyCode: UInt32, modifiers: UInt32) {
        (Self.keyComma, 0)
    }

    func currentNextHistoryImageHotkey() -> (keyCode: UInt32, modifiers: UInt32) {
        (Self.keyPeriod, 0)
    }

    // MARK: - Conflict detection (never reports a conflict)

    func hotkeyConflictMessage(forKeyCode keyCode: UInt32,
                              modifiers: UInt32,
                              assigningTo slot: HotkeySlot? = nil) -> String? {
        _ = keyCode
        _ = modifiers
        _ = slot
        return nil
    }

    // MARK: - Event matching

    static func eventMatchesClipboardHotkey(_ event: NSEvent) -> Bool {
        _ = event
        return false
    }

    static func eventMatchesFileSaveHotkey(_ event: NSEvent) -> Bool {
        matches(event: event,
                keyCode: shared.currentFileSaveHotkey().keyCode,
                modifiers: shared.currentFileSaveHotkey().modifiers)
    }

    static func eventMatchesPreviousHistoryImageHotkey(_ event: NSEvent) -> Bool {
        matches(event: event,
                keyCode: shared.currentPreviousHistoryImageHotkey().keyCode,
                modifiers: shared.currentPreviousHistoryImageHotkey().modifiers)
    }

    static func eventMatchesNextHistoryImageHotkey(_ event: NSEvent) -> Bool {
        matches(event: event,
                keyCode: shared.currentNextHistoryImageHotkey().keyCode,
                modifiers: shared.currentNextHistoryImageHotkey().modifiers)
    }

    private static func matches(event: NSEvent, keyCode: UInt32, modifiers: UInt32) -> Bool {
        UInt32(event.keyCode) == keyCode
            && carbonModifiers(from: event.modifierFlags) == modifiers
    }

    // MARK: - Formatting helpers (pure, identical to upstream)

    static func carbonModifiers(from flags: NSEvent.ModifierFlags) -> UInt32 {
        let activeMask: NSEvent.ModifierFlags = [.command, .shift, .option, .control]
        let mods = flags.intersection(activeMask)
        var carbonMods: UInt32 = 0
        if mods.contains(.command) { carbonMods |= carbonCommand }
        if mods.contains(.shift) { carbonMods |= carbonShift }
        if mods.contains(.option) { carbonMods |= carbonOption }
        if mods.contains(.control) { carbonMods |= carbonControl }
        return carbonMods
    }

    static func modifierString(_ m: UInt32) -> String {
        var s = ""
        if m & carbonControl != 0 { s += "\u{2303}" }
        if m & carbonOption != 0 { s += "\u{2325}" }
        if m & carbonShift != 0 { s += "\u{21E7}" }
        if m & carbonCommand != 0 { s += "\u{2318}" }
        return s
    }

    static func keyString(_ keyCode: UInt32) -> String {
        switch keyCode {
        case keyS: return "S"
        case keyComma: return ","
        case keyPeriod: return "."
        default: return "Key \(keyCode)"
        }
    }
}
