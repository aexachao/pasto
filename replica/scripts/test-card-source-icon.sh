#!/bin/bash
set -euo pipefail
# Canonical Snapclip options take precedence; old PASTO options remain supported.
if [[ -n "${SNAPCLIP_ICON_REPEAT_COUNT+x}" ]]; then export PASTO_ICON_REPEAT_COUNT="$SNAPCLIP_ICON_REPEAT_COUNT"; fi
if [[ -n "${SNAPCLIP_ICON_RUN_ID+x}" ]]; then export PASTO_ICON_RUN_ID="$SNAPCLIP_ICON_RUN_ID"; fi
if [[ -n "${SNAPCLIP_SKIP_SCREENSHOTS+x}" ]]; then export PASTO_SKIP_SCREENSHOTS="$SNAPCLIP_SKIP_SCREENSHOTS"; fi
: "${ARTIFACT_TASK_DIR:?Run through storage-guard}"
repeat_count="${PASTO_ICON_REPEAT_COUNT:-1}"
case "$repeat_count" in 1|3) ;; *) exit 64 ;; esac
replica_root="$(cd "$(dirname "$0")/.." && pwd)"
export TMPDIR="$ARTIFACT_TASK_DIR/build/tmp"
export CLANG_MODULE_CACHE_PATH="$ARTIFACT_TASK_DIR/build/module-cache"
mkdir -p "$TMPDIR" "$CLANG_MODULE_CACHE_PATH" "$ARTIFACT_TASK_DIR/out"
test_root="$ARTIFACT_TASK_DIR/build/harness"; mkdir -p "$test_root"
source "$replica_root/Tests/Native/build-support.sh"
shasum -a 256 "$replica_root/Sources/Snapclip/UI/PanelViews.swift" "$replica_root/Sources/Snapclip/UI/CardSourceIconPresentation.swift" "$replica_root/Tests/Native/CardSourceIconHarness.swift" "$replica_root/scripts/test-card-source-icon.sh" > "$ARTIFACT_TASK_DIR/out/source-sha256.txt"
prepare_native_test_ui > "$ARTIFACT_TASK_DIR/out/build.log" 2>&1
compile_native_test_harness card-source-icon "$replica_root/Sources/Snapclip/UI/"*.swift "$replica_root/Sources/Snapclip/ICloudDriveSyncController.swift" "$replica_root/Sources/Snapclip/SourceAppColor.swift" "$replica_root/Sources/Snapclip/WindowSharingPolicy.swift" "$replica_root/Sources/Snapclip/BackgroundService.swift" "$replica_root/Tests/Native/CardSourceIconHarness.swift" > "$ARTIFACT_TASK_DIR/out/compile.log" 2>&1
for ((run_id=1;run_id<=repeat_count;run_id++)); do
 run_out="$ARTIFACT_TASK_DIR/out/run-$run_id"; mkdir -p "$run_out"
 skip="${PASTO_SKIP_SCREENSHOTS:-0}"; if ((run_id>1)); then skip=1; fi
 PASTO_ICON_RUN_ID="$run_id" PASTO_SKIP_SCREENSHOTS="$skip" "$test_harness" "$run_out" | tee "$run_out/test.log"
done
