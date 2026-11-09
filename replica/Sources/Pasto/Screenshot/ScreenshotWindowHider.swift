import AppKit
import os

/// P1-D：截图期间把 Pasto 自己的可见窗口临时移出屏幕（只用 `orderOut(nil)` / `orderFront(nil)`
/// 这一级的窗口操作）。
///
/// 为什么需要：capcap 的 `OverlayWindowController` 在**创建时**就抓 pre-snapshot。遮罩在
/// `.screenSaver` 层不会被面板挡住，但 Pasto 自己的面板会被 ScreenCaptureKit 写进底图。
/// 所以必须在创建遮罩**之前**把面板移出屏幕，截完再原样放回来。
///
/// 为什么不用 `ReplicaUIController.hidePanel()`：那是「关窗」语义 —— 0.2s 下拉动画 +
/// `NSWindowController.close()`，面板状态丢失，用户截完图得重新按热键打开；而且动画中的
/// 面板仍会被拍进底图。`Sources/Pasto/UI/**` 是冻结区，也不该依赖它的动画时序。
///
/// 识别规则只认「肯定属于本 app」的窗口，不做猜测：
/// 1. 类名以 `Replica` / `Original` / `Pasto` 开头：Pasto 自己的窗口子类
///    （`ReplicaPanel` / `ReplicaStackPanel` / `ReplicaEditorWindow` /
///    `ReplicaSearchSuggestionsMenu` …）。
/// 2. `NSPanel` 且 `level == .mainMenu`：主面板的层级特征。
/// 3. 类名恰好是 `NSWindow` / `NSPanel`：App 代码直接构造的普通窗口（设置窗、更新窗、
///    预览窗）。AppKit 内部窗口一律是私有子类（`NSStatusBarWindow` / `NSMenuWindow` /
///    `NSToolTipWindow` …），因此这一条不会误收系统窗口；capcap 的遮罩/编辑器/Toast 是
///    `OverlayPanel` 等自有子类，而且收起发生在它们创建之前。
///
/// 实测（macOS）：`NSPanel` 不设 level 时是 `.normal`（rawValue 0），
/// 所以 `ReplicaStackPanel`（只设了 styleMask，没设 level）**不会**命中规则 2 —— 只靠
/// `level == .mainMenu` 会漏掉它，必须配合规则 1 的类名识别。
///
/// 子窗口（`parentWindow != nil`，例如贴在面板上的搜索结果菜单）不单独处理：`orderOut`
/// 父窗口会连带收起它们，单独 `orderFront` 它们反而可能复活一个已经过期的浮层。
@MainActor
final class ScreenshotWindowHider {
    /// 一次收起留下的现场，`restore()` 时按记录逐条还回去。
    private struct HiddenWindow {
        let window: NSWindow
        /// 收起前是否是 key window。用于把键盘焦点也还回去（见 `restore()`）。
        let wasKey: Bool
        /// 原 delegate。`ReplicaPanel` 把 delegate 设成自己，而它的 `windowDidResignKey`
        /// 会调用 `ReplicaUIController.hidePanel()`（0.2s 动画 + `close()`）——
        /// 若不管，`orderOut` 引起的 resign key 会把「临时移出屏幕」变成「永久关闭」，
        /// 那就再也放不回来了。因此收起期间先摘掉 delegate，窗口真正离屏后再装回。
        let delegate: NSWindowDelegate?
    }

    private static let logger = Logger(subsystem: "com.yingyanzhitong.paste-replica",
                                       category: "screenshot")

    private var hiddenWindows: [HiddenWindow] = []

    // MARK: - 收起

    /// 收起所有可见的 Pasto 窗口并记录现场。
    ///
    /// 可重复调用：已经收起过时保留第一次的记录。万一某次结束回调丢了，记录还在，
    /// 下一次截图结束时仍然能把窗口还回去（不会把面板永久留在屏幕外）。
    func hideVisiblePastoWindows() {
        guard hiddenWindows.isEmpty else { return }
        for window in NSApp.windows {
            guard window.isVisible,
                  window.parent == nil,
                  Self.isPastoOwnedWindow(window)
            else { continue }
            let entry = HiddenWindow(window: window,
                                     wasKey: window.isKeyWindow,
                                     delegate: window.delegate)
            // 先摘 delegate 再 orderOut：见 `HiddenWindow.delegate` 的注释。
            window.delegate = nil
            hiddenWindows.append(entry)
            window.orderOut(nil)
        }
        if !hiddenWindows.isEmpty {
            let names = hiddenWindows
                .map { String(describing: type(of: $0.window)) }
                .joined(separator: ", ")
            Self.logger.debug("截图前收起窗口: \(names, privacy: .public)")
        }
    }

    /// 把收起时摘掉的 delegate 装回去。窗口已经离屏，此时它的 delegate 回调不会再
    /// 因为「离开屏幕」而触发关窗。由调用方在收起之后的下一轮主线程调用。
    func reattachDelegates() {
        reattachDelegates(hiddenWindows)
    }

    // MARK: - 放回

    /// 只恢复「原本可见」的那些窗口（记录里就是全部），重复调用是安全的。
    func restore() {
        guard !hiddenWindows.isEmpty else { return }
        let entries = hiddenWindows
        hiddenWindows.removeAll()
        reattachDelegates(entries)
        for entry in entries {
            guard !entry.window.isVisible else { continue }
            entry.window.orderFront(nil)
            // 原来就是 key window 的话把键盘焦点也还回去；但只在 App 仍然是当前 App 时做，
            // 避免把焦点从用户正在用的其他 App 那里抢回来（焦点归还由
            // `ScreenshotFocusRestorer` 负责）。
            if entry.wasKey, NSApp.isActive, !entry.window.isKeyWindow {
                entry.window.makeKey()
            }
        }
        Self.logger.debug("截图结束，恢复窗口 \(entries.count) 个")
    }

    private func reattachDelegates(_ entries: [HiddenWindow]) {
        for entry in entries where entry.window.delegate == nil {
            entry.window.delegate = entry.delegate
        }
    }

    // MARK: - 识别

    private static func isPastoOwnedWindow(_ window: NSWindow) -> Bool {
        let className = String(describing: type(of: window))
        if className.hasPrefix("Replica")
            || className.hasPrefix("Original")
            || className.hasPrefix("Pasto") {
            return true
        }
        if let panel = window as? NSPanel, panel.level == .mainMenu {
            return true
        }
        return className == "NSWindow" || className == "NSPanel"
    }
}
