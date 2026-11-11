import SwiftUI
import SnapclipCore

/// A row releases only the recording interval that it started, even if removal and cancellation overlap.
@MainActor
final class ReplicaShortcutRecordingSession: ObservableObject {
    private(set) var isRecording = false

    func update(_ recording: Bool, notify: (Bool) -> Void) {
        guard isRecording != recording else { return }
        isRecording = recording
        notify(recording)
    }
}

@MainActor
struct ReplicaShortcutRecorder: View {
    @Binding var shortcut: SnapclipCore.KeyboardShortcut?
    let label: String
    let error: (String) -> Void
    let recordingChanged: (Bool) -> Void
    var allowsClearing = true
    @StateObject private var recordingSession = ReplicaShortcutRecordingSession()

    var body: some View {
        OriginalShortcutRecorderView(shortcut: Binding(get: { shortcut?.originalValue }, set: { value in
            shortcut = value.flatMap { SnapclipCore.KeyboardShortcut(originalValue: $0) }
        }), errorChanged: error, recordingChanged: { recording in
            recordingSession.update(recording, notify: recordingChanged)
        }, allowsClearing: allowsClearing, emptyLabel: SettingsCopy.bilingual("未设置", "Not Set"))
        .accessibilityLabel(ScreenshotSettingsCopy.shortcutAccessibilityLabel(for: label))
        .accessibilityValue(shortcut.map {
            OriginalShortcutFunctions.f_1001e9774(verbose: true, modifierRawValue: $0.modifierRawValue)
                + OriginalShortcutFunctions.f_1001e7e50(keyCode: $0.keyCode)
        } ?? SettingsCopy.bilingual("未设置", "Not Set"))
        .onDisappear { recordingSession.update(false, notify: recordingChanged) }
    }
}
