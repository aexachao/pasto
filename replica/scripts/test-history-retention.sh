#!/bin/bash
set -euo pipefail
# Canonical Snapclip options take precedence; old PASTO options remain supported.
if [[ -n "${SNAPCLIP_RETENTION_REPEAT_COUNT+x}" ]]; then export PASTO_RETENTION_REPEAT_COUNT="$SNAPCLIP_RETENTION_REPEAT_COUNT"; fi
if [[ -n "${SNAPCLIP_RETENTION_RUN_ID+x}" ]]; then export PASTO_RETENTION_RUN_ID="$SNAPCLIP_RETENTION_RUN_ID"; fi
if [[ -n "${SNAPCLIP_SKIP_SCREENSHOTS+x}" ]]; then export PASTO_SKIP_SCREENSHOTS="$SNAPCLIP_SKIP_SCREENSHOTS"; fi
: "${ARTIFACT_TASK_DIR:?Run via storage-guard}"
repeat_count="${PASTO_RETENTION_REPEAT_COUNT:-1}"
case "$repeat_count" in 1|3) ;; *) exit 64 ;; esac
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPLICA_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
mkdir -p "$ARTIFACT_TASK_DIR/build/module-cache" "$ARTIFACT_TASK_DIR/build/tmp" "$ARTIFACT_TASK_DIR/out"
export TMPDIR="$ARTIFACT_TASK_DIR/build/tmp"
test_app="$ARTIFACT_TASK_DIR/build/HistoryRetentionHarness.app"
mkdir -p "$test_app/Contents/MacOS" "$test_app/Contents/Resources"
cp "$REPLICA_DIR/Assets/SnapclipAppIcon.icns" "$test_app/Contents/Resources/SnapclipAppIcon.icns"
cat > "$test_app/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleIdentifier</key><string>local.pasto.history-retention.$(uuidgen)</string>
<key>CFBundleExecutable</key><string>harness</string>
<key>CFBundleName</key><string>History Retention Test</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleIconFile</key><string>SnapclipAppIcon.icns</string>
<key>LSUIElement</key><true/>
<key>UIDesignRequiresCompatibility</key><false/>
</dict></plist>
PLIST
SOURCES=("$REPLICA_DIR/Sources/Snapclip/UI/OriginalHistoryCapacityControl.swift" "$REPLICA_DIR/Sources/Snapclip/UI/HistoryRetentionCopy.swift" "$REPLICA_DIR/Sources/Snapclip/UI/HistoryRetentionSaving.swift" "$REPLICA_DIR/Tests/Native/HistoryRetentionHarness.swift")
shasum -a 256 "${SOURCES[@]}" "$REPLICA_DIR/Sources/Snapclip/UI/AuxiliaryViews.swift" "$REPLICA_DIR/Assets/SnapclipAppIcon.icns" "$0" > "$ARTIFACT_TASK_DIR/out/source-sha256.txt"
xcrun swiftc -parse-as-library -swift-version 5 -target "$(uname -m)-apple-macosx14.0" -module-cache-path "$ARTIFACT_TASK_DIR/build/module-cache" "${SOURCES[@]}" -o "$test_app/Contents/MacOS/harness" 2>&1 | tee "$ARTIFACT_TASK_DIR/out/compile.log"
for ((run=1;run<=repeat_count;run++)); do
 out="$ARTIFACT_TASK_DIR/out/run-$run"; mkdir -p "$out"
 skip="${PASTO_SKIP_SCREENSHOTS:-0}"; if ((run > 1)); then skip=1; fi
 for language in en zh-Hans; do
  PASTO_RETENTION_RUN_ID="$run" PASTO_SKIP_SCREENSHOTS="$skip" "$test_app/Contents/MacOS/harness" "$out" -AppleLanguages "($language)" 2>&1 | tee "$out/test-$language.log"
 done
done
xcrun swiftc -frontend -parse "$REPLICA_DIR/Sources/Snapclip/UI/AuxiliaryViews.swift" 2>&1 | tee "$ARTIFACT_TASK_DIR/out/auxiliary-parse.log"
