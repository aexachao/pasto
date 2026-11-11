#!/bin/bash
set -euo pipefail
# Canonical Snapclip options take precedence; old PASTO options remain supported.
if [[ -n "${SNAPCLIP_TEST_CONFIGURATION+x}" ]]; then export PASTO_TEST_CONFIGURATION="$SNAPCLIP_TEST_CONFIGURATION"; fi
if [[ -n "${SNAPCLIP_TEST_SCRATCH_PATH+x}" ]]; then export PASTO_TEST_SCRATCH_PATH="$SNAPCLIP_TEST_SCRATCH_PATH"; fi
replica_root="$(cd "$(dirname "$0")/.." && pwd)"
test_root="$(mktemp -d "${TMPDIR:-/tmp}/pasto-copy-restore.XXXXXX")"
trap 'rm -rf "$test_root"' EXIT
export PASTO_TEST_CONFIGURATION=release
export PASTO_TEST_SCRATCH_PATH="${PASTO_TEST_SCRATCH_PATH:-$replica_root/.build/copy-restore-regression}"
source "$replica_root/Tests/Native/build-support.sh"
prepare_native_test_core
compile_native_test_harness copy-restore \
  "$replica_root/Sources/Snapclip/UI/"*.swift \
  "$replica_root/Sources/Snapclip/ICloudDriveSyncController.swift" \
  "$replica_root/Sources/Snapclip/SourceAppColor.swift" \
  "$replica_root/Sources/Snapclip/WindowSharingPolicy.swift" \
  "$replica_root/Sources/Snapclip/BackgroundService.swift" \
  "$replica_root/Tests/Native/CopyRestoreHarness.swift"
run_native_test_harness "$@"
