// swift-tools-version:5.5
import PackageDescription
import Foundation

let environment = ProcessInfo.processInfo.environment
let dependency: Package.Dependency
if let localPath = environment["MANGOTOOLS_LOCAL_PATH"] {
    dependency = .package(path: localPath)
} else {
    let version = Version(environment["MANGOTOOLS_VERSION"] ?? "0.1.0")!
    dependency = .package(url: "https://github.com/100mango/MangoTools.git", .exact(version))
}

let package = Package(
    name: "MangoToolsConsumer",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "ConsumerSwift", targets: ["ConsumerSwift"]),
        .library(name: "ConsumerObjC", targets: ["ConsumerObjC"])
    ],
    dependencies: [dependency],
    targets: [
        .target(name: "ConsumerSwift", dependencies: [.product(name: "MangoTools", package: "MangoTools")]),
        .target(name: "ConsumerObjC", dependencies: [.product(name: "MangoToolsObjC", package: "MangoTools")], publicHeadersPath: "include"),
        .testTarget(name: "ConsumerTests", dependencies: ["ConsumerSwift", "ConsumerObjC"])
    ]
)
