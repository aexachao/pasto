#!/bin/bash
set -euo pipefail
# Canonical Snapclip options take precedence; old PASTO options remain supported.
if [[ -n "${SNAPCLIP_RETENTION_GRAPH_DIAGNOSTIC+x}" ]]; then export PASTO_RETENTION_GRAPH_DIAGNOSTIC="$SNAPCLIP_RETENTION_GRAPH_DIAGNOSTIC"; fi
if [[ -n "${SNAPCLIP_RETENTION_PERF_BYTES+x}" ]]; then export PASTO_RETENTION_PERF_BYTES="$SNAPCLIP_RETENTION_PERF_BYTES"; fi
if [[ -n "${SNAPCLIP_RETENTION_PERF_DATASET+x}" ]]; then export PASTO_RETENTION_PERF_DATASET="$SNAPCLIP_RETENTION_PERF_DATASET"; fi
if [[ -n "${SNAPCLIP_RETENTION_PERF_ITEMS+x}" ]]; then export PASTO_RETENTION_PERF_ITEMS="$SNAPCLIP_RETENTION_PERF_ITEMS"; fi
if [[ -n "${SNAPCLIP_RETENTION_PERF_VARIANT+x}" ]]; then export PASTO_RETENTION_PERF_VARIANT="$SNAPCLIP_RETENTION_PERF_VARIANT"; fi
if [[ -n "${SNAPCLIP_TEST_CONFIGURATION+x}" ]]; then export PASTO_TEST_CONFIGURATION="$SNAPCLIP_TEST_CONFIGURATION"; fi
if [[ -n "${SNAPCLIP_TEST_SCRATCH_PATH+x}" ]]; then export PASTO_TEST_SCRATCH_PATH="$SNAPCLIP_TEST_SCRATCH_PATH"; fi
: "${ARTIFACT_TASK_DIR:?Run through storage-guard}"
replica_root="$(cd "$(dirname "$0")/.." && pwd)"
shipping_root="$replica_root"
dataset_selector="${PASTO_RETENTION_PERF_DATASET:-all}"
case "$dataset_selector" in all|1024-8mib) ;; *) exit 64 ;; esac
export TMPDIR="$ARTIFACT_TASK_DIR/build/tmp"
export CLANG_MODULE_CACHE_PATH="$ARTIFACT_TASK_DIR/build/module-cache"
export PASTO_TEST_CONFIGURATION=release
mkdir -p "$TMPDIR" "$CLANG_MODULE_CACHE_PATH" "$ARTIFACT_TASK_DIR/out"
shasum -a 256 "$shipping_root/Sources/SnapclipCore/OriginalCloudKitGraph.swift" "$shipping_root/Sources/SnapclipCore/ClipboardStore.swift" "$shipping_root/Sources/SnapclipCore/ClipboardPersistence.swift" "$shipping_root/Sources/SnapclipCore/OriginalPinboardAttributes.swift" "$shipping_root/Sources/Snapclip/UI/HistoryRetentionSaving.swift" "$shipping_root/Sources/Snapclip/UI/AuxiliaryViews.swift" "$shipping_root/Tests/Native/RetentionSavePerformanceHarness.swift" "$shipping_root/scripts/test-retention-save-performance.sh" > "$ARTIFACT_TASK_DIR/out/source-sha256.txt"
python3 - "$shipping_root" "$ARTIFACT_TASK_DIR" <<'PY'
import pathlib,subprocess,hashlib,json,shutil,sys
root,task=map(pathlib.Path,sys.argv[1:]); repo=root.parent
current=(root/'Sources/SnapclipCore/OriginalCloudKitGraph.swift').read_text()
block='''        // Resolve each existing local identity once. Keep the first document in
        // the same values traversal used by the former per-item linear lookup.
        var identities: [String: [UUID: (OriginalCloudRecordID, OriginalCloudKitScope)]] = [:]
        for document in existing {
            guard let local = localID(document), identities[document.type]?[local] == nil else { continue }
            identities[document.type, default: [:]][local] = (document.id, document.scope)
        }
'''
assert current.count(block)==1
restored=current.replace(block,'',1).replace('if let value = identities[type]?[local] { return value }','if let value = existing.first(where: { $0.type == type && localID($0) == local }) { return (value.id, value.scope) }',1)
old=restored
expected='79324b3c6c164d2713c629342de98d15ee691d4fa3a9fa9b26effeddbd6c0d43'
assert hashlib.sha256(old.encode()).hexdigest()==expected,'Only identity indexing may differ from the fixed original baseline'
try: head=subprocess.check_output(['git','show','HEAD:replica/Sources/SnapclipCore/OriginalCloudKitGraph.swift'],cwd=repo,text=True)
except subprocess.CalledProcessError: head=None
baseline=task/'build/baseline-package'; (baseline/'Sources').mkdir(parents=True)
for name in ['SnapclipCore','SnapclipObjC']: shutil.copytree(root/'Sources'/name,baseline/'Sources'/name)
(baseline/'Sources/SnapclipCore/OriginalCloudKitGraph.swift').write_text(old)
(baseline/'Package.swift').write_text('''// swift-tools-version: 5.9
import PackageDescription
let package = Package(name: "Snapclip", defaultLocalization: "en", platforms: [.macOS(.v14)], targets: [
 .target(name: "SnapclipObjC", publicHeadersPath: "include"),
 .target(name: "SnapclipCore", dependencies: ["SnapclipObjC"], resources: [.process("Resources"), .copy("OriginalStackIcons.bundle")])])
''')
capture=old[:old.index('    public struct Projection {')]+'}\n'
capture=capture.replace('public enum OriginalCloudKitGraph {','enum BaselineOriginalCloudKitGraph {',1)
attributes=(root/'Sources/SnapclipCore/OriginalPinboardAttributes.swift').read_text().replace('public enum OriginalPinboardAttributes {','enum BaselinePinboardAttributes {',1)
capture=capture.replace('OriginalPinboardAttributes.', 'BaselinePinboardAttributes.')
capture='import SnapclipCore\nprivate let originalItemDataPayloadKey = "com.pastereplica.internal.rawPasteboardItems"\n'+capture
(task/'build/BaselineCapture.swift').write_text(capture+'\n'+attributes)
(task/'out/baseline-OriginalCloudKitGraph.swift').write_text(old)
(task/'out/source-comparison.json').write_text(json.dumps({'baselineFromExactInverseHunkAndFixedSHA':True,'baselineMatchesHEAD':old==head,'indexedOnlyIdentityChange':True,'buildMode':'release (-O)','syntheticOnly':True,'baselineGraphSHA256':hashlib.sha256(old.encode()).hexdigest(),'indexedGraphSHA256':hashlib.sha256(current.encode()).hexdigest(),'baselinePackage':'Same Core/ObjC sources and resources with original graph; minimal manifest avoids unrelated UI targets','captureClone':'Exact original capture/localID prefix and pinboard attribute helper; enum names renamed, import and internal key literal added'},indent=2))
PY
source "$shipping_root/Tests/Native/build-support.sh"
for variant in baseline indexed; do
 if [[ "$variant" == baseline ]]; then replica_root="$ARTIFACT_TASK_DIR/build/baseline-package"; else replica_root="$shipping_root"; fi
 export PASTO_TEST_SCRATCH_PATH="$ARTIFACT_TASK_DIR/build/swiftpm-$variant"
 test_root="$ARTIFACT_TASK_DIR/build/harness-$variant"
 prepare_native_test_core > "$ARTIFACT_TASK_DIR/out/core-build-$variant.log" 2>&1
 compile_native_test_harness "retention-save-$variant" "$shipping_root/Tests/Native/RetentionSavePerformanceHarness.swift" "$ARTIFACT_TASK_DIR/build/BaselineCapture.swift" > "$ARTIFACT_TASK_DIR/out/compile-$variant.log" 2>&1
 if [[ "${PASTO_RETENTION_GRAPH_DIAGNOSTIC:-0}" == 1 ]]; then
  PASTO_RETENTION_PERF_VARIANT="$variant" "$test_harness" > "$ARTIFACT_TASK_DIR/out/diagnostic.log" 2>&1
  exit 0
 fi
 datasets=(256:8388608 1024:8388608 256:33554432)
 if [[ "$dataset_selector" == 1024-8mib ]]; then datasets=(1024:8388608); fi
 for dataset in "${datasets[@]}"; do
  count="${dataset%:*}"; bytes="${dataset#*:}"
  PASTO_RETENTION_PERF_VARIANT="$variant" PASTO_RETENTION_PERF_ITEMS="$count" PASTO_RETENTION_PERF_BYTES="$bytes" "$test_harness" > "$ARTIFACT_TASK_DIR/out/$variant-$count-$bytes.log" 2>&1
  python3 - "$ARTIFACT_TASK_DIR" "$variant" "$count" "$bytes" <<'PY'
import pathlib,shutil,sys
task=pathlib.Path(sys.argv[1]).resolve(); variant,count,size=sys.argv[2:]
assert variant in ['baseline','indexed'] and count in ['256','1024'] and size in ['8388608','33554432']
for prefix in ['fixture','behavior']:
 p=task/'build'/f'{prefix}-{variant}-{count}-{size}'
 assert p.parent==task/'build' and not p.is_symlink()
 shutil.rmtree(p)
PY
 done
done
python3 - "$ARTIFACT_TASK_DIR/out" "$dataset_selector" <<'PY'
import pathlib,json,statistics,sys
out=pathlib.Path(sys.argv[1]); results=[]
datasets=[(1024,8388608)] if sys.argv[2]=='1024-8mib' else [(256,8388608),(1024,8388608),(256,33554432)]
for count,size in datasets:
 pair={v:json.loads((out/f'{v}-{count}-{size}.json').read_text()) for v in ['baseline','indexed']}
 for cloud in [False,True]:
  values={v:[x['saveSeconds'] for x in pair[v]['measurements'] if x['cloudKitJournal']==cloud] for v in pair}
  results.append({'items':count,'payloadBytes':size,'cloudKitJournal':cloud,'baselineMedianSeconds':statistics.median(values['baseline']),'indexedMedianSeconds':statistics.median(values['indexed']),'samplesPerVariant':len(values['baseline'])})
(out/'comparison.json').write_text(json.dumps({'passed':True,'buildMode':'release (-O)','syntheticOnly':True,'results':results,'checksByDataset':{f'{c}-{b}':{v:json.loads((out/f'{v}-{c}-{b}.json').read_text())['checks'] for v in ['baseline','indexed']} for c,b in datasets}},indent=2))
print((out/'comparison.json').read_text())
PY
