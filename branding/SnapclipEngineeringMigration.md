# 闪贴 / Snapclip 工程命名迁移方案

状态：2026-11-11 工程改名已实施，新 SwiftPM 独立模块与主 Snapclip 产品实际编译通过；新 SnapclipCore 已对只读旧库副本完成全量读取、保存、重开验证，原夹具 SHA 未变。完整 core 测试执行器触发 CoreData optimistic locking fatal，单独保留失败证据，不计全组通过。本机 arm64 debug 包的 executable/plist/helper/资源/rpath/codesign 验证与新旧 CLI initialize/tools 均通过；旧库新模块 post-save 独立审计已通过；MCP payload 修复后的 13 组独立验证通过。最终本机 arm64 release 品牌包已安装并由主控复算输入 / manifest / 签名，平台 thread limit 阻止另建全新最终部署审计 worker，最终由主控自查，不宣称部署独审完成。机器可读明细见 `SnapclipEngineeringMigration.json`。

本轮已实际迁移 SwiftPM package、module、product、executable、source directory 与脚本契约。当前 Package 为 `Snapclip`；主 executable target/module `Pasto` 是明确保留的 AppIntents 兼容桥（不是 `AppPasto`），产品 / 可执行文件 / source directory 为 `Snapclip`。独立模块已改为 `SnapclipCore`、`SnapclipObjC`、`SnapclipCapture`、`SnapclipHelper`、`SnapclipMCP`、`SnapclipCoreTests`；CLI 为 `snapclip-mcp` / `snapclip-core-tests`，旧 `pasto-mcp` alias 保留。对应 Sources 目录与 Tests/SnapclipCoreTests 已同步改名，Vendor/capcap 路径保留，核心资源 bundle 为 `Snapclip_SnapclipCore.bundle`。调查时旧 Package 为 Pasto；这属于迁移前事实，不是当前未迁状态。

主要前置条件：先冻结其他 worker 集成后的基线，再由旧模块真实写出隔离 Store/archive fixture，后由新模块生产持久化路径打开、修改、保存和重开。不能拿新模块生成的当前模型空库代替旧 Store 兼容测试。保留 fixture 生产源码/二进制 hash、SQLite 模型 metadata/hash、对象与关系快照、archive/checksum，验证无新空库、丢失、错类型或关系改变。此阶段不需要操作用户数据。

## 兼容边界

- CoreData 的 Swift 类型可改为 Snapclip 前缀，但 `OriginalManagedItem.swift`、`ClipboardItemDataPersistence.swift` 中显式 `@objc(Pasto*Entity)` / `@objc(PastoManagedObject)` / `@objc(PastoItemDataMigrationPolicy)` 保留；实际 model 用 `NSStringFromClass`，应对比改名前后 runtime name 和 entity version hashes，再实测旧库。
- `OriginalPasteboardItem` 已固定 `@objc(_TtC9PasteCore14PasteboardItem)`，四条 PasteCore/PastoCore 解档别名必须保留；checksum 使用 archive 数据，必须同时核对 archive 编解码和 checksum。
- Bundle ID、helper ID、session suite、Team ID、`PasteReplica` 数据目录、`PastoSync-v1`、`pasto-icloud-drive` 格式标记、CloudKit `Pasto` zone、实体/字段、用户配置键和旧安装 fallback 都保留。它们是持久化/系统身份，不妨碍内部 modules 改名。
- 新 MCP 可执行名加旧 `pasto-mcp` 兼容入口；JSON-RPC tools、schema、参数和 `--data-dir` 合同不改。新增 `SNAPCLIP_*` 环境变量需兼容 `PASTO_*`，新值优先；Actions 旧私钥 secret 不在本轮改名。
- AppIntents 当前是 Pasto* 类型。先保留类型标识；主 target/module `Pasto` 本阶段保留为明确兼容桥，product 为 `Snapclip`、显式 target path 为 `Sources/Snapclip`，保持 AppIntents 默认类型标识。其余 Core/ObjC/Capture/MCP/Helper 模块实际改名。未来若改主 module，必须使用改名前保存的实际快捷指令验收，不能仅编译就宣称连续兼容。
- Sources/scripts 搜索未见 URL scheme 注册；仍需核对最终 Info.plist/已安装 LS handler，不能仅据搜索宣称不存在任何外部入口。
- 旧研究、快照、NOTICE、标准 NSPasteboard / paste: API、用户内容和原始版权事实保留。根目录历史测试应通过当前源路径映射读取重命名后的文件，不能重写历史证据迎合测试。

## 实施和验收顺序（保留原调查计划）

1. 记录 dirty 基线与资产/L10n worker 接口；用 storage-guard 构建旧模块 fixture 生产器。
2. 原子更新 Package、五个源目录、测试目录、imports、限定名、ObjC modulemap/header、bundle accessor、native object/link 路径；再改 build-app/build-dmg/release/native harness 的 executable 和 bundle 契约。
3. 接 CLI/环境变量兼容别名；同步根 scripts/tests 当前源路径映射与活跃文档，保留历史输入。
4. 自验：package dump、shell/Python 静态检查、所有新 target/product 编译、旧库新模块 fixture、MCP 两入口、env 优先级、helper locator、offline iCloud/CloudKit 合同。
5. 独立 worker 审计后由新集成 worker 构建 arm64/x86_64 包，核对 plist、资源、rpath、签名结构与新资产/中英本地化。运行、SMAppService、旧快捷指令、权限连续性分别记录；安装/提交/发布另按授权。

调查时范围预估：精确 module/path token 命中 68 源码文件、34 测试文件、34 应用脚本；五个源目录移动涉及 283 个文件（含未改资源）。根 `scripts/tests` 354 文件含旧模块/源路径，是主要回归适配成本；应优先引入路径映射而非机械改写大量历史证据。数字是调查时文本命中数，不是承诺的最终 diff 文件数。

GitHub repo、Pages、feeds 与下载地址保持现状，本地 `/Users/chrisli/dev/pasto` 不移动。商店 sandbox、签名、entitlements、CloudKit identity 迁移是独立工作，内部工程改名不能当作已满足商店要求。

## 旧库夹具交付（历史阶段，2026-11-11）

最终只读交付：`/Users/chrisli/dev-artifacts/pasto/snapclip-legacy-fixture-finalize-15591-20261111-191225/out`。6 项、65 对象、11 类实体；真实 Application/Device/ItemData/ListMetadata 关系、CloudKit `Pasto` zone、iCloud Drive 快照和 NSKeyedArchive 均已保留。`manifest.json` SHA256 为 `9e504d34754c8b5ae77b83751cc26c80cb4926458c38cf9ce015065de94700ee`。旧库规范投影再次重开、归档 roundtrip、全部 payload 哈希和 SQLite 只读 quick_check 已过；这是当时的实施者自验，彼时独立审计与新模块读取待执行；后续新模块已完成 65 对象 / 11 实体读取、保存、重开及 post-save 独立审计，见后文当前进展。

初始 seed DTO 未设的 nativeChecksum 和部分 pinboardOrder 在旧库首次重开时规范化，因此以真实旧模块首次重开后的完整编码投影作基线，并通过第二次重开确认稳定。不得以 seed 内存对象替代旧持久化基线。fixture 文件设为 0444；新模块测试必须复制到新的受管 build 目录、仅恢复副本可写。不要原地修改夹具。成功证据默认保留七天，未 pin。

当时下一阶段精确写范围见 JSON `proposedStageThreeWriteScope`：核心独立模块/路径/执行文件实际改名，主 target/module Pasto 只作为 AppIntents 兼容桥。旧 data/runtime/archive/cloud/外部 URL 等有限兼容例外有明细；不允许用兼容名义保留所有内部工程名称。该历史阶段要求资产/本地化集成冻结并取得根 WRITE_GO 后执行；现已取得 WRITE_GO 并完成迁移，不再是待授权状态。

## 实施记录

六个源/测试目录已按 `SnapclipRenameManifest.json` 移动，保留旧目录 symlink 供历史源码查阅；所有实际 targets 显式使用新目录且不重复编译。旧提取 Resources/OriginalStackIcons.bundle 留作研究且排除发行；唯一 Core process 资源为 SnapclipResources。主 module Pasto 与全部 AppIntents 类型、CoreData Swift/@objc 类型保留。登录项物理路径 `LoginItems/Pasto Helper.app` 保留既有 SMAppService 服务身份，展示名 Snapclip Helper、可执行文件 SnapclipHelper；不能将静态身份保留声称实际注册连续性。新 CLI 为 snapclip-mcp，包装内附相同字节 pasto-mcp 兼容命令。

新 Core 夹具验证：6 项、65 对象、11 实体；全 DTO、对象 ID、关系、字段、schema version hash、运行时类型、归档四别名、新编码解码与保存重开通过；18 个原夹具文件前后 SHA 不变。证据见 JSON implementationEvidence。未验证旧已保存快捷指令和真实登录项服务；完整 core 测试器运行以 optimistic locking fatal 退出 133，不能以编译或夹具通过替代全组功能验收。

最终自验包：`/Users/chrisli/dev-artifacts/pasto/snapclip-engineering-migration-20465-20261111-193223/out/Snapclip.app`，仅生成可审阅产物，未安装/提交/发布。加强 post-save 检查重新枚举 65 个对象的所有字段/关系/runtime/objectID、11 个 schema/model hash，整个 Store metadata 与旧夹具完全一致；原 archive SHA 及所有 payload byteshash 亦一致。相同字节的新旧 MCP 包装入口均通过 initialize/tools-list。当时全量 MCP 脚本出现 timestamp 断言失败并交诊断；后续确认 create_item 的 UTF-8 payload 存在实际错误，已作一行修复，13 组独立验证通过。Core 锁冲突是单独问题，旧 / 新工程均因 SQLite RAISE ABORT 触发 fatal 133，完整 Core suite 仍未通过，不能据 MCP 修复声称总体全绿。

迁移前 290 个 Sources/CoreTests 文件已逆恢复并与最初记录的 dirty 源 SHA 逐项完全一致，交付 pre-rename-baseline；Package 是与本轮初读原文一致的 namespace 逆变换，较早旧库 producer 的 Package hash 不同（资源接入冻结发生在后），不混同。Vendor namespace 逆恢复未获本轮最初 hash 校验，明确保留边界。

## 当前进展与最终交付边界

新模块的旧库 post-save 独立审计已通过：65 对象 / 11 实体、字段 / 关系 / runtime / objectID、schema / Store metadata、archive 与 payload 保持兼容。MCP create_item UTF-8 payload 一行修复后，13 组独立验证通过。以上不代表系统发现、真实快捷指令运行、既有快捷指令迁移或 SMAppService 实际注册连续性通过。

最终交付第一轮 release 包因权限 probe 仍限定旧可执行名而明确拒绝安装；已由独立窄修 worker 精确允许 Snapclip / Pasto + 原 Bundle ID，保留路径和签名哈希校验，中英各 74 项通过。第二轮最终构建已纳入修复并安装：`snapclip-final-brand-native-25684-20261111-201610/out/install-result.json` passed，389 输入 / 189 manifest、稳定 Development 签名、PID 27677 新路径由主控直接复核。平台 thread limit 阻止创建全新最终部署审计 worker，最终由主控直接自查，不标为全新独立部署审计。完整 Core suite 的旧 / 新 fatal 133 失败仍保留。
