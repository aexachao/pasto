import SwiftUI

@MainActor
public struct OriginalShortcutRecorderView: View {
    @StateObject private var model: OriginalShortcutRecorder
    @Binding private var shortcut: OriginalShortcutValue?
    private let errorChanged: (String) -> Void
    private let recordingChanged: (Bool) -> Void
    private let allowsClearing: Bool
    private let emptyLabel: String?

    public init(shortcut: Binding<OriginalShortcutValue?>,
                errorChanged: @escaping (String) -> Void = { _ in },
                recordingChanged: @escaping (Bool) -> Void = { _ in },
                allowsClearing: Bool = true,
                emptyLabel: String? = nil) {
        _shortcut = shortcut
        // StateObject's autoclosure preserves the reference factory's lazy
        // binding read and the model's identity across parent view updates.
        _model = StateObject(wrappedValue: Self.f_1001eca94(shortcut, allowsClearing: allowsClearing))
        self.errorChanged = errorChanged
        self.recordingChanged = recordingChanged
        self.allowsClearing = allowsClearing
        self.emptyLabel = emptyLabel
    }

    public static func f_1001eca94(_ shortcut: Binding<OriginalShortcutValue?>,
                                  allowsClearing: Bool = true) -> OriginalShortcutRecorder {
        OriginalShortcutRecorder(shortcut: shortcut.wrappedValue, allowsClearing: allowsClearing) { value in
            shortcut.wrappedValue = value
        }
    }

    public func f_1001ee308() -> some View {
        let model = self.model
        return Button(OriginalShortcutMessages.value("general.action.ok")) { model.f_1001ee478() }
    }

    public func f_1001ecbc4() -> some View {
        let model = self.model
        let presentation = !model.state.isRecording && shortcut == nil && emptyLabel != nil
            ? (emptyLabel!, nil as String?, false) : model.f_1001f02d8()
        let controls = OriginalShortcutControls(presentation: presentation, state: model.f_1001f0460(),
            begin: { model.f_1001ef2bc() }, clear: { model.f_1001ef434() },
            allowsClearing: allowsClearing)
        let content = ZStack(alignment: .topTrailing) { controls.f_1001ed1c4() }
            .id(model.state)
            .onChange(of: shortcut, initial: false) { _, updated in
                // External resets must also remove a monitor owned by an in-progress recording.
                model.f_1001f1150(newState: updated.map(OriginalShortcutRecorderState.assigned) ?? .unassigned)
            }
        let title = Text(model.f_1001f04e8()?.localizedDescription ?? "")
        let isPresented = model.f_1001f04e8() != nil
        return content.alert(title, isPresented: .constant(isPresented)) { f_1001ee308() }
    }

    public var body: some View {
        f_1001ecbc4()
            .onChange(of: model.state.isRecording, initial: false) { _, value in recordingChanged(value) }
            .onChange(of: model.state, initial: false) { _, state in
                // An application binding may reject a conflicting assignment.
                // Keep the label consistent with the preference it actually kept.
                if case let .assigned(detected) = state, shortcut != detected {
                    model.f_1001ee19c(shortcut)
                }
            }
            .onReceive(model.$validationError) { value in errorChanged(value?.localizedDescription ?? "") }
            .onDisappear {
                if model.state.isRecording { model.f_1001eff84() }
            }
    }
}
