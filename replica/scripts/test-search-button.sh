#!/bin/bash
set -euo pipefail
replica_root="$(cd "$(dirname "$0")/.." && pwd)"
test_root="$(mktemp -d "${TMPDIR:-/tmp}/pasto-search-button.XXXXXX")"
trap 'rm -rf "$test_root"' EXIT
source "$replica_root/Tests/Native/build-support.sh"
prepare_native_test_ui
compile_native_test_harness search-button \
  "$replica_root/Sources/Snapclip/UI/"*.swift \
  "$replica_root/Sources/Snapclip/ICloudDriveSyncController.swift" \
  "$replica_root/Sources/Snapclip/SourceAppColor.swift" \
  "$replica_root/Sources/Snapclip/WindowSharingPolicy.swift" \
  "$replica_root/Sources/Snapclip/BackgroundService.swift" \
  "$replica_root/Tests/Native/SearchButtonHarness.swift"
run_native_test_harness "$@" | tee "$test_root/result.log"
python3 - "$test_root/result.log" <<'PY'
import json
import pathlib
import sys
reports = []
for line in pathlib.Path(sys.argv[1]).read_text().splitlines():
    try:
        reports.append(json.loads(line))
    except json.JSONDecodeError:
        continue
if not reports or reports[-1].get('passed') is not True:
    raise SystemExit('Search harness did not reach its final passing report')
PY
