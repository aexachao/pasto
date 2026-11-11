# 许可范围与逆向产物说明

当前维护仓库：[aexachao/Snapclip](https://github.com/aexachao/Snapclip)，来自上游 Pasto 的 fork。改名不改变上游作者、研究来源与第三方许可。本仓库尚未发布安装包；更新地址指向自己的 Releases，不将上游附件包装成本项目发布。

## 独立实现

闪贴 / Snapclip（原工程名 Pasto）是依据 Paste 6.6.6（29766850）的静态逆向证据独立编写的 macOS 应用，不隶属于或代表原厂，也不授予对原版应用的修改、付费解锁或再分发许可。原应用版权归 Paste Team ApS 及相关权利人所有；相关商标和依赖组件保留各自权利。

本项目的 [MIT License](LICENSE) 仅适用于有权许可的独立实现源码、独立工具、独立撰写的文档和有来源记录的自制品牌图形与新绘功能插图（见 `branding/SnapclipAssets/PROVENANCE.md` 与 `branding/SnapclipGeneratedAssets/PROVENANCE.md`）。它不表示仓库内所有文件都属于本项目作者，也不替代任何第三方材料的权利或许可条件。

## 不属于本项目 MIT 授权范围的材料

- `decompiled/` 中由原应用机器码恢复的伪代码、汇编及相关原应用片段。
- 从原应用提取的本地化文字、图片或其他素材。研究资源 `Resources/*/Localizable.strings` 与 `Localizable.stringsdict` 中恢复的原版本地化及复数文字属于此类；在独立实现中展示或做品牌适配，不会使原文字变成本项目原创内容。
- 研究资源 `OriginalStackIcons.bundle/Contents/Resources/icon.{file,link,text,unknown}.png` 及各 `@2x.png` 共八张 PNG 是原应用类别图标导出，不适用本项目 MIT 授权。旧说明中的 `Assets.car` 不是本次实际文件格式；导出为 PNG 不改变来源。提取工具和资源包描述文件为独立编写。
- `replica/Sources/SnapclipCore/Resources/OriginalSettingsCopyTo*@2x.png` 为原版设置中粘贴目标插图的深浅色导出，属于原应用素材，不适用本项目 MIT 授权。
- 研究资源 `Resources/PastoOtherApps@2x.png` 的制作与授权记录尚未确认，按原研究资源处理，已从本次 arm64 发行包排除；不能因文件前缀或换名声称获得许可。
- 研究报告或元数据文件中包含的原应用代码片段、原符号和其他恢复材料。独立撰写的分析文字可以适用 MIT，其中嵌入的第三方内容仍保留其原有权利。
- 原应用及工具依赖的二进制、安装包和第三方组件。

仓库收录或引用这些材料不构成对其原有权利的转让，也不自动授予再分发权限。评估、复制或分发混合产物时，应分别审查其中各类材料的许可范围。

## 引入的第三方源码

- `replica/Vendor/capcap/`：capcap（<https://github.com/realskyrin/capcap>）的截图与编辑器模块，以 MIT 许可引入。原始许可证与版权声明保留在同目录的 `LICENSE` 文件中（Copyright (c) 2026 realskyrin）。这些文件不属于本项目的独立实现部分，其权利与许可条件以上游 MIT 条款为准。

## 自有替代资源与发行边界

A2 小尺寸类别模板和插图失图回退由 `branding/SnapclipAssets/SnapclipAssetRenderer.swift` 的独立基本几何绘制。当前 A1 设置说明、A5 通用权限图及主启动图标，按用户确认使用当前内置 `image_gen.imagegen` 从纯文字简报生成；源图、提示词、图层包装和实际工具来源见 `branding/SnapclipGeneratedAssets/PROVENANCE.md`。未向模型提供原 Paste 资源；工具不公开模型 ID，不声称由 gpt-image-2.5 生成，也不将生成过程当作独占权、商标可用性或法律结论。旧主图标 / 几何方案的来源记录保留历史事实，不用于证明新图来源。

自写中英文及四项复数文案见 `branding/SnapclipLocalization/`，其他语言回退英文。当前 `SnapclipCore` 仅处理新自有 `SnapclipResources`：中英表与明确的新生成 PNG；旧 `Resources` 与 `OriginalStackIcons.bundle` 留作研究并由 Package exclude 排除。成功提示音按用户选择使用 macOS 系统自带 Purr，由 `NSSound(named:)` 运行时加载；不将苹果系统音频复制进仓库或应用，不分发原 Copy / Paste 音频，不使用系统 Pop。Purr 是本项目所选的反馈音，不声称 Apple 规定其统一代表成功。源稿审查、音频事件验证与最终包安装分别验收，结果见[替换清单](docs/BRAND_ASSET_REPLACEMENTS.md)和 [TESTING](replica/TESTING.md)。旧研究文件保留来源边界，不因不进入 app 就声称整个公开仓库全部原创。

capcap 的完整 MIT 许可与版权应随发行物提供，Sparkle 及其依赖告知继续保留。原 `LICENSE` 中的 Pasto contributors 版权行保持完整；新品牌不转移原作者、原厂或第三方权利。本轮不宣称完成 Mac App Store sandbox、商店更新通道、隐私声明或审核验收。

## 反编译产物性质

`decompiled/` 中的 `.c` 文件是 REA 调用 Ghidra 从 arm64 机器码生成的 C 风格伪代码，不能视为原始 Swift / Objective-C 源码或可编译工程。自动识别的函数边界、类型、参数和调用关系可能有误，未识别符号以地址命名；工具警告和失败记录保留在研究报告中。

`decompiled/Paste/failures/` 中的 `.s` 文件是两个伪代码生成失败地址的 LLVM 汇编片段，按下一 Ghidra 函数入口切片，不保证覆盖完整语义函数体，也不计作伪代码生成成功。

导出范围仅针对 Ghidra 识别到的本地函数，不表示全部机器码或原始源码已经恢复；`partial`、`unsupported` 等状态表示仍有范围限制。具体研究记录见 [逆向研究说明](docs/REVERSE_ENGINEERING.md) 和 `reports/analysis.md`。这些统计不是闪贴的产品完成率。

## 数据与验证

原静态分析流程读取应用安装包；原始安装包、二进制副本、分析引擎、临时日志和完整 REA Evidence 保存在忽略的 `.local/`，不属于公开发行物。闪贴运行时会处理并在本机保存用户剪贴板内容，这是独立应用的功能，不能与静态分析流程混为一谈。贡献或报告问题时不要提交真实历史、账号、密钥或个人文件。

当前实现尚未完成原版一比一全面验收，跨应用直接粘贴仍未完成验证。MIT 的许可及免责条款不构成任何功能等价性、兼容性或适用性的保证。
