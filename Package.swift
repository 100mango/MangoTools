// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MangoTools",
    platforms: [.iOS("9.0")],
    products: [
        .library(name: "MangoTools", targets: ["MangoTools", "MangoToolsObjC"]),
        .library(name: "MangoToolsObjC", targets: ["MangoToolsObjC"])
    ],
    targets: [
        .target(
            name: "MangoTools",
            path: "Swift",
            // Raw-memory serialization is not a safe, portable storage format.
            // Keep the original file available for existing source consumers.
            exclude: ["StructCoding.swift"],
            sources: ["UIView-Extension.swift"]
        ),
        .target(
            name: "MangoToolsObjC",
            path: ".",
            exclude: [
                "Swift", "Tests", "Documentation", "Scripts", "README.md",
                "HudTools.h", "HudTools.m"
            ],
            sources: [
                " NSString+Tools/NSString+Tools.m",
                "NSDate+Utilities/NSDate+Utilities.m",
                "NSAttributedString+Attributes/NSAttributedString+Attributes.m",
                "UIView+Tools/UILabel+Tools.m",
                "UIView+Tools/UIView+AnimationExtensions.m",
                "UIView+Tools/UIView+Tools.m",
                "MangoLog/MangoLog.m",
                "EXTScope/EXTScope.m"
            ],
            publicHeadersPath: "SwiftPMHeaders",
            linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("CoreText")
            ]
        ),
        .target(
            name: "MangoToolsObjCTestSupport",
            dependencies: ["MangoToolsObjC"],
            path: "Tests/MangoToolsObjCTestSupport",
            publicHeadersPath: "include"
        ),
        .testTarget(
            name: "MangoToolsTests",
            dependencies: ["MangoTools", "MangoToolsObjCTestSupport"],
            path: "Tests/MangoToolsTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
