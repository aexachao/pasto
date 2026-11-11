# 设置、截图与保留期限验证 · 2026-11-11

当前维护仓库为 https://github.com/aexachao/Snapclip，源码版本 1.0.10。帮助与更新源已迁至自己的仓库。本仓库尚无正式安装包，Pages 尚未启用，不将上游 1.0.8 称为本项目下载。main / 标签推送只做发布契约检查，正式发布需配置签名后手动 publish=true。以下旧下载、PID 和验收结果保留为历史，不替代本轮验证；本轮安装已完成：snapclip-1-0-10-native-47618-20261111-223149/out/install-result.json；392 输入、192 文件、版本1.0.10、稳定开发签名与原 DR、备份恢复、新 PID48634 / 12秒启动通过。独立实际部署20项通过：settings-toolbar-repository-independent-49265-20261111-224842/out/deployment-audit.json。官网52链接 / i18n19项163键、未发布下载9项、打包9项、更新源9项及实际发布开关4分支通过；原生更新源测试另列。真实权限、SCK像素、实体听感与旧系统不由安装审计代替。

## 当前追加：截图工具浮层排除与 Purr 提示音

用户最终选用 macOS 自带 Purr，由 `NSSound(named:)` 运行时加载；不复制系统音频、不声称 Apple 将它规定为统一成功音。`macos-purr-feedback-42003-20261111-220046/out/result.json` 的静音定向 13 项通过，命名加载、成功事件、开关与拆订阅边界保持，没有实际播放；此前 Glass 和 75ms 合成音记录属于历史。

本轮区域 / 窗口选择的初始屏幕快照修复了工具自身放大镜 / 取色提示面板混入底图的问题：`OverlayWindowController` 在请求快照前预建但不显示 lens / chip，把它们的实际窗口 ID 加入选区窗口排除集，后续显示复用同一实例。排除针对具体工具窗口，不隐藏整个 App、不排除正常设置窗口；生产 `ScreenSnapshotProvider` 的 required-ID 完整性校验与失败关闭保持。全屏独立路径本轮未改。

`capture-chrome-exclusion-final-42543-20261111-220204/out/result.json` 的原生定向 183 项通过：真实控制器和 NSWindow ID、显式排除重载、各模式取消 / 重试与浮层实例复用；通过拦截窗口显示及注入快照 provider 避免干扰桌面，不等同于真实 ScreenCaptureKit 像素抓取、用户截图或权限验证。不沿用下节 Glass 包的通过数字。

本轮联合安装实施自验已通过：`capture-purr-native-43295-20261111-220502/out/install-result.json`，1.0.9、392 项输入前后及安装前一致，源 / 安装 192 条清单一致、Core 8 文件，严格 Apple Development / 原 DR 及只读 probe 通过。实际旧 PID40199 正常退出，新 PID43722 于本地 22:06:26 从 `/Applications/Snapclip.app/Contents/MacOS/Snapclip` 启动并观察 12 秒，旧包 ZIP 实际解压核验，无回滚。build / bootstrap / stage 已清，无新设备，交付37M；全新独立部署审计 `capture-purr-deployment-independent-43902-20261111-220851/out/audit-final.json` 的 26 项通过：实际 / 源包 / 记录192项、当前392输入、正常系统信任 strict 与原 DR、独立解压备份、Core8文件 / 图标 / 许可 / MCP alias、唯一新 PID43722 及旧 PID40199 退出和清理均核实；主控也实际复算392 / 192并核对严格签名与进程路径。仍未执行真实 SCK 像素抓取、实体试听或 TCC / 用户库验收。


## 此前追加：macOS Glass 成功提示音

此前用户要求成功反馈使用 macOS 自带音效，当时选择 Glass，由 `NSSound(named:)` 运行时加载；不复制系统音频到仓库或安装包，不声称 Apple 将其规定为统一成功音。成功事件订阅、声音开关、失败无声与停止拆订阅边界保持；实体听感仍待用户确认。`macos-glass-feedback-38011-20261111-213053/out/result.json` 的本轮静音定向测试 13 项通过，验证系统 Glass 名称解析、持有与停止、成功事件各一次及声音开关；没有实际播放。`macos-glass-native-38475-20261111-213313/out/install-result.json` 已通过：1.0.9、392 个产品输入一致，源 / 安装 192 项清单相同，严格 Apple Development / 同 DR；旧 PID36628 正常退出，新 PID39311 于本地 21:34:57 从安装路径启动并观察 12 秒。旧包 ZIP 实际解压及签名验证通过，无回滚。build / stage 已清，无新设备，交付37M、Data201GiB。全新独立审计 `glass-final-deployment-independent-final-39452-20261111-213632/out/audit-final.json` 的32项通过，另独立静音13项通过；实际安装 / 源包 / 记录192项、当前392输入、正常系统信任strict / 同DR、旧包独立解压 / 验签、Core8文件且无音频资源、唯一新PID与清理均核实。首个审计脚本误读DR输出及图标路径失败保留，最后新guard的32项才计通过；不沿用下节 75ms 合成音或旧包的通过数字。


## 此前追加修复：截图快捷键、短提示音与新生成素材

区域 / 全屏截图快捷键现与其他四个录制器统一，均有右侧 ×；点击后真正注销对应绑定，视觉及辅助功能均显示“未设置”，重启保持该状态，菜单截图入口保留。旧配置的 enabled 标志缺省为 true；重新录入原组合、单项恢复或恢复全部都会重新启用。仅非默认选项显示左侧“恢复默认”。真实 Carbon 由隔离 stub 边界验证，不冒称实体全局按键通过。

`/Users/chrisli/dev-artifacts/pasto/screenshot-shortcut-final-30849-20261111-205053/out/`：capture 82 项、中英 settings 各 198 项、row 182 项与全局 reset 通过，包含真实 AX 两截图 × → 持久 nil / 精确 Not Set / 单项恢复。最初并行编译输入变化、NSSound SDK 参数错误、测试表达式类型检查与 AXValue 读取遗漏均保留失败日志；最终只采用冻结产品后的通过结果，未削弱精确状态断言。截图 / 声音独立源码及证据复核通过。

此前提示音改为 `OriginalSoundEffects` 内数学合成的 75ms 单包络短音，NSSound 被持有，无资源文件、系统 Pop 或时间节流。旧 Pop 的 1.627 秒音频中有多个明显声段，只支持重复听感的解释，不证明发生两次 play。`feedback-single-envelope-final-30662-20261111-204953/out/` 单音 16 项与快捷键 41 项通过；`feedback-real-private-chain-30769-20261111-205043/out/result.json` 实际 private pasteboard 链验证截图一次 restore / 零 capture 回声、连续两次不同外部复制各一次 copy、写入失败零声。没有播放试听文件或操作真实系统剪贴板，实体听感仍待用户确认。

主图标与直接粘贴 / 复制到剪贴板 / 权限三张插图按用户确认使用当前内置 `image_gen.imagegen` 生成，源、提示词、源包和 SHA 记录见 `branding/SnapclipGeneratedAssets/`；模型 ID 未公开，不称使用 gpt-image-2.5。20pt 类别图保持独立几何绘制，中英文独立表与其他语言回退英文保持。接入自验 `generated-resources-native-34365-20261111-210858/out/` 五语言总 1998 项与白名单 / 资源 / fallback 29 项通过。资产独审 `generated-assets-independent-audit-35413-20261111-211348/out/audit-final.json` 的 23 项通过，含当前 10 个产品哈希、ICNS / PNG 像素、网站一致、透明图和白名单拒绝项；不代替最终安装验收。Core bundle 实际为 Info.plist、中英四表和三张指定新 PNG 共 8 文件；源、包内容、安装与实机听感分别记录。旧素材和旧品牌源仅作历史溯源，不重新授予第三方权利。


本轮最终安装已完成：`/Users/chrisli/dev-artifacts/pasto/clear-audio-generated-verified-install-36456-20261111-211820/out/install-result.json` passed，1.0.9，392 项产品输入与构建前后 / 安装前全等，源 / 实际安装 192 条 manifest 相同，Core 8 文件；Apple Development 稳定签名、原 Bundle ID / 同 DR、capcap / Sparkle 许可、主图标 / 网站 PNG、三张生成插图与 MCP alias 均一致。旧包 ZIP 实际恢复验过，旧 PID27677 正常退出，新 PID36628 于 21:18:46 从 `/Applications/Snapclip.app/Contents/MacOS/Snapclip` 启动并观察 12 秒，无回滚、用户库或 TCC 手工修改。初构建 guard 成功产出签名包，但交付 wrapper 引用旧 bootstrap 在安装前失败；`artifact-origin.json` 如实记录，第二受管任务重验完全相同签名包后安装，未声称初任务全绿。全新独立部署审计 `clear-generated-deployment-independent-36745-20261111-212013/out/audit-final.json` 的 37 项通过，包含实际 / 源 / fresh build 三者、当前 392 输入、独立解压旧包、正常系统信任 strict 验签与唯一新进程。build / stage 已清，无新设备；构建 28M + 安装 37M 共65M，Data 可用201GiB。实体听感、真实按键 / TCC、用户历史与商店验收仍未验。

文档检查 `shortcut-sound-generated-docs-35324-20261111-211244/out/` guard0：官网52链接 / 资源、i18n19项 / 163 keys、JS语法、下载8项与打包9项合同通过；未改正式1.0.8链接或原版权。此前节的安装数字和平台额度限制属于其历史时点，不套用到本轮。

## 此前品牌迁移 · 2026-11-11（20:28 本机 arm64 已安装）

产品名统一为闪贴 / Snapclip。A1/A2/A5 独立几何源稿、A3/A4 自写中英表已审，用户选择其余界面语言回退英文；自有资源已接入源码，guard16838 的 Foundation 1980 项与 17 项白名单静态验证通过；工程命名实际迁移已完成，新 Package / 独立模块 / 产品 / 源码目录为 Snapclip 系列，主 Pasto 模块和 Intent 类型保留兼容；新模块对旧库副本读取、保存、重开及 65 对象 / 11 实体 post-save 独立审计已通过，最终本机 arm64 品牌包 manifest / 安装已通过实施自验与主控直接复核，非全新部署独审。来源、许可、完整替换项及兼容保留见 [品牌清单](../docs/BRAND_ASSET_REPLACEMENTS.md)。

完整 Core suite 在旧 / 新工程均遇 SQLite `RAISE ABORT` 触发 CoreData fatal（exit 133），未通过，不能以定向测试代替全组结果。MCP create_item UTF-8 payload 单行修复后的 13 组独立复核通过；系统发现、真实快捷指令运行及既有快捷指令迁移仍未验。当前 canonical 路径为 `replica/Sources/Snapclip*`，主可执行文件 `Snapclip`，CLI `snapclip-mcp`（保留 `pasto-mcp` alias），资源 bundle `Snapclip_SnapclipCore.bundle`；BID / archive / cloud / prefs / helper物理服务路径保留兼容。

文档当前检查：`/Users/chrisli/dev-artifacts/pasto/snapclip-brand-docs-final-25952-20261111-201654/out/` guard exit 0，官网 52 链接 / 资源、i18n 19 项 / 159 keys、JS 语法、下载同步 7 项、打包契约 8 项通过；build 已清，24K，Data 可用 203GiB，无设备。下载仍为实际正式版 1.0.8。该检查不构成品牌包安装验收。

权限 probe 可执行名窄修仅精确允许 `Snapclip` / `Pasto` 与原 Bundle ID，保留路径 / 签名哈希校验，中英各 74 项通过（`snapclip-probe-executable-compat-26727-20261111-202050/out/`）；最终第二轮构建已纳入并完成实际安装；第一轮包因旧 probe 名明确拒绝安装。平台 agent thread limit 阻止创建全新最终部署审计 worker，最终部署将由主控自查；不得标为全新独立部署审计完成。

最终品牌安装：`/Users/chrisli/dev-artifacts/pasto/snapclip-final-brand-native-25684-20261111-201610/out/install-result.json` passed。389 输入构建前后 / 安装前一致；主控实际复算当前输入等 source-after，189 条源 / 安装 manifest 完全一致，Core 仅 Info.plist 与 en / zh-hans 四表，旧资源及研究目录不随包，完整 capcap/Sparkle 告知与图标字节一致，MCP alias 字节相同。1.0.9、原 Bundle ID、Apple Development / Team 4NJM425J3B、严格签名及同 DR；旧 ZIP 恢复核验通过，旧 PID 15377 退出，新 PID 27677 于 20:28:02 从 `/Applications/Snapclip.app/Contents/MacOS/Snapclip` 启动，12 秒观察通过。主控另外在正常系统 trust 环境复跑 deep strict codesign 0 与 ps 路径。无回滚、手工用户 Store / TCC 改动或设备，build / stage 已清。交付目录 69M、Data 可用 203GiB。

最终隔离验证：fresh 中英 settings 各 182、row 182 / 全局 reset，五语言选择自有资源 1980+17 通过。平台限制无法新建最终部署审计 worker，故本次最终安装只有实施自验与主控直接复核；不冒称 fresh 独审。物理界面、实体听感、真实授权变化 / Carbon、用户历史清理、旧已保存快捷指令、真实 SMAppService 连续性及 Intel / 旧系统仍未验。完整 Core suite 的旧 / 新 SQLite RAISE ABORT fatal 133 未通过，定向 MCP / 旧库审计不代替它。未构建新的 Universal 正式发布、未提交 / 发布；稳定下载保持 1.0.8。

此前功能波最终安装为 `/Users/chrisli/dev-artifacts/pasto/toolbar-rows-feedback-native-install-13728-20261111-190753/out/`：1.0.9，381→383 输入、249 条源 / 安装清单及 PID 15377；独立 `functional-wave-postdeploy-audit-15514-20261111-191144/out/` 与 `functional-wave-final-set-audit-15624-20261111-191234/out/` 通过。主控 `settings-feedback-root-final-11359-20261111-185950/out/` 覆盖六 UI 进程各 182 项、单行恢复 182 项、全局 reset、feedback 三轮各 41+6 以及真实 private writeguard（成功单声、失败零声、poll零声）。以上都是功能波证据，**不包含最终品牌资源包的构建 / 安装验收**；物理窗口、真实全局快捷键 / TCC / 用户历史 / Intel / 旧系统边界仍保留。稳定下载继续为 1.0.8，未提交或发布。


## 当前：确认框可读性、截图窗口保留与快捷键统一恢复

本轮移除系统 NSAlert 按钮的 destructive 标记，使用普通系统 label，保留 warning 样式与安全取消；不宣称完整 HIG 合规。截图 hider 先要求 `NSPanel`，再匹配 identifier `paste-replica-panel` 或精确类名 `ReplicaStackPanel`；设置、关于、普通 editor 及 attached sheet 保留。快捷键页顶部统一“恢复全部快捷键…”，移除两行截图 local restore 与页底 reset；范围为四项应用、双截图及快捷粘贴 / 纯文本 modifier。生产事务先保存再提交双截图槽，单次通知 / 注册回调；失败回原值且就地报错，取消零写，成功 generation 刷新六个 recorder。共用 NSAlert factory / present，Return / Enter / Esc 安全取消，monitor 仅当前窗口，完成清理。六组共享 44pt 不透明标题区、内容 clip、移除双 top ignoreSafeArea，settings 透明 titlebar=false。

- **确认框与截图：** `alert-button-legibility-85711-20261111-173154/out/` 中英各 72 项，主控 `alert-button-root-repeat-86953-20261111-173624/out/` 六进程各 72 项通过；`capture-settings-visible-85343-20261111-173106/out/` hider 14/14，早期集成 63/63 与主控 hider 三轮通过；最终主控 `capture-integration-root-repeat-89192-20261111-174426/out/` 重复调用的后轮断言失败已定位为测试目录复用：脚本固定 `build/store`，复用了首轮 PNG / text / color 三条记录，仍硬编码期望 count=1。`capture-integration-final-root-92528-20261111-175220/out/repeat-2.log` 显示前后 count=3、图片 ID 与 SHA 一致；89192 / 92528 首轮各 63 项通过。仅修测试隔离为每次调用独立 Store 并加初始空断言，保留 duplicate 原断言，产品未改。最终 `capture-isolated-final-root-94102-20261111-175544/out/` 三轮各 64 项、前后 count=1、guard exit 0；独立审计确认原断言未弱化，复用 fixture 原因闭合。以上目录均在 `/Users/chrisli/dev-artifacts/pasto/`。
- **标题与恢复：** `settings-shortcuts-header-87804-20261111-173836/out/run-1/` 中英各 31 项及四张联系图通过；`settings-shortcuts-header-88904-20261111-174331/out/` 为最终恢复专项证据。生产 sheet 重复验证、真实隔离 Store 读回、失败回滚与双槽单 notify / callback 通过。全新独立审计直接检查源码及八张图通过；主控 `settings-shortcuts-header-root-repeat-89363-20261111-174454/out/` 六个 UI 进程各 31 项、真实确认键与事务 helper 重复验证通过，guard exit 0 且 build 已清。
- **当前包状态：** `alert-capture-native-install-91146-20261111-174818/out/install-result.json` 已 passed：381 产品输入构建前后 / 安装前一致，源 / 安装 249 条文件、模式、符号链接与哈希一致，旧包备份已验证。1.0.9、原 Bundle ID、Apple Development / Team 4NJM425J3B 稳定签名、strict / 同 DR；旧 PID 78872 正常退出，新 PID 95232 于本地 17:58:10 从 `/Applications/Snapclip.app` 启动并观察 12 秒，无回滚、未手工修改用户 Store / TCC、无新增设备。独立实际部署审计 `alert-capture-postdeploy-audit-95497-20261111-175921/out/postdeploy-audit.json` 通过，直接核对 381 当前 / 构建输入、249 源 / 安装清单、旧 ZIP 独立还原并对照前包 76528、正常系统信任 strict / DR、唯一 PID 95232 路径与旧 PID 78872 退出。安装 guard exit 0，build / bootstrap / stage 均不存在、devices 为空；正式下载仍为 1.0.8，不提交或发布。
- **文档检查：** `settings-capture-docs-91199-20261111-174831/out/` 官网 52 链接 / 资源、i18n 19 项与 158 keys、下载同步 7 测试及打包契约 8 测试均通过，guard exit 0；最终七文件哈希与小范围一致性复核另存本轮受管收尾目录。
- **验收边界：** 全部视觉为隔离原生离屏结果，不是用户物理屏幕或真实 Carbon 注册；reset 保存失败用 save 前 throw 注入，parent-close / modal 备用路径未直接实测。真实用户历史清理、TCC 与 Intel / 旧系统仍未验。此前保留性能的约 255ms 同步边界继续有效。

## 此前：保留期限反馈修正、性能边界与本机安装

用户完整截图证明旧自定义 NSWindow 确认框存在；问题为大面积留白与比例失衡，纠正此前“没有可见确认框”的判断。本轮已改为系统 NSAlert；七项 1 / 3 / 7 / 15 / 30 / 60 天及永久、无自定义、旧值保护、缩短确认 / 取消零保存及失败保护保持。移除可见对勾，保留 accent 与 AX selected；说明与 divider 间距约 15pt。同值选择不再 layout invalidate，保留期变更不触发无关全窗口外观重设。CoreGraph 只增加 identity 查找索引（8 增 1 删），保存 / expiry 语义不改。

- **UI 验证：** 主控六个独立进程各 66 项通过（`/Users/chrisli/dev-artifacts/pasto/retention-response-ui-repeat-70535-20261111-153428/out/`）；appearance 三轮各 22 项通过（`/Users/chrisli/dev-artifacts/pasto/retention-response-appearance-repeat-71847-20261111-153923/out/`）；实际父 settings 中英各 13 项及离屏截图通过（`/Users/chrisli/dev-artifacts/pasto/retention-response-settings-parent-73367-20261111-154906/out/`）。这些是隔离 native / 离屏验证，不是物理用户操作。
- **性能验证：** 最终 `/Users/chrisli/dev-artifacts/pasto/retention-save-root-final-75165-20261111-160022/out/` baseline / indexed 各 19 项通过，最终独立性能审计通过。Release -O、合成 1024 条与 8MiB 数据，journal 开启 513.617→254.766ms（约 50%）；关闭 10.711→12.151ms。只对该场景作结论，不能声称所有保存提升或零卡顿；仍同步约 255ms，不代表真实用户数据性能。
- **本机安装：** `/Users/chrisli/dev-artifacts/pasto/retention-response-native-install-76528-20261111-161112/out/install-result.json` 为 passed；380 输入构建前 / 后 / 安装前及当前一致，源 / 安装 249 条清单一致，备份已验证。稳定 Apple Development / Team 4NJM425J3B、原 Bundle ID、1.0.9；新 PID 78872 于本地 16:18:28 从 `/Applications/Snapclip.app` 启动并观察 12 秒。未手工修改用户历史或 TCC，无新增设备。独立部署审计通过：`/Users/chrisli/dev-artifacts/pasto/retention-response-deploy-cleanup-audit-79572-20261111-162200/out/deployment-audit.json`，直接复核 380 输入、249 条包清单、strict / DR、备份、唯一 PID 78872 及清理均通过。

正式下载保持 1.0.8，未提交或发布。真实用户历史清理、TCC、实际物理交互及 Intel / 旧系统不在本轮验收范围。以下历史记录只代表各自时点；旧勾选、自绘确认框及旧安装结果不能替代本轮证据。

# 七项保留期限与完整来源图标验证 · 2026-11-11

本轮用户指定保留期限为 1 / 3 / 7 / 15 / 30 / 60 天及永久的直接选项块，不提供自定义输入、锁或会员选项。旧非预设值打开时只读显示，不自动改写；用户显式选择新值后保存，缩短先确认。来源应用图标仅调整完整适配与留白，不重绘资产或改动来源持久数据。

原生自验、主控三轮复跑及 15 图盲视觉审查已通过，源码独审及最后摘要核对通过；fresh 本机包替换与全新独立部署审计通过。隔离控件和像素检查不等于可见界面、真实用户历史清理或 TCC 验收。本地版本 1.0.9 / 正式下载 1.0.8 保持，未提交或发布。

| 范围 | 本轮结果 | 证据与边界 |
| --- | --- | --- |
| 七项期限原生自验 | 中英各 51 项、5 张浅 / 深色及旧值图通过 | `retention-tiles-native-verified-51995-20261111-134834/out/`（项目产物根 `/Users/chrisli/dev-artifacts/pasto/`）；仅七按钮 4 + 3，Space / radio / 勾选、旧值只读、`<=0` 不自动规范化、缩短三取消键及明确按钮、失败 / 外部更新保护 |
| 期限主控复跑 | 三轮独立中英进程各 51 项，guard exit 0 | `/Users/chrisli/dev-artifacts/pasto/retention-tiles-final-repeat-52730-20261111-135045/out/`；六个独立 JSON fixture，skip 图不减断言，build 已清；不测试真实历史删除 |
| 来源图标自验 | 102 项、8 图通过 | `/Users/chrisli/dev-artifacts/pasto/card-source-icon-native-verified-54814-20261111-135547/out/`；3 比例 × 4 尺寸 × 浅 / 深色 24 卡、fallback / pinboard 身份及只读 Terminal 图标；normal 最大 44pt / compact 最大 20pt，右 8pt，fit 不裁切 |
| 图标主控复跑 | 三个独立进程各 102 项，guard exit 0 | `/Users/chrisli/dev-artifacts/pasto/card-source-icon-final-repeat-56029-20261111-135855/out/`；build 已清，不把重复场景冒成新增覆盖 |
| 设置父页 | 中英各 13 项、640pt 两图通过 | `/Users/chrisli/dev-artifacts/pasto/tiles-icons-settings-parent-55514-20261111-135806/out/run-1/`；清空历史完整、无需滚动，PNG 开关不跳导航断言，guard exit 0、build 已清 |
| 独立视觉 / 源码 | 盲审 15 图无必要修正，不打分；源码及最后摘要核对通过 | 原生离屏静态画面；不验实际可见窗口或动效。保留 5 + 图标 8 + 父页 2，暗色既有序列化正文未改，不声称全卡暗色可读性改善 |

| 最终包 / 安装 / 独审 | fresh native、本机替换及全新独立部署审计通过 | `/Users/chrisli/dev-artifacts/pasto/tiles-icons-native-install-57188-20261111-140227/out/install-result.json` guard exit 0：379 输入、三 arm64、稳定 Development / strict / DR 同旧包，源 / 装 249 清单全等，旧 zip 验证，无回滚；旧 39852 正常退出，新 58391 于 14:04:24 从 `/Applications/Snapclip.app` 启动并观察 12 秒。独立 `/Users/chrisli/dev-artifacts/pasto/tiles-icons-independent-install-audit-58554-20261111-140622/out/independent-install-audit.json` guard exit 0，实际包 / 输入 / 测试摘要 / 独立备份 / 唯一进程 / 清理复验通过。无手工用户数据或 TCC 操作、设备为零；build / stage / bootstrap 已清，安装 32M / UI 证据 6.6M，Data 215GiB。 |

本轮仅 UI fit / raster / 控件改动，Core 过期规则、来源持久化、权限和快捷键业务不变。379 项产品输入包括新增 CardSourceIconPresentation；另外两项 Assets 与 ReplicaBrand 的 13:36 已有未提交变化早于本轮 13:45 验证，纳包保留但不归因于本轮。早期图标检查色域和 fixture 去重诊断已修，不记作产品缺图故障；失败 / 重复 PNG 由实施者清理，仅留原日志。下方历史验证保留各时点，旧自定义控件结果不能替代本轮七项选择验证。

# 设置六分组与文案治理 · 2026-11-11

六组已完成为通用、剪贴板与历史、截图、快捷键、隐私与权限、AI 工具；权限完整组件只在隐私与权限出现。原 tab ID 保留，剪贴板与历史 ID 3、截图深链 ID 2。最终文案、自验、独立视觉 / 源码审计、fresh native 及本机替换和全新独立部署审计通过。

| 范围 | 当前结果 | 证据与限制 |
| --- | --- | --- |
| 最后文案 | 仅 UI 文案，独立审计通过 | `/Users/chrisli/dev-artifacts/pasto/settings-copy-final-fix-37517-20261111-124421/out/`；四条快捷键标题统一为 Open History Panel / Open Stack Panel / Next Group / Previous Group，OCR 两语精简、历史英文去时间戳术语，行为未变 |
| 最终主控原生验证 | 一次编译、三轮独立中英进程，六份结果各 13 项、guard exit 0 | `/Users/chrisli/dev-artifacts/pasto/settings-ia-final-verification-37803-20261111-124531/out/`；每次独立 fixture，三轮图数 18 / 0 / 0，9 源摘要与当前一致，build 已清 |
| 导航及深链 | 真实 NSOutline 选择后的截图页标题区域与基准精确像素匹配，右 pane 变化 | 不称整页像素全等，不是物理鼠标点击；基准 initialTab 2，旧 ID 兼容，新剪贴板与历史 ID 3 |
| 独立审查 | 源码 / 最终文案无阻断；两轮不打分视觉审查通过 | 盲审 18 图找到四条旧标题，复查最终中英 10 张相关图确认修复；最终 18 图在上述 `out/run-1/`。无 native 动效录屏或旧版本基线；保留“已保存”链接预览限定，避免误导能力 |
| 权限专项 | 中英各 63 项、guard exit 0 | `/Users/chrisli/dev-artifacts/pasto/settings-ia-permission-regression-31763-20261111-122952/out/`；隔离检查非真实 TCC 授权变化 |
| 保留期限专项 | 中英各 49 项、guard exit 0 | `/Users/chrisli/dev-artifacts/pasto/settings-ia-retention-regression-31767-20261111-122958/out/`；四张确认 / 失败图及 JSON / 日志保留，重复八图已清，不做真实历史清理 |
| 包 / 安装 | 最终 fresh build、安装及独审通过 | 最终 fresh `/Users/chrisli/dev-artifacts/pasto/settings-ia-final-native-install-38808-20261111-124807/out/install-result.json` guard exit 0：378 输入构建前 / 后 / 安装前一致，三 arm64、Apple Development 稳定签名 / strict / DR 同旧包，源 / 装 249 条 sha / mode / symlink 一致，备份验证无回滚。旧 PID 5766 正常退出，新 39852 于 12:49:32 从 `/Applications/Snapclip.app` 启动并观察 12 秒，无原运行 Helper。独立部署审计 `/Users/chrisli/dev-artifacts/pasto/settings-final-install-audit-verified-40155-20261111-125130/out/independent-install-audit.json` guard exit 0，直接核对实际 378 输入、9 测试摘要、249 包清单、系统信任严格签名、独立解压备份、唯一进程真实路径及清理。无真实设置 / 历史 / TCC 手工操作，无新增设备，build / stage / bootstrap 已清；安装 33M、UI 5.7M，本轮全部自有产物约 66MiB、30 张截图，Data 可用 216GiB。 |

旧 `settings-ia-native-rendered-33750` 结果仅代表最后文案之前的首轮；旧 18 图已清 16，仅保留中英 4top before 与两个 contact sheet（含旧图缩略图），不将已删图片作为最终证据。最终图独立位于 final-verification 的 run-1。实际可见设置页、物理点击、真实 TCC / 用户数据、旧系统及 Intel 仍未验；公开下载 1.0.8、本地版本 1.0.9 不变，无提交或发布。

# 历史保留时间交互验证 · 2026-11-11

用户反馈保留时间滑块难以操作且无法判断周期。本轮将它替换为显示完整天数及周 / 月说明的原生菜单，预设 1 / 3 / 7 / 14 / 30 / 90 / 180 / 365 天及永久；自定义新输入范围 1–36500 整数天数，既有非预设及超范围值原样显示，不因打开或重选而改写。按记录进入历史的时间计算、仅清理过期未分组内容的 Store 规则未改。

缩短期限（包括永久改为有限）须确认后才保存并立即清理；取消不保存，保存失败恢复设置值、保留错误及自定义草稿。设置值恢复不等于已证明真实 Store 失败事务或数据回滚。隔离原生 harness 使用 fixture JSON、真实 AppKit 控件及离屏 cacheDisplay 图像，不访问 ClipboardStore、Defaults、TCC 或用户历史。

| 范围 | 当前结果 | 验证边界与证据 |
| --- | --- | --- |
| 原生控件与设置值保存 | 中英各 49 项通过，独立审计无阻断 | `/Users/chrisli/dev-artifacts/pasto/history-retention-native-final-4391-20261111-094824/out/result-zh-Hans.json` / `result-en.json`，生产摘要见同目录 `source-sha256.txt`；真实 native 预设 / 自定义 action、异常及现有非预设值、同值零写入、failed-save 设置回原值且错误 / 草稿保留、隔离 fixture 重读、weak sheet / editor 释放 |
| 缩短确认与键盘安全 | 真实原生 sheet 的取消及明确清理按钮通过 | Return（keyCode 36）、数字 Enter（76）、Escape（53）均取消；只有明确 confirmButton 提交。自定义缩短 → 确认串联取消零写入；不把注入确认回调当实际 sheet 通过 |
| 中英文布局及源码接线 | 12 张中英 2× 离屏 PNG 无截断，AuxiliaryViews 解析通过 | 同目录 `*-420pt-2x.png` / `*-360pt-2x.png`、`auxiliary-parse.log`；AppKit `cacheDisplay` 只作组件离屏布局证据，不代表完整设置页实际可见操作 |
| 主控独立复跑 | 三次均中英各 49 项、guard exit 0 | `/Users/chrisli/dev-artifacts/pasto/retention-verify-repeat-1-4564-20261111-094923/out/`、`retention-verify-repeat-2-5079-20261111-095015/out/`、`retention-verify-repeat-3-5737-20261111-095110/out/`（后二者同属 `/Users/chrisli/dev-artifacts/pasto/`）；build 均已清。这是相同有限场景重复，不是新增 294 种覆盖，不扩大真实 Store / 可见交互范围 |
| 新鲜 native 包 | 377 项完整输入、三个 arm64、同一稳定开发签名通过 | `/Users/chrisli/dev-artifacts/pasto/retention-native-install-4568-20261111-094930/out/` 的 `bundle-check.json`、`product-input-set-check.json`；构建前后及安装前输入一致，版本 1.0.9、原 Bundle ID、Apple Development / 非 ad-hoc / strict，与旧安装相同 designated requirement，probe 只验证结构 |
| 本机替换 | 249 条源 / 安装清单、12 秒进程观察及全新独立安装审计通过 | 同目录 `install-result.json`：旧 PID 65128 正常退出，无运行 Helper，新 PID 5766 于 2026-11-11 09:51:06 从 `/Applications/Snapclip.app` 启动；模式 / 符号链接 / 哈希一致，旧包 zip 已核验，无回滚 / 手工改 TCC 或用户 Store。任务 33M、Data 可用 205GiB；不代表真实设置页或历史清理验收 |

安装独立审计证据为 `/Users/chrisli/dev-artifacts/pasto/retention-install-independent-audit-5942-20261111-095207/out/independent-install-audit.json`，guard exit 0；直接核对实际 377 项输入、249 条包清单、严格稳定开发签名、与前包相同 designated requirement、三 arm64、独立解压旧备份签名、唯一 PID 5766 的真实可执行路径与存活、自有 stage / QA 清理。构建任务 guard success、build 已清、无新增设备；安装任务 33M，各隔离测试任务约 364K，Data 可用 205GiB。

完整设置页的实际可见操作、真实历史清理、真实 Store 失败数据回滚和旧系统 / Intel 仍待验证。本次 fixture 结果不替代用户数据或整套 UI 回归；旧综合 UI harness 未运行，其历史 `panelWillShow` 接线问题未在本轮修复。未重建 Universal / DMG、提交或发布，正式下载仍为 1.0.8。

# 权限状态自动刷新验证 · 2026-11-11

用户反馈两项系统权限已打开，但应用仍显示未授权。本轮只修权限状态语义与自动刷新；上轮上圆下直 / 同步热点包已安装、用户确认操作明显顺畅的证据保留。权限源码自验及独立代码审计、新鲜 native / 稳定本机签名、再次安装独立校验和主控重复检查通过；真实系统开关与应用内父子进程权限归属仍待用户验证，不据 shell CLI 结果验收。

| 范围 | 当前结果 | 验证边界与证据 |
| --- | --- | --- |
| 权限状态 / 生命周期 | 中英各 63 项自验及独立代码审计通过 | `/Users/chrisli/dev-artifacts/pasto/permission-live-refresh-final-59138-20261110-235437/out/permission-en.json` / `permission-zh.json` 及生产摘要；含 AX / post 分开、注入授予 / 撤销、当前缓存与新检查差异、灰色失败、同值零发布、单飞、子进程期限 / 取消、真实同一 NSWindow 关闭后重开自动刷新 |
| 主控权限复跑 | 3 次各中英 63 项，guard 均 exit 0 | `/Users/chrisli/dev-artifacts/pasto/permission-refresh-repeat-1-61993-20261110-235813/out/`、`permission-refresh-repeat-2-62055-20261110-235831/out/`、`permission-refresh-repeat-3-62029-20261110-235821/out/`；同一有限场景重复，不是新增 378 种覆盖，不增加真实 TCC 范围 |
| 本机稳定签名预检 | Apple Development 临时程序签名 / strict 通过 | `/Users/chrisli/dev-artifacts/pasto/stable-signing-preflight-56570-20261110-234706/out/signing-preflight.json`；仅仓库外临时程序，未运行 / 安装或导出私钥；最终包另核 |
| 新鲜稳定签名包 | native / 完整输入 / 原身份 / strict 通过 | `/Users/chrisli/dev-artifacts/pasto/permission-stable-native-install-60864-20261110-235622/out/`；375 项完整输入构建前后及安装前相同，三个 arm64、版本 1.0.9、Apple Development / 非 ad-hoc，正式下载仍为 1.0.8 |
| 实际主程序早期 CLI | 有效入口 / 身份、错误参数和无 sentinel 通过 | 同目录 `headless-probe-check.json`；有效 0.144 秒，错误参数 exit 64 / 0.552 秒；入口在 NSApplication / delegate / Store 之前。shell 结果仅证明结构，不能代表实际主应用 TCC 责任归属 |
| 再次替换与收尾 | 安装校验及独立部署审计通过，guard success | 同目录 `install-result.json`；249 条源 / 安装清单含模式 / 符号链接 / 哈希一致，strict，旧 PID 52489 正常退出，新 PID 65128 于 2026-11-11 00:01:56 从最终路径启动、12 秒存活；旧包 zip 已核验，无回滚 / TCC / Store 手工改动。build 已清、无新增设备；任务 33M、Data 208GiB |
| 真实系统授权变化 | 仍待实际操作 / 用户验证 | 同目录 `authorization-validation-boundary.json`；应用内 `permissions` OSLog 只记变化的安全布尔值，这段未取得实际状态记录。未把注入授予 / 撤销、shell CLI 或稳定签名等同于真实开关与刷新通过 |

自动检查在返回应用、窗口重新成为 key 和同窗重开时刷新；页面可见时每 3 秒异步轮询，隐藏或关闭后停止。失败显示灰色重试，当前版本未获有效授权显示“未生效”；发现新授权而当前进程仍持旧值时提示退出重开。监测不请求权限、截图、发键、读取 TCC.db 或自动重启，只有主动授权按钮会请求。2 秒仅指已启动子进程的检查期限，不对系统创建进程阶段作硬时限承诺。临时签名到稳定签名的首次过渡可能需要重新添加当前应用，稳定签名不保证继承旧授权；正式临时签名安装包的既有实测限制保留。

权限最终自验任务 404K，三次主控复跑及本轮安装均 guard success、build 已清、无新增设备；安装任务 33M、Data 可用 208GiB。当前按“已实现并安装，真实授予 / 撤销与应用内刷新待用户验证”收口；以下记录保留各自历史时点。

# 此前上圆下直与同步编码热点验证 · 2026-11-10

用户纠正历史面板底板必须仅左上 / 右上圆角，左下 / 右下直角，并报告整个应用含设置页卡顿。两项修正使用新 worker 实施；下面仅记录本轮已取得的证据，前轮四圆角包的上角截图不能替代四角要求验收。

| 范围 | 当前结果 | 验证边界与证据 |
| --- | --- | --- |
| 修复前安装版性能采样 | 两次 6 秒采样与 18 次 CPU 读数完成，guard exit 0 | `/Users/chrisli/dev-artifacts/pasto/lag-summary-38886-20261110-224501/out/diagnosis-summary.json`；CPU 峰值 87.8%，RSS 约 42–444MiB。首份后台线程 280/539 帧在云同步写路径，其中 169 帧为 JSON 编码；main 两段分别 531/539、536/546 帧等待事件，未捕获持续 TCC / validate 阻塞 |
| 顶角限定实现 | 42 项通过并经独立审计 | `/Users/chrisli/dev-artifacts/pasto/panel-top-corners-native-mask-40437-20261110-224919/out/result.json`；三个尺寸的生产 Shape / 原生层栅格 TL / TR alpha=0 / 0、BL / BR=255 / 255，resize 后一致。离屏像素不冒充真实窗口 / 滚动；macOS 26 分支只核对源码 |
| iCloud Drive 独立 transport | 10 项 shipping 行为、2 项提取副本计数断言及三轮合成负载对比通过 | `/Users/chrisli/dev-artifacts/pasto/icloud-noop-transport-41102-20261110-225123/out/noop-performance.json`；16MiB payload / 22,370,478 字节文档。精确 actor 提取的旧 / 新 no-op 平均 CPU 0.577441 / 0.059848 秒、墙钟 0.592406 / 0.061894 秒；初写 + 三次 no-op 编码计数 4→1。插桩副本对比，实际 shipping transport 另测三轮 no-op CPU 0.060932–0.062166 秒、墙钟 0.063632–0.064729 秒；不代表全 App 延迟或真实云链路 |
| 完整 Store 同步回归 | 新旧 transport 在相同未改 Store / 原 harness 下均失败，未解决 | `/Users/chrisli/dev-artifacts/pasto/icloud-store-baseline-control-42910-20261110-225439/out/store-comparison.json`；两组均 exit 1、报 `Conflict did not converge`，`matchingOutcome=true`。旧 actor 仅逆转编码后移，完整源摘要与诊断前匹配；只证明该断言在旧代码同样复现。控制任务 guard exit 0 表示对比完成，不能记 suite 通过；独立 transport 通过不代表全部 Store / 同步回归通过 |
| 新鲜应用包与再次替换 | native / 完整输入 / 安装检查及 guard 收尾通过 | `/Users/chrisli/dev-artifacts/pasto/corrected-corners-sync-native-install-44828-20261110-225920/out/`；373 项完整输入构建前后及安装前一致、三个 arm64 / 原身份 / strict，源与安装 249 条清单相同。旧 PID 22051 正常退出，新 PID 52489 于 23:35:26 从最终路径启动、观察 12 秒；旧包 zip 已核验，无回滚。版本仍 1.0.9，未发布 / 手动改 TCC 或数据 |
| 安全中文 QA | 6 项生产控制器生命周期通过，已正常退出 | 同目录 `qa/self-checks-zh-Hans.json` / `qa/teardown-check.json`；不等于实际四角窗口、状态栏点击 / 动画或交互性能通过 |
| 更新后用户反馈 | 设置页切换 / 按钮点击已明显顺畅 | 本聊天用户实测回答“已经明显顺畅”；非量化操作阶段 profile，不保证所有场景性能，未增加真实 TCC / 动画验收范围 |

修复前采样基于用户自然活动，未记录当时窗口是否显示或具体操作；确认的同步 CPU / 临时内存热点不能解释全部体感卡顿。诊断仅只读进程 / 系统信息，未读取真实历史内容或改变同步、权限和用户数据。编码后移后，内容变化的写入会在协调写区编码，可能延长该区占用；no-op 仍需读取 / 解码旧文件。更新后设置页切换 / 点击的实际改善已获用户确认，但未取得操作阶段量化 sample，不能称所有场景卡顿已解决。原始采样目录 `/Users/chrisli/dev-artifacts/pasto/lag-diagnosis-37912-20261110-224212/out/`，两项诊断任务产物 828K + 20K；连接期补采 `/Users/chrisli/dev-artifacts/pasto/lag-connection-sample-49976-20261110-232639/out/` 为 292K、guard exit 0，main 915 帧中 914 等待、后台云编码 CPU 峰值 96.4%，发生在替换前且不是操作阶段证据。主控本轮 CUA getApp 调用指定 10 秒 timeout 仍阻塞约 1871 秒，仅返回旧包面板 AX，无新四角窗口截图或设置操作，不把工具阻塞归因产品。真实四角窗口、TCC 和状态栏动画仍未验。

本轮集成 / 安装 guard 为 success，pid / pgid 为 null、devices 为空，build 已清，自有 QA 进程为零；任务 49M，Data 可用 208GiB，未创建设备。文档和正式下载继续区分源码 1.0.9 与正式版 1.0.8；前轮四圆角包的可见记录及安装均仅保留其历史时点。

# 此前面板与权限修复验证 · 2026-11-10

两个全新 worker 分别实施面板与权限修改，两个领域均经全新独立审计通过。新鲜 native 与中文 QA 初始控制器检查已通过；主控完成下表所列有限中文可见验收，集成 guard 整体 exit 0 并完成收尾。本节将源码检查、合成权限状态、真实控制器、可见 UI 和真实 TCC 分开记录，不以历史测试替代本次验收。

```sh
~/dev-artifacts/bin/storage-guard run --repo pasto --task permission-status -- bash replica/scripts/test-permission-status.sh
~/dev-artifacts/bin/storage-guard run --repo pasto --task panel-permission-native -- bash replica/scripts/test-panel-permission-interaction.sh
```

| 范围 | 当前结果 | 验证边界与证据 |
| --- | --- | --- |
| 状态栏退出手势、圆角源码 | 两文件语法检查、生产代码提取的按钮屏幕命中判断 6 项及静态接线检查通过，独立审计无阻断 | `/Users/chrisli/dev-artifacts/pasto/panel-transition-check-93633-20261110-214442/out/`；不能代替真实快速 / 长按 / 右键或动画顺滑度验收；圆角可见结果另列 |
| 权限引导与状态 | 中英各 25 项通过，4 份生产源摘要匹配，独立审计通过 | `/Users/chrisli/dev-artifacts/pasto/permission-status-3831-20261110-215216/out/`；测试纯 policy、目录隔离完成标记、请求 spy、AX / post 不一致、人工发布激活通知由生产订阅接收、轮询、停止观察、调用 GuideWindowController.close() 后的 delegate 持久化，以及离屏中英布局 |
| 主控权限脚本复跑 | 3 次各中英 25 项，guard 均 exit 0 | `/Users/chrisli/dev-artifacts/pasto/permission-repeat-1-17874-20261110-222357/out/`、`permission-repeat-2-17881-20261110-222404/out/`、`permission-repeat-3-17884-20261110-222411/out/`；同一有限场景重复稳定性检查，不是新增 150 种覆盖，不增加真实 TCC / 完整粘贴链范围 |
| 新鲜 native | 通过并独立复核；guard 整体 exit 0 | `/Users/chrisli/dev-artifacts/pasto/panel-permission-integrated-native-3849-20261110-215226/out/`；1.0.9 / 原身份 / 三个 arm64 / strict 签名及按钮接线通过，重新枚举的 373 产品输入前后全等。该构建阶段未安装 / 启动成品；后续本机替换另列，未重建 Universal / DMG |
| 用户授权本机替换 | 指定已验 native 包替换并重启通过，安装 guard exit 0 | `/Users/chrisli/dev-artifacts/pasto/install-panel-permission-20124-20261110-223220/out/install-result.json`；249 条安装清单与源包相同、严格验签，旧 PID 86244 正常退出，新 PID 20954 从 `/Applications/Snapclip.app` 启动，12 秒存活；无原运行 Helper。旧包 zip 备份已解压核验。版本仍 1.0.9，未手动改 TCC / 数据、不代表权限或动画验收。任务 9.1M、Data 208GiB，build 已清，无新增设备 |
| 安全 QA 初始生命周期 | 中文 6 项通过并独立复核；英文 QA 跳过 | 同目录 `qa/self-checks-zh-Hans.json`；直接调用生产 controller 验证 show / hide、关闭时重开、toggle 及透明窗口，不代表实际状态栏点击、长按、右键菜单或动画顺滑 |
| 主控中文 CUA | 红 / 绿引导预览、两次 Continue 关闭、左右上圆角和通用 / 隐私两页状态可见通过 | 生产组件注入状态的引导，两次真实点击关闭；生产 panel 通过 QA Show 打开，截图圆角清晰；真实隔离 Settings 两页只读状态为绿，未点授权请求或系统开关。原始 CUA 截图 / AX 在本聊天，范围见同目录 `qa/coordinator-cua-observation.json`，事件见 `qa/qa-state-before-teardown.json` / `qa/qa-state-zh-Hans.json`；未另存 PNG，未新增独立视觉审计 |

权限检查不会主动请求系统授权；harness 的请求动作全部为 spy，guide controller 测试可能只读系统状态。25 项 harness 中，引导持久化通过调用生产 controller.close() 实测，Continue 与标题栏关闭只核对源码接线；另由主控 CUA 真实点击了注入状态预览的 Continue 关闭，仍不等于完整 AppDelegate 首次启动流程验收。激活通知为人工发布，并非实际切换应用。Esc 未验证，不列为支持。该 harness 所附红绿 PNG 为离屏组件布局证据；早期 `permission-status-97290-20261110-214954` 透明缓存图的按钮标题不可读，已作废，不冒充本次原始 CUA 截图。设置通用 / 隐私两个入口可见，但完整 App 粘贴弹窗链、真实授权 / 撤销、当前 `/Applications/Snapclip.app` 授权故障和跨临时签名更新的授权连续性未据此通过。真实 PQ NSStatusItem 的坐标在屏幕外（x=-2641），未完成实际点击 / 长按 / 右键菜单或退出动画验收；英文可见 UI 未验。首次 CUA.getApp 工具调用阻塞约 1150 秒，之后 10 秒 timeout 调用正常，不归为产品故障。旧大 UI harness 引用失效 `panelWillShow`，本次使用新的小 harness，不扩大修复旧入口。

本次构建和证据均走 storage-guard。集成任务 marker 为 success、pid / pgid 为 null、devices 为空，build 已删，自有 QA 精确路径进程检查为空，见同目录 `qa/teardown-check.json`。最终任务 40M，Data 可用 210GiB，未创建设备。仓库内并行图标任务持续写入 `build/snapclip-icon/menubar`，本任务未接管或删除；它不属于本次测试产物。

# 此前截图与翻译接入验证 · 2026-11-10

前轮新增 `CaptureIntegrationHarness.swift`、`TranslationIntegrationHarness.swift` 和两个对应脚本，验证接入边界；本轮继续修复由验证确证的问题。worker 自验后经独立审计，不能替代真实截图引擎、全局快捷键或可见翻译面板验收。

通过 storage-guard 执行，构建与临时数据写 `build/`，证据写 `out/`：

```sh
~/dev-artifacts/bin/storage-guard run --repo pasto --task capture-glue -- bash replica/scripts/test-capture-integration.sh
~/dev-artifacts/bin/storage-guard run --repo pasto --task translation-bridge -- bash replica/scripts/test-translation-integration.sh
```

| 范围 | 本次结果 | 验证边界与证据 |
| --- | --- | --- |
| 前轮截图接入 | 52 assertions，guard exit 0，独立审计通过 | 真实 Settings/CaptureEntry/Coordinator/HistoryBridge/Store、跨进程偏好与私有剪贴板；引擎、Carbon、窗口隐藏/焦点为 double。证据：`/Users/chrisli/dev-artifacts/pasto/capture-glue-82220-20261110-201600/out/result.json` 与同目录 `run.log` |
| 保存投影修复后截图接入 | 最终 63 assertions，guard exit 0，独立审计通过 | 精确 Date、PNG/text/color 序列化字段重开差异为空、no-op、required-data 实际保存失败 / rollback 与合成 syncApply；完整边界与唯一证据见下文 |
| 三处设置英文本地化 | 中英各 39 项、四处源码接线，guard exit 0，独立审计通过 | 运行生产 Foundation provider；未重验修复后的真实窗口 / AX，不能代表全 App 英文无遗漏 |
| 翻译接入 | 18 checks，guard exit 0，独立审计通过 | 86 份生产 vendor 源码未变；macOS 15.8.1 已安装 en ↔ zh-Hans 模型的真实 Apple 双向翻译、合成图片 OCR 文本 → TranslationService.apple、设置保存/重开/启用路由、缺 provider、取消与 cleanup。证据：`/Users/chrisli/dev-artifacts/pasto/translation-bridge-80982-20261110-201151/out/` 中 `integration.json`、`settings-write.json`、`settings-read.json`、`cleanup.json` |

截图用例覆盖五种区域 action 的保存/跨进程读取/真实门面转交、热键重注册与失败重试、录制重叠、延期/取消/挂起/失败/stop 路径。全屏固定进入编辑器是当前行为；restore 只证明原 draft 同对象转交，不证明上游草稿内部完整性。前轮发现的重复 PNG `updatedAt` 约 1.044 ms 差异已作有限修复：保存成功后刷新实际 inserted / updated Item 对应的 published items / 本地 baseline 时间，保留去重、数据、身份与排序。最终重跑 63 项，guard exit 0，并经独立审计；PNG/text/color 完整序列化字段重开差异为空，Date 精确相等，ID / count 不变，no-op 不 save / publish，真实 required `Item.data` 验证失败回滚且重开不变，合成 syncApply 保留传入时间。唯一最终通过证据为 `/Users/chrisli/dev-artifacts/pasto/saved-item-projection-verified-14437-20261110-204331/out/` 中 `result.json`、`run.log` 与 `source-hashes.sha256`；前两次运行未通过，不能计入成功。泛型 `mutate` 的返回值快照（含 `createIntentText`）仍可能是保存前 Date，当前该 AppIntent 只消费 payloads；cloud journal save 前 capture 时序未改，syncApply 测试不代表真实云，不宣称全 API / 全 Core 时间一致。保存不入历史/确认入历史本轮仅源码核对，未实际点击按钮。

翻译未调用 public `OCRTranslatePanel.present` 或其私有 OCR/翻译方法，未验可见结果/错误卡；设置 adapter 的截图目标通过 spy 检查，不代表真实主设置深链通过。`appActive=false` 只是记录，未作为断言；未下载模型。中英可见设置两页主体、五种 action、Apple on/off、关闭重开和重启保留有独立 CUA 证据；英文设置标题、快捷键 AX 后缀及 `--no-global-hotkey` 禁用帮助三处中文残留现已修复；生产文案 provider 中英各 39 项、四处源码接线通过独立审计，证据在 `/Users/chrisli/dev-artifacts/pasto/settings-localization-171-20261110-203611/out/` 的 `en.json`、`zh-Hans.json` 和 `source-wiring.json`。修复后的真实窗口 / AX 未重新验收，不代表全 App 英文无遗漏。实际范围、证据与两次工具自动启动隔离事故见 [当前交接](../HANDOFF.md)，不得称这一轮全程完全隔离。

本轮在新 scratch 中完成 native Release 全应用构建，guard exit 0；371 产品输入前后摘要一致，1.0.9 版本、保留的应用 / Helper 身份、闪贴 / Snapclip 本地化名称、三个 arm64 可执行、图标字节与严格签名通过。证据为 `/Users/chrisli/dev-artifacts/pasto/projection-localization-native-28829-20261110-204727/out/` 中 `bundle-check.json`、`source-before.json`、`source-after.json` 与 `native-build.log`。未启动 / 安装应用、未重建 Universal / DMG；前轮成品不能作为这两处修复的可见或双架构验收证据。

# 核心验证

当前核心套件共 25 组，包含增量持久化和恢复事务顺序、地址级 Stack 数组与窗口契约、OCR 图像预处理及词位置框测试。这些属于本地功能与有限恢复契约测试，不能标记为全部原函数等价通过。迁移台账的完整性检查仍由 `validate.sh` 管理；经用户授权独立执行功能回归时，使用 `bash replica/scripts/regress-local.sh`，结果保存为各组日志和 `summary.json`，一组失败仍继续检查其他组。

在 `replica/` 目录执行：

```sh
swift build
swift run pasto-core-tests
swift build -c release
```

验证程序使用 Foundation、AppKit 和自定义断言，输出含 `passed`、`test_count`、`failure_count` 及逐组耗时的 JSON；失败时退出码为 1。当前只有 Command Line Tools 的环境缺少 XCTest，因此核心验证入口是 `pasto-core-tests`，不是 `swift test`。

所有用例创建独立临时目录与具名私有 NSPasteboard，结束后清理；不读写系统通用剪贴板，不读取原版数据库或用户历史，不运行原版。双进程用例会启动当前验证程序的两个 `--worker` 子进程，各自写入 30 条合成记录。

| 验证组 | 实际检查 |
| --- | --- |
| Unicode、搜索和去重 | 中文、组合重音、emoji；大小写和重音不敏感搜索；普通文本校验和相同则更新原项目的表示，普通文本不同保留独立项目；重开恢复及文件 0600 权限 |
| 分组、编辑和删除 | 同项目加入两个分组、移除指定分组、改名、删除分组保留内容；编辑清除陈旧 RTF；软删除、恢复、永久删除；无效分组错误 |
| 旧容量字段兼容 | 永久保留模式下，旧 `historyLimit` 字段不会额外触发未经证实的数量裁剪 |
| 陈旧实例合并 | 两个 Store 交错写入、偏好不同字段合并、同项目标题与分组修改保留；永久删除不被陈旧编辑复活 |
| 存档和损坏保护 | 导出、导入、重复导入幂等、保留本地不同项目、原始二进制及删除状态；拒绝截断存档，损坏数据库不被空数据覆盖 |
| 富文本和循环 | 真实 NSAttributedString 生成 RTF，保留 RTF/HTML 原字节；普通写回、纯文本写回；监控手动 poll 不重新采集自身写回 |
| 富文本编辑重开 | 替换陈旧表示并生成真实 RTF；重开后验证粗体、字号、颜色、下划线、段落对齐与 Unicode 正文，保留标题/来源/分组；私有剪贴板写回 |
| 只有 RTF 的内容 | 无独立文本表示时提取 Unicode 文本，同时保留原始 RTF 字节 |
| 多文件 URL | 两个独立 pasteboard item、中文/emoji/空格路径；保存重载后仍逐项保留原始 file URL 数据 |
| 大图和未知表示 | 生成真实 1024×1024 随机 PNG（大于 3 MB），重载、写回后逐字节相等且能被 NSImage 解码；未知二进制表示保留；无文本图片的普通纯文本模式产生空投影，不隐式替换成 OCR |
| 采集策略 | Concealed、Transient、AutoGenerated 类型；来源排除；永久暂停、未来暂停截止、已过期暂停恢复 |
| 历史时间保留 | 默认一周（7 天），0 天永久；缺省字段采用周，已保存的 0/30 等值不覆盖；周边界、过期未固定项目清理、固定项目豁免及重开保留设置；截止内项目和未来时钟项目保留 |
| 闲置刷新和待保存编辑 | 反复无变化 reload/save 的 Combine 发布数为 0，数据库 inode 和修改时间不变；刷新合并远端变更并保留尚未保存的本地字段 |
| 独立进程写入 | 两个真正独立进程并发持久化 60 条不同内容，再由新实例检查无丢失及内容完整 |

## CloudKit 同步定向验证

用户已授权本项源码迁移和必要测试。`bash replica/scripts/test-cloudkit-sync.sh` 当前有 67 项隔离检查：真实 CKRecord/CKAsset 编解码、引用及系统字段、原版六类记录、首次拉取与父子队列、冲突容量分支、在途编辑、删除、账户清理、损坏数据、磁盘写入失败不推进令牌、乱序关系到齐后投影、重开与归档隔离。未闭合的附件和图片冲突会保留编辑并暂停，而不是猜测后吞掉本机修改。服务端为内存模拟，**没有执行真实 CKContainer 网络同步**，这些结果不表示原版全部分支已完整迁移。

`python3 replica/Tests/Native/test_cloudkit_signing.py` 有 7 项自有签名配置校验。`test-cloudkit-live.sh --preflight` 当前发现有效签名身份为 0；真实合成探针缺少自有容器和匹配的 Apple 描述文件，未执行。该探针编译通过不等于云端测试通过。执行方式与剩余差异见 [CloudKit 迁移说明](../docs/CLOUDKIT_MIGRATION.md)。独立 iCloud Drive 的 33 项及 File Provider 记录只属于文件同步，不计入 CloudKit。

设置的定向原生 harness 检查隔离数据目录无法自动或手动开启同步，缺配置时不会初始化 CKContainer；只做离屏布局，不更改用户账户、历史、权限或已安装软件。

## 存储和性能边界

`bash replica/scripts/test-search-button.sh` 使用临时 Store、私有剪贴板和离屏面板，验证折叠搜索按钮九个点的真实命中树、原生鼠标点击后输入焦点、输入关键词后的筛选结果、重置搜索状态后的按钮恢复，以及 ⌘F 重开，重复三轮。延迟回归额外检查鼠标事件返回前搜索已经激活并获得焦点，输出三轮合成事件的焦点耗时。测试要求最终成功报告。该检查针对搜索入口，不代表全量 UI 验收。现有 `test-ui-interaction.sh` 仍有旧接口编译错误。

原版静态对照的按钮回调链为 `0x100041b98 → 0x10003e61c → 0x10003e658 → 0x10000df98`，随后在动画 action 中更新约束和输入焦点。Pasto 按钮先进入相同原生 dispatcher，再同步 SwiftUI 状态。原版 `0x10023ed40` 使用 NSButton 的鼠标松开动作，`0x10021cadc` 使用 `easeOut` 和未指定时长的 NSAnimationContext。定向耗时数据来自隔离原生事件，原版采用反编译代码对照。

0.3.0 核心增加多选原始表示顺序、分组重排/副本/清理、真实图片离线 OCR、瞬时类型开关仍防自身循环、清空历史保留固定项及 Stack 偏好重开/并发合并，共 19 组。

`test-ui-interaction.sh` 通过隔离面板的原生事件路由验证选择/拷贝/取消、多文本聚合、快速粘贴与纯文本修饰键、分组跳转、Stack 反转持久化及队首消费、五档暂停和恢复，并以离屏窗口检查 Esc、同进程外窗点击和关闭后快速重开。分组标签通过真实宿主命中树检查历史/普通分组共 22 个点（含图标、间隙、边缘和留白），验证按下不切换、内部松开切换、外部松开取消，以及仅双击标题进入编辑、编辑期间不误切换。脚本要求最终成功报告，提前退出不能当作通过。`test-window-policy.sh` 验证既有及新窗口的共享策略状态；`test-shortcut-model.sh` 验证旧配置解码、显式清除、录制校验与事件匹配。它们不向其他应用发送真实键盘输入，也不证明跨应用光标粘贴通过。

`test-accessibility-modal.sh` 单独构造授权提示，检查原生玻璃容器、内容替换后的层级、原版 280 点宽度、资源尺寸、回车/Esc 操作，以及首次/拒绝/已授权三种状态均导航到辅助功能设置；默认运行不调用权限请求或更改系统设置。macOS 26 的窗口保留 `NSGlassEffectView` 外壳，原生内容包装层通过零间距约束承载 SwiftUI。可见预览只有显式设置 `PASTO_MODAL_PREVIEW=1 PASTO_MODAL_OPEN_SETTINGS=1` 时才会在点击启用按钮后实际打开设置页面，仍不申请或切换系统权限。

CUA 合成数据演示验证搜索空状态、通用设置入口和实际 Option+Command+K 录制持久化。辅助进程已编译、嵌套打包并验证签名，尚未注册系统服务或做崩溃重启实验。旧版本空状态像素差异数据不作为新版测量结果。

最新源码将活动存储改为 Core Data / SQLite；跨进程仍通过同目录 `.lock` 的 `flock` 串行执行读取、三方合并、事务与发布。事务在主队列 context 的 `performAndWait` 中执行，仅在 `hasChanges` 时 `save()`；失败回滚，不发布未保存的时间、恢复事件或同步检查点。记录时间与内容字节分离，未变化的图片/文件内容不重新编码；同步日志文档及本地基线也独立保存。修订 UUID 用于刷新缓存，无变化时不写盘。

核心新增旧 JSON 一次迁移及重试、备份不变、删除后不重导入、16 MiB 二进制不变、未选中实体不更新、无变化不保存、SQLite 保存失败注入与回滚、Undo 清理时机、恢复通知前重开可见、并发编辑及无效选择不额外保存。云日志比较缓存与全量生成的图，包含 payload 改动后的失效路径。

`bash replica/scripts/test-copy-restore.sh` 使用 Release 构建，测量空历史、约 72 MiB JSON 等价历史、相同大历史且启用本地 CloudKit 日志三个合成场景，每种三次，首轮作为窗口热身。使用私有剪贴板和离屏窗口，检查恢复通知、复制反馈、返回和关闭的顺序；不访问真实 iCloud、原版运行时或用户历史，不安装或发布应用。

`clipboard.json` 只作为旧数据迁移输入和保留备份；首次成功的数据库事务为迁移标记。导入导出仍支持 JSON 归档，升级时旧的 JSON 写入进程应先退出，迁移后不会持续合并备份文件。多 GB 历史、断电及文件系统故障、原版全部数据库关系和所有错误分支仍需独立验证；本实现使用自有 Core Data 模型适配既有 UUID，不声称与原厂数据库格式互通。

## 验收范围

`test-icloud-drive-controller.sh` 当前包含 23 项隔离检查，覆盖单开关自动目录、默认关闭不建目录、配置恢复、身份保留、双客户端合并与删除、旧目录兼容、文件和符号链接保护、不可用云目录、取消及关闭持久化。原生界面回归渲染实际通用页同步行，不再保留同步设置弹窗。

`test-icloud-sync.sh` 使用两个独立临时 Store 和一个临时共享目录，验证初始双向合并、原始字节及来源关联、空组与颜色和排序、偏好隔离、不重复上传、不同记录的离线编辑、同记录冲突收敛、晚开启旧归档不覆盖新版本、持久删除标记、重开不复活、组删除后的成员清理、并发本地进程、损坏及未来版本数据拒绝、归档不复制设备身份、换目录后重新发布和拒绝符号链接数据目录。默认不访问真实 iCloud Drive 或系统剪贴板。`--live-icloud` 为显式开启的独立集成探针，仅写入合成内容，区分协调写入/回读成功与系统报告上传成功；失败后不将本地文件存在当作跨设备同步通过。该探针也不代替第二台物理 Mac 的验证。

`test-paste-group-migration.sh` 使用临时 Core Data 模型和数据库验证从 Paste 导入分组：覆盖活动 WAL、外部二进制附件的只读读取、空分组、颜色与组内/分组顺序、Unicode/富文本/多项表示还原、缺失内容计数、重复迁移保留本地编辑、既有/并发数据及设置保护、无效输入原子拒绝和重开恢复。默认不读取用户 Paste 数据；`--inspect-paste <db.sqlite>` 显式进行原版只读兼容性检查，仅输出数量，不导入用户的 Pasto 数据库。

`test-app-monitor.py` 为应用副本使用独立 Bundle ID、数据目录和私有剪贴板，以不打断 300ms 稳定计时的节奏验证真实采集与生成内容过滤。`test-helper-lifecycle.py` 使用临时应用身份运行真实 AppKit 进程及 NSWorkspace KVO，验证三秒延迟启动、不重复拉起、真实 SIGKILL 后恢复和正常退出后不重启。临时辅助程序副本添加诊断时间记录，检查启动失败后重试 Task 的十秒等待及每次尝试的三秒延迟；外部进程变化仍可以另行触发尝试，不假定全局冷却。测试的 SIGTERM 路径会清理自己拥有的进程和偏好。SMAppService 注册仍未覆盖。

核心用例通过说明这些合成场景中的行为与数据完整性符合实现契约。它们没有证明与 Paste 6.6.6 的全部业务行为一比一等价，也不替代原版与复刻的受控对照。UI、全局快捷键冲突、辅助功能权限下直接粘贴、登录启动、系统声音、真实计时器长期运行、文件 promise、HTML 外部资源、云同步、账号和移动设备互通，需要各自独立验收。原始 representation 被保留不等于所有接收应用的粘贴行为均已验证。

## 2026-10-29 面板与历史控件对照

新增悬停前后位图差异与恢复、22 个标签点击点、边缘按下后移出取消、创建未命名分组后延迟内联编辑与全选、提交改名、保留当前分组内容、原生保留期限锚点与中间天/周/月映射检查。`test-panel-scroll.sh` 使用生成的图片预览、临时 Store 和离屏面板，测量滚动边界通知处理并验证复用后项目与预览锚点身份；这不是物理触控板或原版的帧率基准。`test-copy-restore.sh` 继续验证保存、恢复通知和复制反馈先于关闭，未缩短原版 0.2 秒动画。

样式验收使用真实 macOS 26 SDK 构建；仅设置 `UIDesignRequiresCompatibility = false` 不能替代当前旧 SDK 的重新构建。隔离测试身份与正式安装均使用新设计配置。详细证据见 [四项对齐报告](../reports/replica/panel-interaction-parity.md)。
