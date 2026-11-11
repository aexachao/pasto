#!/bin/bash
set -euo pipefail
# Canonical Snapclip options take precedence; old PASTO options remain supported.
if [[ -n "${SNAPCLIP_APP_OUTPUT_DIR+x}" ]]; then export PASTO_APP_OUTPUT_DIR="$SNAPCLIP_APP_OUTPUT_DIR"; fi
if [[ -n "${SNAPCLIP_BUILD_ROOT+x}" ]]; then export PASTO_BUILD_ROOT="$SNAPCLIP_BUILD_ROOT"; fi
if [[ -n "${SNAPCLIP_CLOUDKIT_CONTAINER+x}" ]]; then export PASTO_CLOUDKIT_CONTAINER="$SNAPCLIP_CLOUDKIT_CONTAINER"; fi
if [[ -n "${SNAPCLIP_CLOUDKIT_ENVIRONMENT+x}" ]]; then export PASTO_CLOUDKIT_ENVIRONMENT="$SNAPCLIP_CLOUDKIT_ENVIRONMENT"; fi
if [[ -n "${SNAPCLIP_CLOUDKIT_PROFILE+x}" ]]; then export PASTO_CLOUDKIT_PROFILE="$SNAPCLIP_CLOUDKIT_PROFILE"; fi
if [[ -n "${SNAPCLIP_SIGNING_IDENTITY+x}" ]]; then export PASTO_SIGNING_IDENTITY="$SNAPCLIP_SIGNING_IDENTITY"; fi
replica_root="$(cd "$(dirname "$0")/.." && pwd)"
configuration="${1:-release}"
architecture="${2:-universal}"
if [[ -n "${ARTIFACT_TASK_DIR:-}" ]]; then
  scratch_root="${PASTO_BUILD_ROOT:-$ARTIFACT_TASK_DIR/build/swiftpm}"
  output_root="${PASTO_APP_OUTPUT_DIR:-$ARTIFACT_TASK_DIR/out}"
else
  # Preserve the hosted CI layout when storage-guard is not present.
  scratch_root="${PASTO_BUILD_ROOT:-$replica_root/.build}"
  output_root="${PASTO_APP_OUTPUT_DIR:-$replica_root/dist}"
fi
build_sdk_version="$(xcrun --sdk macosx --show-sdk-version)"
if (( ${build_sdk_version%%.*} < 26 )); then
  printf '%s\n' "当前 macOS SDK 为 ${build_sdk_version}；要匹配 macOS 26 的原生控件外观，请使用 Xcode 26 或更新版本构建。" >&2
fi
case "$configuration" in release|debug) ;; *) printf '%s\n' '配置必须为 release 或 debug。' >&2; exit 1 ;; esac
case "$architecture" in native|arm64|x86_64|universal) ;; *) printf '%s\n' '架构必须为 native、arm64、x86_64 或 universal。' >&2; exit 1 ;; esac
version="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["version"])' "$replica_root/../package.json")"
if [[ ! "$version" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)(-dev\.([0-9]+))?$ ]]; then
  printf '%s\n' 'package.json version 必须为 major.minor.patch 或 major.minor.patch-dev.N。' >&2
  exit 1
fi
short_version="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
build_version="$short_version"
if [[ -n "${BASH_REMATCH[5]}" ]]; then
  build_version="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[5]}"
fi
build_architecture() {
  swift build --package-path "$replica_root" -c "$configuration" --jobs 2 \
    --scratch-path "$scratch_root/architectures/$1" --arch "$1"
}
architecture_binary_root() {
  swift build --package-path "$replica_root" -c "$configuration" \
    --scratch-path "$scratch_root/architectures/$1" --arch "$1" --show-bin-path
}
if [[ "$architecture" == native ]]; then
  swift build --package-path "$replica_root" --scratch-path "$scratch_root" -c "$configuration" --jobs 2
  binary_root="$(swift build --package-path "$replica_root" --scratch-path "$scratch_root" -c "$configuration" --show-bin-path)"
elif [[ "$architecture" == universal ]]; then
  build_architecture arm64
  build_architecture x86_64
  binary_root="$(architecture_binary_root arm64)"
  intel_binary_root="$(architecture_binary_root x86_64)"
  diff -rq "$binary_root/Snapclip_SnapclipCore.bundle" "$intel_binary_root/Snapclip_SnapclipCore.bundle"
else
  build_architecture "$architecture"
  binary_root="$(architecture_binary_root "$architecture")"
fi
install_executable() {
  if [[ "$architecture" == universal ]]; then
    lipo -create "$binary_root/$1" "$intel_binary_root/$1" -output "$2"
    lipo "$2" -verify_arch arm64 x86_64
  else
    cp "$binary_root/$1" "$2"
  fi
  install_name_tool -add_rpath "${3:-@executable_path/../Frameworks}" "$2"
}
mkdir -p "$output_root"
staging="$(mktemp -d "$output_root/.snapclip-build.XXXXXX")"
# 清理用 EXIT trap 必须保留真实退出码：bash 3.2 下 `set -e` + ${VAR:?} 中止时，
# trap 里读到的 $? 是 0，只有真正走到脚本末尾（build_complete=1）才算成功。
trap 'rc=$?; rm -rf "$staging"; if [[ "$rc" -eq 0 && "${build_complete:-0}" != 1 ]]; then rc=1; fi; exit "$rc"' EXIT
bundle="$staging/Snapclip.app"
mkdir -p "$bundle/Contents/MacOS" "$bundle/Contents/Resources"
mkdir -p "$bundle/Contents/Frameworks"
# Preserve Sparkle's symlinks, signed helpers, and both architecture slices.
ditto "$binary_root/Sparkle.framework" "$bundle/Contents/Frameworks/Sparkle.framework"
install_executable Snapclip "$bundle/Contents/MacOS/Snapclip"
install_executable snapclip-mcp "$bundle/Contents/MacOS/snapclip-mcp"
codesign --force --sign - "$bundle/Contents/MacOS/snapclip-mcp"
# Transitional command for existing external MCP configurations.
cp "$bundle/Contents/MacOS/snapclip-mcp" "$bundle/Contents/MacOS/pasto-mcp"
cp "$replica_root/Assets/Sparkle-LICENSE.txt" "$bundle/Contents/Resources/Sparkle-LICENSE.txt"
cp "$replica_root/Assets/capcap-LICENSE.txt" "$bundle/Contents/Resources/capcap-LICENSE.txt"
cp "$replica_root/Assets/SnapclipAppIcon.icns" "$bundle/Contents/Resources/SnapclipAppIcon.icns"
ditto "$binary_root/Snapclip_SnapclipCore.bundle" "$bundle/Contents/Resources/Snapclip_SnapclipCore.bundle"
# Fail closed if a stale build reintroduces extracted artwork or language tables.
python3 - "$bundle/Contents/Resources/Snapclip_SnapclipCore.bundle" <<'OWNED_RESOURCES'
from pathlib import Path
import struct, sys
core = Path(sys.argv[1])
files = [p for p in core.rglob("*") if p.is_file()]
illustrations = {
    "SnapclipDirectPaste@2x.png": (384, 256),
    "SnapclipCopyToClipboard@2x.png": (384, 256),
    "SnapclipPermissions@2x.png": (480, 288),
}
for p in files:
    owned_image = p.name in illustrations and p.relative_to(core).parts in {(p.name,), ("GeneratedIllustrations", p.name)}
    assert p.name == "Info.plist" or owned_image or (p.name in {"Localizable.strings", "Localizable.stringsdict"} and p.parent.name.lower() in {"en.lproj", "zh-hans.lproj"}), f"Unexpected Core resource: {p}"
for name, size in illustrations.items():
    matches = [p for p in files if p.name == name]
    assert len(matches) == 1, f"Missing or duplicate owned illustration: {name}"
    header = matches[0].read_bytes()[:24]
    assert header[:8] == b"\x89PNG\r\n\x1a\n" and header[12:16] == b"IHDR" and struct.unpack(">II", header[16:24]) == size, f"Invalid owned illustration: {name}"
for language in ("en", "zh-hans"):
    for name in ("Localizable.strings", "Localizable.stringsdict"):
        assert (core / (language + ".lproj") / name).is_file(), f"Missing owned resource: {language}/{name}"
OWNED_RESOURCES
ditto "$replica_root/Vendor/capcap/Resources/zh-Hans.lproj" "$bundle/Contents/Resources/zh-Hans.lproj"
ditto "$replica_root/Vendor/capcap/Resources/en.lproj" "$bundle/Contents/Resources/en.lproj"
helper="$bundle/Contents/Library/LoginItems/Pasto Helper.app"
mkdir -p "$helper/Contents/MacOS"
install_executable SnapclipHelper "$helper/Contents/MacOS/SnapclipHelper" '@executable_path/../../../../../Frameworks'
cat > "$helper/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleIdentifier</key><string>com.yingyanzhitong.paste-replica.helper</string>
<key>CFBundleName</key><string>Snapclip Helper</string>
<key>CFBundleExecutable</key><string>SnapclipHelper</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>$short_version</string>
<key>CFBundleVersion</key><string>$build_version</string>
<key>PastoSourceVersion</key><string>$version</string>
<key>LSMinimumSystemVersion</key><string>14.0</string>
<key>LSUIElement</key><true/>
<key>NSPrincipalClass</key><string>NSApplication</string>
</dict></plist>
PLIST
plutil -lint "$helper/Contents/Info.plist"
codesign --force --sign - "$helper"
cat > "$bundle/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleIdentifier</key><string>com.yingyanzhitong.paste-replica</string>
<key>CFBundleName</key><string>Snapclip</string>
<key>CFBundleDisplayName</key><string>Snapclip</string>
<key>CFBundleDevelopmentRegion</key><string>en</string>
<key>LSHasLocalizedDisplayName</key><true/>
<key>CFBundleIconFile</key><string>SnapclipAppIcon</string>
<key>CFBundleExecutable</key><string>Snapclip</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>$short_version</string>
<key>CFBundleVersion</key><string>$build_version</string>
<key>PastoSourceVersion</key><string>$version</string>
<key>LSMinimumSystemVersion</key><string>14.0</string>
<key>LSUIElement</key><true/>
<key>NSScreenCaptureUsageDescription</key><string>Snapclip needs screen access to capture a region or display and save it to your history.</string>
<key>NSHighResolutionCapable</key><true/>
<key>NSPrincipalClass</key><string>NSApplication</string>
<key>UIDesignRequiresCompatibility</key><false/>
</dict></plist>
PLIST
plutil -lint "$bundle/Contents/Info.plist"
cat > "$bundle/Contents/Resources/zh-Hans.lproj/InfoPlist.strings" <<'STRINGS'
"CFBundleName" = "闪贴";
"CFBundleDisplayName" = "闪贴";
"NSScreenCaptureUsageDescription" = "闪贴需要读取屏幕内容，用于截取您选择的区域或整个屏幕并保存到历史。";
STRINGS
cat > "$bundle/Contents/Resources/en.lproj/InfoPlist.strings" <<'STRINGS'
"CFBundleName" = "Snapclip";
"CFBundleDisplayName" = "Snapclip";
"NSScreenCaptureUsageDescription" = "Snapclip needs screen access to capture a region or display and save it to your history.";
STRINGS
mkdir -p "$bundle/Contents/Resources/zh-Hant.lproj"
cp "$bundle/Contents/Resources/zh-Hans.lproj/InfoPlist.strings" "$bundle/Contents/Resources/zh-Hant.lproj/InfoPlist.strings"
# Static App Intents metadata resolves in the main bundle, alongside capture localization.
cat >> "$bundle/Contents/Resources/zh-Hans.lproj/Localizable.strings" <<'STRINGS'

"Snapclip" = "闪贴";
"Create Snapclip Item" = "创建闪贴项目";
"Get Snapclip Item at Index" = "获取指定位置的闪贴项目";
"Get Latest Snapclip Item" = "获取最新闪贴项目";
"Snapclip Item Type" = "闪贴项目类型";
"Create Snapclip" = "创建闪贴分组";
STRINGS
plutil -insert SUFeedURL -string 'https://github.com/aexachao/Snapclip/releases/latest/download/appcast.xml' "$bundle/Contents/Info.plist"
plutil -insert SUPublicEDKey -string "$(tr -d '\r\n' < "$replica_root/Assets/UpdatePublicKey.txt")" "$bundle/Contents/Info.plist"
plutil -insert SURequireSignedFeed -bool YES "$bundle/Contents/Info.plist"
plutil -insert SUVerifyUpdateBeforeExtraction -bool YES "$bundle/Contents/Info.plist"
plutil -insert SUEnableAutomaticChecks -bool NO "$bundle/Contents/Info.plist"
plutil -insert SUAutomaticallyUpdate -bool NO "$bundle/Contents/Info.plist"
plutil -insert SUSendProfileInfo -bool NO "$bundle/Contents/Info.plist"
# Use the selected compiler's back-deployment libraries for all bundled executables.
mkdir -p "$bundle/Contents/Frameworks"
xcrun swift-stdlib-tool --copy --scan-folder "$bundle/Contents" --platform macosx \
  --destination "$bundle/Contents/Frameworks" --sign "${PASTO_SIGNING_IDENTITY:--}"
if [[ -n "${PASTO_CLOUDKIT_PROFILE:-}${PASTO_CLOUDKIT_CONTAINER:-}" ]]; then
  : "${PASTO_CLOUDKIT_PROFILE:?需要自有描述文件路径}"
  : "${PASTO_CLOUDKIT_CONTAINER:?需要自有 CloudKit 容器标识}"
  : "${PASTO_SIGNING_IDENTITY:?需要本机有效 Apple 签名身份}"
  python3 "$replica_root/scripts/configure-cloudkit-signing.py" \
    --profile "$PASTO_CLOUDKIT_PROFILE" --bundle "$bundle" --container "$PASTO_CLOUDKIT_CONTAINER" \
    --environment "${PASTO_CLOUDKIT_ENVIRONMENT:-Development}" --output "$staging/cloudkit-entitlements.plist"
  codesign --force --sign "$PASTO_SIGNING_IDENTITY" --entitlements "$staging/cloudkit-entitlements.plist" "$bundle"
else
  # 有身份则用身份签，TCC 授权可跨重建保持；无身份退回 ad-hoc。
  codesign --force --sign "${PASTO_SIGNING_IDENTITY:--}" "$bundle"
fi
codesign --verify --deep --strict "$bundle"
if [[ -e "$output_root/Snapclip.app" ]]; then
  backup="$output_root/backups/$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$backup"
  mv "$output_root/Snapclip.app" "$backup/Snapclip.app"
fi
mv "$bundle" "$output_root/Snapclip.app"
printf '%s\n' "$output_root/Snapclip.app"
build_complete=1
