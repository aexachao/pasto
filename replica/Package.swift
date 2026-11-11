// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Snapclip",
    defaultLocalization: "en",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "SnapclipCore", targets: ["SnapclipCore"]),
        .executable(name: "Snapclip", targets: ["Pasto"]),
        .executable(name: "SnapclipHelper", targets: ["SnapclipHelper"]),
        .executable(name: "snapclip-mcp", targets: ["SnapclipMCP"]),
        .executable(name: "snapclip-core-tests", targets: ["SnapclipCoreTests"])
    ],
    targets: [
        .binaryTarget(name: "Sparkle",
                      url: "https://github.com/sparkle-project/Sparkle/releases/download/2.10.1/Sparkle-for-Swift-Package-Manager.zip",
                      checksum: "4c2e48a3e50ebcc2c88a58a4c7264a1a99c3c31857ce754357afb9cdb323022a"),
        .target(name: "SnapclipObjC", publicHeadersPath: "include"),
        .target(name: "SnapclipCore", dependencies: ["SnapclipObjC"], exclude: ["Resources", "OriginalStackIcons.bundle"], resources: [.process("SnapclipResources")]),
        .executableTarget(name: "Pasto", dependencies: ["SnapclipCore", "SnapclipObjC", "Sparkle", "SnapclipCapture"], path: "Sources/Snapclip"),
        .executableTarget(name: "SnapclipHelper"),
        .target(name: "SnapclipCapture", path: "Vendor/capcap", exclude: ["LICENSE"]),
        .executableTarget(name: "SnapclipMCP", dependencies: ["SnapclipCore"]),
        .executableTarget(name: "SnapclipCoreTests", dependencies: ["SnapclipCore"], path: "Tests/SnapclipCoreTests")
    ]
)
