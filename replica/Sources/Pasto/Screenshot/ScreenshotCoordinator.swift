import AppKit
import os
import PastoCore
import PastoCapture

/// P1-B：把 capcap 的「采集 → 编辑器 → 落库」接到 Pasto 的既有设施上。
///
/// - 热键走 Pasto 既有的 `GlobalHotKey`（Carbon `RegisterEventHotKey`），
///   **不启用** capcap 的 `KeyMonitor`（`Trigger/` 未 vendored，双 tap 会吞键）。
/// - 采集/编辑器入口走 `CaptureEntry`（PastoCapture 内的薄公共门面），
///   因为 PastoCapture 的类型全部是 internal，跨 module 不可见。
/// - 编辑器产出的 `NSImage` 用 `ClipboardStore.add` 入历史，再用
///   `ClipboardStore.writeToPasteboard` 写剪贴板，用户可直接 ⌘V。
///
/// P1-C：
/// - 启动时把 capcap 的 `HistoryManager` 接到 `ClipboardStore`（`ScreenshotHistoryBridge`），
///   编辑器里的「上一张/下一张」（默认 , 和 .）才能取到真实图片。
/// - 编辑器双击遮罩会把草稿交回来（`onSuspend`），下一次触发优先恢复该草稿，
///   对应上游 `AppDelegate.resumeSuspendedEditIfAvailable()`。
@MainActor
final class ScreenshotCoordinator {
    /// 区域截图：⌘⇧A（kVK_ANSI_A = 0x00）
    private static let regionKeyCode: UInt32 = 0x00
    /// 全屏截图：⌘⇧E（kVK_ANSI_E = 0x0E）
    private static let fullScreenKeyCode: UInt32 = 0x0E
    private static let shortcutModifiers: NSEvent.ModifierFlags = [.command, .shift]
    /// Carbon 热键标识符。`GlobalHotKey` 当前忽略该参数，仅作语义区分。
    private static let regionIdentifier: UInt32 = 101
    private static let fullScreenIdentifier: UInt32 = 102

    /// 落库失败必须有痕迹。subsystem/category 与 Pasto 其他诊断日志一致。
    private static let logger = Logger(subsystem: "com.yingyanzhitong.paste-replica",
                                       category: "screenshot")

    /// 一次「双击遮罩挂起」留下的现场。
    private struct SuspendedCapture {
        let draft: SuspendedEditDraftBox
        /// 触发原草稿的那次前台 App；恢复时沿用，避免把来源记成恢复那一刻的前台 App。
        let sourceApplication: SourceApplicationRecord?
    }

    private let store: ClipboardStore
    private let pasteboard: NSPasteboard
    private let regionHotKey = GlobalHotKey()
    private let fullScreenHotKey = GlobalHotKey()
    /// 编辑器/遮罩强引用；capcap 的 `OverlayWindowController` 不被窗口自持。
    private var overlayController: AnyObject?
    /// 触发瞬间的前台 App；编辑器跑起来之后前台就变成 Pasto 自己了。
    private var pendingSourceApplication: SourceApplicationRecord?
    /// capcap 挂起中的编辑草稿。最多一份：上游 `AppDelegate` 同样只留最后一个。
    private var suspendedCapture: SuspendedCapture?
    private var isStarted = false
    /// 面板收起等待期间的重入守卫：这段时间 `overlayController` 还是 nil，
    /// 光靠它挡不住第二次热键，会把「收面板」流程叠两遍。
    private var isPresenting = false
    /// 截图期间被临时移出屏幕的 Pasto 窗口（P1-D）。记录「哪些原本可见」，
    /// 在保存/取消/挂起/失败四个出口处原样还回去。
    private let windowHider = ScreenshotWindowHider()
    /// P1-C 审计 M2：`HistoryManager.configure` 与 `isStarted` 解耦。
    /// `--no-global-hotkey` 会在注册热键前早退，`isStarted` 保持 false，
    /// 若只靠它做幂等，重复 `start()` 会再 configure 一次（后端被覆盖）。
    private var didConfigureHistory = false

    init(store: ClipboardStore, pasteboard: NSPasteboard = .general) {
        self.store = store
        self.pasteboard = pasteboard
    }

    // MARK: - 生命周期

    func start() {
        guard !isStarted else { return }
        // capcap 的 `HistoryManager` 只在这里接一次存储；没走到这里时它保持空实现。
        // 幂等：下面的 guard 早退时 `isStarted` 仍是 false，重复 start() 不能重新 configure。
        if !didConfigureHistory {
            didConfigureHistory = true
            HistoryManager.configure(backend: ScreenshotHistoryBridge(store: store))
        }
        // 与既有全局快捷键保持同一开关：`--no-global-hotkey` 时不注册。
        guard !ProcessInfo.processInfo.arguments.contains("--no-global-hotkey") else { return }
        regionHotKey.action = { [weak self] in self?.startRegionCapture() }
        fullScreenHotKey.action = { [weak self] in self?.startFullScreenCapture() }
        _ = regionHotKey.register(keyCode: Self.regionKeyCode,
                                  modifiers: Self.shortcutModifiers,
                                  identifier: Self.regionIdentifier)
        _ = fullScreenHotKey.register(keyCode: Self.fullScreenKeyCode,
                                      modifiers: Self.shortcutModifiers,
                                      identifier: Self.fullScreenIdentifier)
        isStarted = true
    }

    func stop() {
        regionHotKey.unregister()
        fullScreenHotKey.unregister()
        regionHotKey.action = nil
        fullScreenHotKey.action = nil
        overlayController = nil
        isStarted = false
        // 退出时（`applicationWillTerminate`）若还有一次截图没走完，窗口不能留在屏幕外。
        windowHider.restore()
        // `suspendedCapture` 不清：退出热键注册不等于用户放弃草稿，重新 start 后仍可恢复。
    }

    // MARK: - 两个入口

    func startRegionCapture() {
        present(isRegion: true)
    }

    func startFullScreenCapture() {
        present(isRegion: false)
    }

    private func present(isRegion: Bool) {
        // 遮罩/编辑器已在前台、或上一轮「收面板 + 采集」还没落地时忽略重复触发
        // （对应 capcap 的 overlayController == nil 守卫；isPresenting 覆盖等待面板关闭的窗口期）。
        guard overlayController == nil, !isPresenting else { return }
        let focusRestorer = ScreenshotFocusRestorer.captureFrontmost()
        let onFocusReturn = { focusRestorer.restore() }
        let onSuspend: (SuspendedEditDraftBox) -> Void = { [weak self] draft in self?.suspend(draft) }
        let onComplete: (NSImage?) -> Void = { [weak self] image in self?.complete(image) }

        // 挂起的草稿优先恢复：不再重新抓屏，也不覆盖来源 App。
        if let suspended = suspendedCapture {
            if let controller = CaptureEntry.resumeSuspendedEditor(draft: suspended.draft,
                                                                  onFocusReturn: onFocusReturn,
                                                                  onSuspend: onSuspend,
                                                                  onComplete: onComplete) {
                suspendedCapture = nil
                pendingSourceApplication = suspended.sourceApplication
                overlayController = controller
                return
            }
            // 草稿恢复不了（例如那块显示器已经拔掉）：丢弃它，按普通触发继续抓新图，
            // 否则这个热键会被一份永远失败的草稿永久堵住。
            suspendedCapture = nil
        }

        let frontmost = NSWorkspace.shared.frontmostApplication
        pendingSourceApplication = frontmost?.processIdentifier == ProcessInfo.processInfo.processIdentifier
            ? nil : frontmost.flatMap(OriginalSourceApplication.snapshot)
        // 门禁第 8 条（P1-D 版）：**创建遮罩之前**先把 Pasto 自己的窗口移出屏幕。
        // capcap 的 `OverlayWindowController` 在 init 时就抓 pre-snapshot，晚一步面板就进底图了。
        // `orderOut` 同步生效；再让出一轮主线程，确保窗口服务器已经把它撤下再开始抓屏。
        // 面板不可见时这里什么都没收，`restore()` 也自然是空操作。
        isPresenting = true
        windowHider.hideVisiblePastoWindows()
        DispatchQueue.main.async { [weak self] in
            MainActor.assumeIsolated {
                self?.beginCapture(isRegion: isRegion,
                                   onFocusReturn: onFocusReturn,
                                   onSuspend: onSuspend,
                                   onComplete: onComplete)
            }
        }
    }

    /// 遮罩已经在上一轮主线程里创建好（面板此时已离屏）。所有失败出口都在这里收口。
    private func beginCapture(isRegion: Bool,
                              onFocusReturn: @escaping () -> Void,
                              onSuspend: @escaping (SuspendedEditDraftBox) -> Void,
                              onComplete: @escaping (NSImage?) -> Void) {
        // 等待期间 stop() 被调用（热键重配置 / App 退出）：不再拉起遮罩，并把窗口还回去。
        guard isStarted else {
            isPresenting = false
            windowHider.restore()
            return
        }
        let controller: AnyObject?
        if isRegion {
            controller = CaptureEntry.presentRegionEditor(onFocusReturn: onFocusReturn,
                                                          onSuspend: onSuspend,
                                                          onComplete: onComplete)
        } else {
            controller = CaptureEntry.presentFullScreenEditor(onFocusReturn: onFocusReturn,
                                                              onSuspend: onSuspend,
                                                              onComplete: onComplete)
        }
        isPresenting = false
        // 窗口已经离屏，把收起时摘掉的 delegate 装回（见 `ScreenshotWindowHider`）。
        windowHider.reattachDelegates()
        guard let controller else {
            // 抓屏失败（多为「屏幕录制」未授权）：不产生任何条目，窗口还回去。
            windowHider.restore()
            NSSound.beep()
            return
        }
        overlayController = controller
    }

    /// capcap 双击遮罩挂起编辑器时回调：遮罩和编辑器已经被它自己拆掉，
    /// 这里只收下草稿并放开热键守卫，下一次触发走恢复分支。
    private func suspend(_ draft: SuspendedEditDraftBox) {
        // 遮罩和编辑器已经被 capcap 自己拆掉，窗口可以还回去了。
        windowHider.restore()
        overlayController = nil
        suspendedCapture = SuspendedCapture(draft: draft, sourceApplication: pendingSourceApplication)
        pendingSourceApplication = nil
    }

    // MARK: - 落库

    private func complete(_ image: NSImage?) {
        // 保存/取消都会走到这里：先把截图前收起的窗口还回去，再处理落库
        // （落库可能失败，不能让失败把面板留在屏幕外）。
        windowHider.restore()
        overlayController = nil
        let sourceApplication = pendingSourceApplication
        pendingSourceApplication = nil
        // 取消（Esc / 放弃编辑）不产生任何条目。
        guard let image, let data = PastoImageEncoding.pngData(from: image) else { return }
        let item = ClipboardItem(kind: .image, plainText: nil, sourceName: "Pasto",
                                 payloads: ["public.png": data])
        // 主保存路径唯一没有诊断痕迹的失败点：拆两个阶段，catch 里能说清断在哪一步。
        var stage = "store-add"
        do {
            let id = try store.add(item, sourceApplication: sourceApplication)
            stage = "pasteboard-write"
            // 复用 Pasto 自己的写剪贴板路径：它会同步 capture state 的 changeCount，
            // 避免 ClipboardMonitor 把这次写入当成新的拷贝再收一条。
            try store.writeToPasteboard(ids: [id], pasteboard: pasteboard, plainTextOnly: false)
        } catch {
            Self.logger.error("screenshot save failed kind=\(stage, privacy: .public) error=\(error.localizedDescription, privacy: .public)")
            NSSound.beep()
        }
    }
}
