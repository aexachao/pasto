#!/bin/bash
set -euo pipefail
# Canonical Snapclip options take precedence; old PASTO options remain supported.
if [[ -n "${SNAPCLIP_TEST_CONFIGURATION+x}" ]]; then export PASTO_TEST_CONFIGURATION="$SNAPCLIP_TEST_CONFIGURATION"; fi
replica_root="$(cd "$(dirname "$0")/.." && pwd)"
test_root="$(mktemp -d "${TMPDIR:-/tmp}/pasto-panel-scroll.XXXXXX")"
trap 'rm -rf "$test_root"' EXIT
export PASTO_TEST_CONFIGURATION=release
source "$replica_root/Tests/Native/build-support.sh"
prepare_native_test_core
compile_native_test_harness panel-scroll \
  "$replica_root/Sources/Snapclip/UI/"*.swift \
  "$replica_root/Sources/Snapclip/ICloudDriveSyncController.swift" \
  "$replica_root/Sources/Snapclip/SourceAppColor.swift" \
  "$replica_root/Sources/Snapclip/WindowSharingPolicy.swift" \
  "$replica_root/Sources/Snapclip/BackgroundService.swift" \
  "$replica_root/Tests/Native/PanelScrollHarness.swift"
run_native_test_harness "$@"
