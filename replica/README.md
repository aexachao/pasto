> 当前源码应用名称：**闪贴 / Snapclip**。全部快捷键统一在「设置 → 快捷键」的应用唤起、分组切换、粘贴操作和截图卡片中；「截图」页管理截图后行为和翻译。本轮生产模型、Helper 定位和路径契约已定向验证；完整应用与交互的最新验收状态见 [变更日志](../CHANGELOG.md)。
>
> 本地构建必须通过 `~/dev-artifacts/bin/storage-guard run --repo pasto --task app-build -- <命令>`。受管默认 scratch 为 `build/swiftpm/`、应用为 `out/Snapclip.app`、正式附件为 `out/release/`；`SNAPCLIP_BUILD_ROOT`、`SNAPCLIP_APP_OUTPUT_DIR`、`SNAPCLIP_RELEASE_OUTPUT_DIR` 可显式覆盖。新可执行文件为 Snapclip；Bundle ID、既有数据路径及旧 CLI alias 继续兼容。

# 闪贴 / Snapclip 开发说明

产品自有品牌、原创插图和中英文文案的来源见 [NOTICE](../NOTICE.md) 与[替换清单](../docs/BRAND_ASSET_REPLACEMENTS.md)。旧研究资源不因换名而成为原创；当前工程迁移及最终包清理状态以 [TESTING](TESTING.md) 为准。

独立 Swift 原生实现。主面板参考 Paste 6.6.6；静态函数、MCP 参数及部分行为由 REA/Ghidra 证据核对。日常运行使用闪贴自己的数据；只有手动选择“从 Paste 迁移分组…”时，才只读访问原版的本地分组数据。

## iCloud 同步与验证范围

用户最新要求按原版 CloudKit 路径迁移，当前源码新增 private/shared CKSyncEngine、六类记录、CKAsset、原子同步日志及设置入口。隔离合同已测试，但缺少闪贴自有签名和容器配置，真实 CloudKit 传输未验证，不能称已完成一比一同步。详见 [CloudKit 迁移与测试](../docs/CLOUDKIT_MIGRATION.md)。

### 独立 iCloud Drive 方式

当前首选文件同步，**设置 → 通用** 只提供 **iCloud 同步** 开关及简短状态，没有设置弹窗。两台 Mac 均需使用含此功能的构建、登录同一 Apple ID 并打开开关；自动使用 `iCloud Drive/Pasto`。已有自定义同步目录配置继续保留。开启时合并历史和分组，后续每 30 秒尝试同步；关闭后保留本地与云目录内容。这不等同于原版 CloudKit。

同步包含已保存的项目内容、原始格式、图片、来源应用信息及分组名称、颜色、顺序和成员关系。快捷键、权限、来源排除、暂停、保留期限和 Stack 队列不在设备之间同步。文件路径会保留，但对应的原始文件不会被自动复制。不要把不同保留期限视为独立删除策略：某台设备实际清理的内容也会通过删除标记传播。

每台设备维护自己的同步文档，使用确定性的版本顺序合并同一记录；同一条记录同时修改时采用版本较新的整条记录，不按字段合并。永久删除有持久标记，缺失文件不当作删除，避免离线设备或尚未下载的文档使内容丢失。大图片会增加本地处理、传输和 iCloud 存储开销。

详见[同步说明与验证范围](../docs/ICLOUD_SYNC.md)。专项隔离测试脚本为 `replica/scripts/test-icloud-sync.sh`，须在受管任务中配置外部 scratch 和证据路径后运行；只有显式添加 `--live-icloud` 才会向真实 iCloud Drive 写入独立合成测试文件。测试和演示数据目录不会启动应用自动同步。

## 从 Paste 迁移分组

在底部面板的“更多”菜单或菜单栏“文件”中选择 **从 Paste 迁移分组…**。应用会检测本机 Paste 数据，显示可迁移的分组和项目数量，确认后导入。

迁移保留分组名称、颜色、排列顺序，以及项目内容、标题、来源和组内顺序，包括空分组。只迁移分组内的项目，不导入原版整个剪贴板历史、账号或云同步设置。再次迁移只添加缺失内容，不覆盖闪贴中的改名、编辑和偏好设置；已有同名分组保留独立。

读取需要与数据匹配的已安装 Paste，支持读取正在使用 WAL 和外部二进制附件的本地数据库，不修改或升级原版数据。尚未在本机下载或无法解码的项目会明确统计并跳过，恢复本地内容后可重新迁移。未自动找到数据库时，可手动选择 `db.sqlite`，并保留同目录的 WAL 和附件目录。

## 构建运行

支持 macOS 14+ 的 Intel（x86_64）和 Apple 芯片（arm64）Mac。需要 Swift 工具链和 Python 3；为使用 macOS 26 的原生控件外观，构建时使用 Xcode 26 或更新版本。以下命令从仓库根目录执行。

默认构建 Universal 应用，在本次任务的 `out/Snapclip.app` 保留产物：

```sh
~/dev-artifacts/bin/storage-guard run --repo pasto --task app-build -- /bin/bash -c '
  export TMPDIR="$ARTIFACT_TASK_DIR/build/tmp/"
  export CLANG_MODULE_CACHE_PATH="$ARTIFACT_TASK_DIR/build/module-cache"
  export SWIFTPM_MODULECACHE_OVERRIDE="$CLANG_MODULE_CACHE_PATH"
  export SNAPCLIP_BUILD_ROOT="$ARTIFACT_TASK_DIR/build/swiftpm"
  export SNAPCLIP_APP_OUTPUT_DIR="$ARTIFACT_TASK_DIR/out"
  mkdir -p "$TMPDIR"
  bash replica/scripts/build-app.sh release universal
'
```

将末行改为 `bash replica/scripts/build-app.sh debug native` 可只构建当前 Mac。`build-app.sh` 在受管任务内自动采用外部 scratch 和应用输出；无 guard 的旧 `replica/.build`、`replica/dist` 默认值仅兼容现有 hosted CI，本地不可沿用。

正式打包同样通过 guard（`--task release-package --kind release`），配置 `SNAPCLIP_BUILD_ROOT`、`SNAPCLIP_APP_OUTPUT_DIR` 和 `SNAPCLIP_RELEASE_OUTPUT_DIR="$ARTIFACT_TASK_DIR/out/release"` 后运行 `npm run build:dmg`；完整命令见[根目录构建说明](../README.md#源码构建)。稳定版本需要项目外的更新签名私钥，此命令不会发布。只制作本地验证 DMG 时，使用同一受管任务内已构建的 `Snapclip.app`，将 `build-dmg.sh` 的目标路径放在该任务的 `out/`，脚本拒绝覆盖已有文件。`npm run build:icon` 已封装 guard，按选定的 `SnapclipIcon.png` 重新打包 ICNS 到任务 `out/`，不重画旧版图标。

本仓库尚无正式安装包；未来发布附件使用 `Snapclip-<版本号>-macos-universal.dmg`，下载同步只接受本仓库实际发布并验证完整的附件。镜像中的当前源码应用名为 `Snapclip.app`，历史安装包可能为 `Pasto.app`；安装以对应 Release 说明为准。本机安装与升级结果以最新测试记录为准。Bundle ID、Helper/MCP 可执行文件名、数据目录保持兼容。

未指定签名身份时构建采用临时签名；当前本机验收使用稳定开发签名，尚未经过 Apple 公证；包签名不保证 macOS 辅助功能授权连续，更新后仍可能需要重新开启。构建、签名、安装和功能验收分别记录。

菜单栏使用单色取景框与折角卡片标志，点击打开历史。默认全局快捷键为 ⇧⌘V，Stack 为 ⇧⌘C，区域截图为 ⇧⌘A，全屏截图为 ⇧⌘E。所有快捷键集中在「设置 → 快捷键」四组卡片；六个录制器右侧均有 ×，清空显示“未设置”，截图槽真正注销对应快捷键，重启后不自动恢复；菜单截图入口保留。旧配置未设 enabled 标志时默认启用，保留既有组合值。每个选项仅非默认时在快捷键左侧显示“恢复默认”；单项或确认后的“恢复全部快捷键…”都会重新启用对应默认截图绑定。取消录制保留原值。新旧应用名或用户改名不影响 Helper 按包含应用的 Bundle ID 定位。真实 Carbon 全局事件、SMAppService 注册及安装升级不由模型或路径测试替代。

最新源码使用 `~/Library/Application Support/PasteReplica/clipboard.sqlite`（Core Data / SQLite），保留既有数据路径。首次启动迁移旧 `clipboard.json`，成功保存后以数据库为准，原 JSON 保留不覆盖；升级前应退出仍写 JSON 的旧版应用和工具。数据目录权限 0700、数据库文件 0600；图片、RTF、HTML、文件 URL 等保留原始 representation，数据为本地明文。历史包的存储格式以其发布说明为准。

## 隔离演示

演示也在独立受管任务内构建并运行，使用合成数据与具名私有剪贴板；退出演示应用后 guard 才清理中间目录：

```sh
~/dev-artifacts/bin/storage-guard run --repo pasto --task isolated-demo -- /bin/bash -c '
  export TMPDIR="$ARTIFACT_TASK_DIR/build/tmp/"
  export CLANG_MODULE_CACHE_PATH="$ARTIFACT_TASK_DIR/build/module-cache"
  export SWIFTPM_MODULECACHE_OVERRIDE="$CLANG_MODULE_CACHE_PATH"
  export SNAPCLIP_BUILD_ROOT="$ARTIFACT_TASK_DIR/build/swiftpm"
  export SNAPCLIP_APP_OUTPUT_DIR="$ARTIFACT_TASK_DIR/out"
  mkdir -p "$TMPDIR"
  bash replica/scripts/build-app.sh release native
  "$ARTIFACT_TASK_DIR/out/Snapclip.app/Contents/MacOS/Snapclip" \
    --data-dir "$ARTIFACT_TASK_DIR/build/demo" \
    --fixture --no-monitor --no-global-hotkey \
    --pasteboard-name "local.snapclip.demo.$$" --show-panel
'
```

`--show-settings` 可直接打开设置。演示不监听系统通用剪贴板，也不发送系统粘贴按键；原生文本编辑器的系统剪切/复制/粘贴仍会使用系统剪贴板，隔离验证不调用这些命令。

## 工程命名与兼容

SwiftPM Package 为 `Snapclip`；独立模块为 `SnapclipCore`、`SnapclipObjC`、`SnapclipCapture`、`SnapclipMCP`、`SnapclipHelper`，测试为 `SnapclipCoreTests`，对应源码目录为 `Sources/Snapclip*`。主产品 / 可执行文件 / 源码目录为 `Snapclip`，主 target/module 暂保留 `Pasto` 与 AppIntent 类型。核心资源为 `Snapclip_SnapclipCore.bundle`。

构建变量使用 `SNAPCLIP_*`，兼容 `PASTO_*`，两者并存时新名优先。`snapclip-mcp` 与 `snapclip-core-tests` 为新产品名；旧 `pasto-mcp` 入口保留。`LoginItems/Pasto Helper.app` 物理服务路径、helper 标识、Bundle ID、CoreData runtime 名、四条解档 alias、偏好 / 数据 / CloudKit / iCloud Drive 标识保持原合同。它们不属于用户可见品牌遗漏，不扫描改写用户内容。

复制 / 截图成功音使用 macOS 自带 Purr，通过 `NSSound(named:)` 运行时加载，不复制系统音频、不读原 Copy / Paste 音频，也不回退系统 Pop；没有时间节流，连续不同操作均保留反馈。原 Pop 的多声段可解释重复听感，但未证明发生重复 play 调用；真实听感仍待确认。新启动图标、直接粘贴 / 复制到剪贴板 / 权限图来自内置图像工具，提示词和源图见 `branding/SnapclipGeneratedAssets/`；模型 ID 未公开，20pt 类别模板继续使用独立代码绘制。
区域 / 窗口截图的初始快照已在源码补齐放大镜与取色提示浮层的具体窗口排除，正常设置窗口仍可截取；原生注入快照定向测试通过，真实 SCK 像素与本轮联合安装验收分别记录于 [TESTING](TESTING.md)。 本轮联合 arm64 1.0.9 已稳定签名安装，392 输入 / 192 安装清单及启动观察通过实施自验；最终独立部署审计26项及主控直接复核通过，实际 SCK 像素与实体听感仍未验。


新模块已在隔离副本上读取、保存并重开旧库；完整 Core suite 在旧 / 新工程均因 SQLite `RAISE ABORT` 触发 CoreData fatal（exit 133），未通过。MCP 定向 fixture 自验 13/13 的结果仅覆盖其边界，不代表整个 Core suite 通过；最新证据见 [TESTING](TESTING.md)。

## MCP

将构建后的可执行路径用于 MCP 客户端；应用设置中的“MCP 与 AI 工具”页面可复制当前路径的配置。

```json
{
  "mcpServers": {
    "snapclip": {
      "command": "/绝对路径/Snapclip.app/Contents/MacOS/snapclip-mcp",
      "args": ["--data-dir", "/绝对路径/独立数据目录"]
    }
  }
}
```

支持 `search`、`read_item`、`create_item`、`update_item`、`delete_item`、`list_pinboards`、`create_pinboard`、`rename_pinboard`、`delete_pinboard`、`add_item_to_pinboard`、`remove_item_from_pinboard`。工具的 id 字段按已恢复的原版 schema 命名；`create_item(list_id)` 建立仅分组项目且不修改系统剪贴板，删除需要先查看确认预览。`replica_restore_item` 和 `replica_copy_item` 是明确命名的扩展。传输使用本地 stdio JSON-RPC，不依赖原版的本地 HTTP/token 桥接服务。

## 验证与差异

当前原版 REA/Ghidra、机器码和逐地址证据来自 arm64，不能作为已分析原版 x86_64 的声明。两个架构复用独立实现源码；涉及 AppKit、Carbon、Vision、权限及跨应用粘贴的实际行为，仍需分别记录目标机器架构和操作结果。

按原版地址逐函数登记，见 [FUNCTION_IMPLEMENTATION.md](FUNCTION_IMPLEMENTATION.md)。0.7.0 曾有十三个函数通过 336 个原版机器码直接差分用例，这是历史快照；迁移期间相关源码变化后会降为 migrated，当前数量以台账为准，不重跑回归来维持旧标签。OCR 已保存词级置信度和位置框，但尚未完成原版图片文字选择交互及全部字符串索引分支对照。兼容识别入口保留原图尺寸；地址级入口可传显式最大尺寸，原版调用方的默认参数仍待确认。

0.3.0 增加离线 Vision OCR、多选原始表示写回、快捷键录制及 Stack 队列持久化。通用设置中的“后台运行”使用独立 LoginItems 辅助进程，默认不自动注册。当前轮已执行隔离 Helper 启动、崩溃恢复、正常退出和失败重试；SMAppService 注册及正式安装升级仍未验证，当前证据索引见 [变更日志](../CHANGELOG.md)。

多选纯文本目前以换行合并，尚未证明分隔规则等同原版；窗口共享测试验证 NSWindow 状态，不代表会议或录屏软件实际遮蔽。

以下是已实际执行过的 Helper 隔离验收入口；输出保留在本次受管任务的 `out/`，不安装主应用或注册系统服务：

```sh
~/dev-artifacts/bin/storage-guard run --repo pasto --task helper-lifecycle -- /bin/bash -c '
  export TMPDIR="$ARTIFACT_TASK_DIR/build/tmp/"
  export CLANG_MODULE_CACHE_PATH="$ARTIFACT_TASK_DIR/build/module-cache"
  export SWIFTPM_MODULECACHE_OVERRIDE="$CLANG_MODULE_CACHE_PATH"
  mkdir -p "$TMPDIR"
  python3 -B replica/scripts/test-helper-lifecycle.py --report "$ARTIFACT_TASK_DIR/out/helper-lifecycle.json"
'
```

统一快捷键的生产模型 / 会话回归与实际页面验收分别记账。自进程 AX 观察器未获得 SwiftUI 虚拟节点时，不把观察器编译或缓存图片算作 UI 通过；未执行到交互断言的实验入口不作为正式验收命令。实际页面结果以独立 UI 验收及对应证据为准。

旧聚合入口 `validate.sh` / `regress-local.sh` 的默认路径及迁移前置条件不作为本轮受管验收示例；运行前必须按各组脚本实际支持的参数配置外部 scratch、应用和证据目录。`validate.sh` 会先要求完整迁移，不能用聚合入口被阻止来冒充功能通过。专项验证只代表其实际覆盖的行为，不表示全量迁移或全部 UI 通过。

从 0.7.0 起按用户要求不运行 MCP 测试；验证集中于原版机器码/复刻代码对照、核心功能和原生界面行为。已有 MCP 实现保留，历史 MCP 结果与当前测试分开记录。

用户最新调整为先完成全部函数代码迁移，再统一功能回归。迁移阶段只编译及静态检查；`validate.sh` 会先检查完整迁移状态，存在待迁移或部分迁移地址时直接退出，不启动功能测试。

已满足恢复契约的现有源码直接复用。纯 SDK 转发必须逐地址核对完整指令和真实 dyld 绑定，单独记录为复用；同名、同码片段或一个大功能已经存在均不足以直接跳过。最新台账分别记录源码函数与 SDK 转发数量，不将其当作界面验收比例。

迁移台账检查仍使用 `scripts/function_ledger.py --check`、`--require-migration-complete` 及 `scripts/verify.py`，按 [FUNCTION_IMPLEMENTATION.md](FUNCTION_IMPLEMENTATION.md) 的独立契约执行，并将生成证据配置到受管目录；不要沿用历史默认仓库输出。

当前迁移未完成，前置检查预期退出 2。SDK 静态记录校验需要本机匹配版本的原版安装、当前 release 产物及源码快照；源码或二进制变化会使旧证据失效。全部迁移完成后使用 `validate.sh` 统一进行功能回归，MCP 测试继续排除。

核心测试使用独立原生可执行 runner，不依赖 XCTest，仍执行真实持久化、AppKit 具名剪贴板和多个操作系统进程。详细覆盖见 [TESTING.md](TESTING.md)。

当前没有实现原厂 iCloud/账号/订阅服务、原版私有归档格式兼容，也未验证所有原版菜单、拖放目标和系统权限组合。因此不能标记为全功能或逐像素一比一通过。原生 UI 观察优先尝试了 REA，但宿主未取得辅助功能权限；原版底部 layer 24 面板也超出该工具当前 layer 0 限制，实际对照使用可用的桌面自动化接口。原版私有历史、账号及凭据均不作为公开测试输入。
