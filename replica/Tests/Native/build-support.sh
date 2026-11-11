#!/bin/bash
# Canonical Snapclip options take precedence; old PASTO options remain supported.
if [[ -n "${SNAPCLIP_TEST_ARCHITECTURE+x}" ]]; then export PASTO_TEST_ARCHITECTURE="$SNAPCLIP_TEST_ARCHITECTURE"; fi
if [[ -n "${SNAPCLIP_TEST_CONFIGURATION+x}" ]]; then export PASTO_TEST_CONFIGURATION="$SNAPCLIP_TEST_CONFIGURATION"; fi
if [[ -n "${SNAPCLIP_TEST_SCRATCH_PATH+x}" ]]; then export PASTO_TEST_SCRATCH_PATH="$SNAPCLIP_TEST_SCRATCH_PATH"; fi
# Test-only module linking. Uses an independent scratch directory and an isolated bundle ID.
prepare_native_test_core() {
  if [[ -n "${ARTIFACT_TASK_DIR:-}" ]]; then
    test_build_root="${PASTO_TEST_SCRATCH_PATH:-$ARTIFACT_TASK_DIR/build/swiftpm}"
  else
    test_build_root="${PASTO_TEST_SCRATCH_PATH:-$replica_root/.build/native-regression}"
  fi
  test_configuration="${PASTO_TEST_CONFIGURATION:-debug}"
  test_architecture="${PASTO_TEST_ARCHITECTURE:-$(uname -m)}"
  swift build --package-path "$replica_root" --scratch-path "$test_build_root" \
    -c "$test_configuration" --arch "$test_architecture" --target SnapclipCore -j 4 >&2
  binary_root="$(swift build --package-path "$replica_root" --scratch-path "$test_build_root" -c "$test_configuration" --arch "$test_architecture" --show-bin-path)"
}

prepare_native_test_ui() {
  prepare_native_test_core
  swift build --package-path "$replica_root" --scratch-path "$test_build_root" \
    -c "$test_configuration" --arch "$test_architecture" --target SnapclipCapture -j 4 >&2
  test_with_capture=1
}

compile_native_test_harness() {
  local name="$1"
  shift
  local app="$test_root/$name.app"
  mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
  cat > "$app/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict><key>CFBundleIdentifier</key><string>local.pasto.regression.$name.$(uuidgen)</string><key>CFBundleExecutable</key><string>harness</string><key>CFBundleName</key><string>$name</string><key>CFBundlePackageType</key><string>APPL</string><key>LSUIElement</key><true/><key>UIDesignRequiresCompatibility</key><false/></dict></plist>
PLIST
  cp -R "$binary_root/Snapclip_SnapclipCore.bundle" "$app/Contents/Resources/"
  local optimization=-Onone
  if [[ "${PASTO_TEST_CONFIGURATION:-debug}" == release ]]; then optimization=-O; fi
  local extra_objects=("$binary_root/SnapclipCore.build/"*.o "$binary_root/SnapclipObjC.build/"*.o)
  local extra_flags=(-I "$binary_root/Modules")
  if [[ "${PASTO_TEST_CONFIGURATION:-debug}" == release ]]; then
    extra_flags+=(-whole-module-optimization)
  fi
  if [[ "${test_with_capture:-0}" == 1 ]]; then
    extra_objects+=("$binary_root/SnapclipCapture.build/"*.o)
    local sparkle_root="$test_build_root/artifacts/replica/Sparkle/Sparkle.xcframework/macos-arm64_x86_64"
    extra_flags+=(-F "$sparkle_root" -framework Sparkle -Xlinker -rpath -Xlinker "$sparkle_root")
    ditto "$replica_root/Vendor/capcap/Resources/zh-Hans.lproj" "$app/Contents/Resources/zh-Hans.lproj"
    ditto "$replica_root/Vendor/capcap/Resources/en.lproj" "$app/Contents/Resources/en.lproj"
  fi
  xcrun swiftc -parse-as-library -swift-version 5 -target "$test_architecture-apple-macosx14.0" \
    -module-cache-path "${CLANG_MODULE_CACHE_PATH:-$test_build_root/module-cache}" \
    "$optimization" \
    -I "$binary_root/SnapclipObjC.build" \
    -Xcc "-fmodule-map-file=$replica_root/Sources/SnapclipObjC/include/module.modulemap" \
    -Xcc "-I$replica_root/Sources/SnapclipObjC/include" \
    "${extra_flags[@]}" "$@" "${extra_objects[@]}" \
    -o "$app/Contents/MacOS/harness"
  test_harness="$app/Contents/MacOS/harness"
}

run_native_test_harness() {
  if [[ $# -gt 0 ]]; then
    local result=0
    "$test_harness" > "$1" || result=$?
    cat "$1"
    return "$result"
  fi
  "$test_harness"
}
