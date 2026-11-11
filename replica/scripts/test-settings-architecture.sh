#!/bin/bash
set -euo pipefail
# Canonical Snapclip options take precedence; old PASTO options remain supported.
if [[ -n "${SNAPCLIP_SETTINGS_REPEAT_COUNT+x}" ]]; then export PASTO_SETTINGS_REPEAT_COUNT="$SNAPCLIP_SETTINGS_REPEAT_COUNT"; fi
if [[ -n "${SNAPCLIP_SETTINGS_RUN_ID+x}" ]]; then export PASTO_SETTINGS_RUN_ID="$SNAPCLIP_SETTINGS_RUN_ID"; fi
if [[ -n "${SNAPCLIP_SKIP_SCREENSHOTS+x}" ]]; then export PASTO_SKIP_SCREENSHOTS="$SNAPCLIP_SKIP_SCREENSHOTS"; fi
: "${ARTIFACT_TASK_DIR:?Run through storage-guard}"
repeat_count="${PASTO_SETTINGS_REPEAT_COUNT:-1}"
case "$repeat_count" in
  1|3) ;;
  *) echo "PASTO_SETTINGS_REPEAT_COUNT must be 1 or 3" >&2; exit 64 ;;
esac
replica_root="$(cd "$(dirname "$0")/.." && pwd)"
export TMPDIR="$ARTIFACT_TASK_DIR/build/tmp"
export CLANG_MODULE_CACHE_PATH="$ARTIFACT_TASK_DIR/build/module-cache"
mkdir -p "$TMPDIR" "$CLANG_MODULE_CACHE_PATH" "$ARTIFACT_TASK_DIR/out"
test_root="$ARTIFACT_TASK_DIR/build/harness"
mkdir -p "$test_root"
source "$replica_root/Tests/Native/build-support.sh"
shasum -a 256 "$replica_root/Sources/Snapclip/UI/OriginalSettingsSplitView.swift" "$replica_root/Sources/Snapclip/UI/ReplicaUIController.swift" "$replica_root/Sources/Snapclip/UI/AuxiliaryViews.swift" "$replica_root/Sources/Snapclip/UI/SettingsCopy.swift" "$replica_root/Sources/Snapclip/UI/PermissionStatusView.swift" "$replica_root/Sources/Snapclip/UI/ScreenshotSettingsCopy.swift" "$replica_root/Sources/Snapclip/UI/CloudKitSyncController.swift" "$replica_root/Sources/Snapclip/UI/OriginalHistoryCapacityControl.swift" "$replica_root/Tests/Native/SettingsArchitectureHarness.swift" "$replica_root/scripts/test-settings-architecture.sh" "$replica_root/Tests/Native/build-support.sh" > "$ARTIFACT_TASK_DIR/out/source-sha256.txt"
prepare_native_test_ui > "$ARTIFACT_TASK_DIR/out/build.log" 2>&1
compile_native_test_harness shortcut-row-restore "$replica_root/Sources/Snapclip/UI/SettingsShortcutRowRestore.swift" "$replica_root/Sources/Snapclip/UI/SettingsCopy.swift" "$replica_root/Sources/Snapclip/UI/ScreenshotSettingsCopy.swift" "$replica_root/Tests/Native/ShortcutRowRestoreHarness.swift" > "$ARTIFACT_TASK_DIR/out/row-compile.log" 2>&1
"$test_harness" | tee "$ARTIFACT_TASK_DIR/out/row-test.log"
compile_native_test_harness settings-architecture "$replica_root/Sources/Snapclip/UI/"*.swift "$replica_root/Sources/Snapclip/ICloudDriveSyncController.swift" "$replica_root/Sources/Snapclip/SourceAppColor.swift" "$replica_root/Sources/Snapclip/WindowSharingPolicy.swift" "$replica_root/Sources/Snapclip/BackgroundService.swift" "$replica_root/Tests/Native/SettingsArchitectureHarness.swift" > "$ARTIFACT_TASK_DIR/out/compile.log" 2>&1
for ((run_id=1; run_id<=repeat_count; run_id++)); do
 run_out="$ARTIFACT_TASK_DIR/out/run-$run_id"
 mkdir -p "$run_out"
 skip_screenshots="${PASTO_SKIP_SCREENSHOTS:-0}"
 if ((run_id > 1)); then skip_screenshots=1; fi
 for language in en zh-Hans; do
  PASTO_SETTINGS_RUN_ID="$run_id" PASTO_SKIP_SCREENSHOTS="$skip_screenshots" \
   "$test_harness" "$run_out" -AppleLanguages "($language)" | tee "$run_out/test-$language.log"
 done
done
compile_native_test_harness settings-shortcut-reset "$replica_root/Sources/Snapclip/UI/SettingsShortcutReset.swift" "$replica_root/Sources/Snapclip/UI/SettingsCopy.swift" "$replica_root/Tests/Native/SettingsShortcutResetHarness.swift" > "$ARTIFACT_TASK_DIR/out/reset-compile.log" 2>&1
"$test_harness" | tee "$ARTIFACT_TASK_DIR/out/reset-test.log"
