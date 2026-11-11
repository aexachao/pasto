# 闪贴 / Snapclip 品牌与素材替换清单

当前维护仓库为 https://github.com/aexachao/Snapclip，源码版本 1.0.10。帮助与更新源已迁至自己的仓库。本仓库尚无正式安装包，Pages 尚未启用，不将上游 1.0.8 称为本项目下载。main / 标签推送只做发布契约检查，正式发布需配置签名后手动 publish=true。以下旧下载、PID 和验收结果保留为历史，不替代本轮验证；本轮安装已完成：snapclip-1-0-10-native-47618-20261111-223149/out/install-result.json；392 输入、192 文件、版本1.0.10、稳定开发签名与原 DR、备份恢复、新 PID48634 / 12秒启动通过。独立实际部署20项通过：settings-toolbar-repository-independent-49265-20261111-224842/out/deployment-audit.json。官网52链接 / i18n19项163键、未发布下载9项、打包9项、更新源9项及实际发布开关4分支通过；原生更新源测试另列。真实权限、SCK像素、实体听感与旧系统不由安装审计代替。

更新：2026-11-11。产品中文名「闪贴」，英文名「Snapclip」。本清单区分源稿、产品接入、实际包与未来商店工作，不将更名当作来源权利或审核结论。原厂版权、研究来源和第三方许可见 [NOTICE](../NOTICE.md)。不删除 Git 跟踪的研究文件，不抹除历史事实。

## 当前状态

本轮按用户确认使用当前内置图像工具生成新主启动图标、直接粘贴 / 复制到剪贴板 / 权限三张插图。工具未公开模型 ID，不称为 gpt-image-2.5。源图、提示词、分层 source-package、转换和 SHA 记录见 `branding/SnapclipGeneratedAssets/`；A2 独立 20pt 类别模板继续保留，中英独立文案与其他语言回退英文保持。新 Core bundle 只允许中英四表及指定三张生成 PNG（加 Info.plist 共 8 文件）；旧提取图 / 17 语言表 / Stack bundle 仍不随应用发行。生成资源实际 NSImage / 五语言 1998 项与白名单 29 项自验通过；独立资产审计 23 项通过。此前生成素材 arm64 1.0.9 已替换安装（其后本轮 Purr / 浮层修复状态见下段）：392 项产品输入一致，源 / 实际安装 192 条清单一致，Core 8 文件、三图 / 新图标 / 许可 / alias 一致，稳定签名及同 DR；新 PID36628 从最终路径存活。安装证据 `clear-audio-generated-verified-install-36456-20261111-211820/out/install-result.json` 与全新独立部署审计37项通过。此前 20:28 包的 389 / 189 / PID27677 只作历史结果。

截图快捷键两槽已补右侧 ×，清空真正注销、重启保持“未设置”，单项恢复和恢复全部重新启用。成功提示按用户最终选择改用 macOS 自带 Purr，由 `NSSound(named:)` 运行时加载，不复制系统音频、不使用 Pop、原音频或时间节流；Purr 不是 Apple 规定的统一成功音。Purr 静音定向 13 项通过，Glass 与合成音测试属于历史。本轮还修复区域 / 窗口初始快照漏排除 lens / chip：快照前预建具体工具窗口并排除实际 ID，显示时复用，正常设置窗口保留，全屏独立路径未改。原生控制器 / 窗口 ID / 注入快照 provider 定向 183 项通过，不等同于真实 SCK 像素、实体听感或 TCC 验证；联合安装实施自验已通过（`capture-purr-native-43295-20261111-220502/out/install-result.json`）：392 输入 / 192 清单、Core 8 文件、稳定签名 / 同 DR、备份、旧 PID40199 退出与新 PID43722 安装路径存活12秒均核实；最终独立部署审计26项通过（`capture-purr-deployment-independent-43902-20261111-220851/out/audit-final.json`），主控另实际复算输入和安装清单；真实 SCK 像素与听感边界保持。此前 capture 82、中英 settings 各 198、row 182 / reset 和实际 private pasteboard 链结果保留为其历史范围。完整 Core suite 的旧 / 新 fatal 133 保留。此前此轮未提交或发布；当时上游正式下载为 1.0.8，仅作历史记录。

此前 20:28 arm64 1.0.9 品牌包的自制几何图 / 中英表安装已核，389 输入和 189 清单、签名、图标 / 许可 / alias 字节一致；这是此次生成替换前的历史证据，见 `snapclip-final-brand-native-25684-20261111-201610/out/`。此前平台额度限制仅由实施者和主控复核；本轮最终部署审计状态另记，不沿用过去限制或通过结论。

## A · 原研究素材与独立替代

路径以旧工程名记研究来源；工程迁移后的实际路径由 `branding/SnapclipEngineeringMigration.json` 和最终 manifest 复核。原版提取文字和图像不属于本项目 MIT 授权；来源未明的资源按研究材料处理，不以新名字推定原创。

| 项 | 原素材 / 消费范围 | 独立替代与当前验收 |
| --- | --- | --- |
| A1 设置插图 | `Resources/OriginalSettingsCopyTo{App,Clipboard}{Light,Dark}@2x.png` 四张原版设置导出。 | 新生成 `SnapclipDirectPaste@2x.png` 与 `SnapclipCopyToClipboard@2x.png`，384×256 透明图，可用于浅深背景；从纯文字简报生成，源和提示词在 `branding/SnapclipGeneratedAssets/`。此前独立几何图保留为 fallback。旧四图仍排除，生成版源码接入、最终包与实际安装已验。 |
| A2 类别图标 | `OriginalStackIcons.bundle/Contents/Resources/icon.{file,link,text,unknown}.png` 及四张 `@2x.png`，实际共八张 PNG；不是旧 NOTICE 所写的 `Assets.car`。导出工具明确来源于原应用。 | 同 renderer 的折角文档、双环、四行、三点卡片，20/40px 模板。**原创源稿、源码接入及本机包排除旧资源已核**；消费者已改为代码新绘，最终包不含旧 bundle。 |
| A3 普通本地化 | 17 个 `Resources/*.lproj/Localizable.strings`，各 123 键，包含恢复的原文字；品牌替换不会改变来源。 | `branding/SnapclipLocalization/` 独立中英各 123 键，已核动态 key / 占位符。用户明确选择其他界面语言回退英文。**原创源稿、源码接入及本机包排除旧资源已核**；不声称已原创翻译全部 17 语言。 |
| A4 复数本地化 | 同上 17 份 `Localizable.stringsdict`，每份四项：character/line/word/file count。 | 自写中英各四项，保留格式和复数消费合同。**原创源稿、源码接入及本机包排除旧资源已核**；普通表通过不能代替复数验收。 |
| A5 权限拼图 | `Resources/PastoOtherApps@2x.png`，SHA256 `9c5e5ee6b2af9a4fa6cb81982d5aaafe08635ed12ea93f12dd2d3c956c978483`；授权记录不足，按研究资源处理。 | 新生成 `SnapclipPermissions@2x.png`，480×288 透明通用窗口 / 内容卡片，无真实第三方 Logo、文字或锁；旧图仍排除，生成版源码接入、最终包与实际安装已验，不声称旧图已获权。 |
| A6 音效 | 原 `Copy.aiff` / `Paste.aiff` 未随既有包发行；此前缺文件回退系统 Pop。 | 当前按用户最终选择使用 macOS 自带 Purr，运行时按名称加载，不复制苹果音频文件；不读旧音、不用 Pop、无时间节流。此前 75ms 合成音已停用。旧 Pop 单次多声段支持重复听感解释，未证实重复 play；实际 private 链成功各一次 / 失败无声通过，实体听感待确认。 |

新生成源、提示词与包装：`branding/SnapclipGeneratedAssets/PROVENANCE.md`；历史几何与旧图标来源：`branding/SnapclipAssets/PROVENANCE.md`；语言 key / 占位符：`branding/SnapclipLocalization/`。源稿、包内容与法律审查分别记录。

## B · 自有品牌展示

| 项 | 事实、证据与待验边界 |
| --- | --- |
| B1 主图标 | 新生成概念及前景源见 `branding/SnapclipGeneratedAssets/sources/`；六层 source-package（自写蓝渐变 SVG + 五个清理后的位图语义层）经 app-icon-gen 验证 warnings 为空，传统 macOS ICNS1024回读与产品PNG像素一致，网站使用同PNG。实际 ICNS 文件为 `replica/Assets/SnapclipAppIcon.icns`。不声称全矢量或 Icon Composer 分层包；旧 SVG 与早期 paperclip 记录只保留历史，不再作为当前图的来源证据。新图标 PNG / ICNS / 网站字节与实际安装一致，最终安装及独审通过。 |
| B2 旧自制 Pasto 图标 | 原 Pasto PNG/ICNS 是项目旧自制图标，不能与 A2 原提取图标混同。当前主入口改为 Snapclip；不擅删历史跟踪文件。 |
| B3 菜单栏 | `ReplicaBrand` 代码绘制取景框 / 折角卡片；已核 18pt、template、浅深 1x/2x。`Scanclip` 注释已修正为 Snapclip；实际主窗口与菜单表现由安装验收确认。 |
| B4 显示与语言 | AppBrand、关于、权限、设置、InfoPlist 中英展示使用闪贴 / Snapclip。原表运行时替换不能算 A3/A4 原创完成，现已由自写 SnapclipResources 替代；原表留研究源码并排除发行。 |
| B5 MCP / Intents | MCP 可见分组描述和错误已修正、来源标记为 `Snapclip MCP`；协议字段 / 工具名 / schema 不扫词替换。Intent 标题与工程类型兼容分别审计；开发源码已有入口，系统发现、真实快捷指令运行及既有快捷指令迁移未验，正式1.0.8未提供。 |
| B6 README / 官网 | 中英 README 与官网产品品牌统一；favicon、OG、正文图标统一 `snapclip-icon.png`。当前自有仓库尚无安装包，不再把上游 1.0.8 下载当作本项目发布；历史附件来源记录保留。既有演示截图未按最终品牌包重新生成，不将旧图称为本轮最新运行证据。 |

## C · 许可与研究隔离

- **capcap**：保留 `replica/Vendor/capcap/LICENSE` 完整 MIT / Copyright (c) 2026 realskyrin；包内完整告知已接入，最终 manifest 和字节一致性已核，不能改成 Snapclip 作者。
- **Sparkle**：保留框架、Sparkle 及其依赖许可告知；不因品牌迁移改变更新验证公钥或提交私钥。
- **项目 MIT**：`LICENSE` 中 Copyright (c) 2026 Pasto contributors 保留完整。新品牌与新创作范围由 NOTICE/来源记录说明，本轮不重写既有版权行。
- **研究材料**：`decompiled/`、历史分析、原符号、恢复代码和旧提取素材保持研究来源说明，从发行源集隔离；公开仓库与 app 包是不同分发边界。不打进 app 不代表公开研究文件自然取得再分发权。
- **系统与其他 App 图标**：历史卡片运行时显示来源标志用于识别，不因此取得将它们用作自身商标或宣传图的权利；相关使用条件仍需复核。

## D · 兼容保留与工程迁移

工程计划见 `branding/SnapclipEngineeringMigration.md` / `.json`。包名、核心 / helper / MCP 模块、产品和源码目录已实际同步改为 Snapclip 系列，新模块已编译并在旧库隔离副本上读取、保存、重开；**Pasto 主 App 模块暂作 AppIntents 兼容桥**。新 CLI 为 `snapclip-mcp` / `snapclip-core-tests`；旧 `pasto-mcp` alias 与 `PASTO_*` 环境变量保留，新 `SNAPCLIP_*` 优先。核心资源 bundle 为 `Snapclip_SnapclipCore.bundle`。完整 Core suite 在旧 / 新工程均遇 SQLite RAISE ABORT / CoreData fatal（exit 133），不能写全组通过。MCP 定向自验 13/13 与最终包安装分别验收。

以下保留，避免破坏用户数据与旧客户端：

- Bundle ID `com.yingyanzhitong.paste-replica`、helper 标识、`LoginItems/Pasto Helper.app` 服务物理路径、签名 / TCC 边界、旧归档和实体运行时类名。helper 显示名、模块与可执行文件迁移为 SnapclipHelper；服务路径保留是登录项兼容措施。
- 数据目录、`iCloud Drive/Pasto`、`PastoSync-v1`、CloudKit zone / 容器合同及偏好键。用户内容不扫词改写。
- 上游 GitHub / Pages / DMG 地址只作研究与历史来源；当前项目仓库已按用户授权迁至 `aexachao/Snapclip`，自己的 API / appcast 不读取上游。Pages 和正式安装包尚未发布。
- 标准 API `NSPasteboard`、`paste:`、copy/paste 动词、UTType、协议和原厂事实。保留不等于遗漏产品品牌。

## E · 最终包验收与商店专项

新的生成素材 arm64 包与本轮快捷键 / 短音修复已安装并经全新独审：三张生成 PNG、中英表、icon / 许可 / MCP alias、392 输入、192 安装清单、稳定签名 / 同 DR、新进程与独立解压备份均通过。初构建交付 wrapper 旧 bootstrap 引用在安装前失败；第二 guard 重验同签名产物后安装，来源记录如实保留。构建28M + 安装37M 共65M，build / stage 清理，无新设备；Data201GiB。旧库定向兼容已独审；Intents / SMAppService 真实系统运行仍待；新的 Universal 正式发布及商店验收不由本机 arm64 包替代。

Mac App Store 专项尚未实施：App Sandbox、商店签名 / 容器 / 权限、仅商店更新路径、隐私声明和数据收集说明、截图 / Accessibility / helper / MCP 可行性、产品差异化、商标检索与来源权利审查。直接分发 Sparkle 成功不能代替这些验收。

2026-11-11 核对 Apple [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)：2.4.5 涉及 Mac sandbox 与商店更新；4.1 涉及复制品；5.2 涉及内容权利。[macOS 分发说明](https://developer.apple.com/macos/distribution/) 区分 Mac App Store 与站外 Developer ID / notarization。本文只据此列出工程与审查事项，不提供法律结论、零风险或必过审保证。
