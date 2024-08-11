// swift-tools-version:5.9

//
// This source file is part of the ResearchKitOnFHIR open source project
// 
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import class Foundation.ProcessInfo
import PackageDescription


#if swift(<6)
let swiftConcurrency: SwiftSetting = .enableExperimentalFeature("StrictConcurrency")
#else
let swiftConcurrency: SwiftSetting = .enableUpcomingFeature("StrictConcurrency")
#endif


let package = Package(
    name: "ResearchKitOnFHIR",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1),
        .macOS(.v14)
    ],
    products: [
        .library(name: "ResearchKitOnFHIR", targets: ["ResearchKitOnFHIR"]),
        .library(name: "FHIRQuestionnaires", targets: ["FHIRQuestionnaires"])
    ],
    dependencies: [
        .package(url: "https://github.com/StanfordBDHG/ResearchKit", .upToNextMinor(from: "3.0.1")),
        .package(url: "https://github.com/apple/FHIRModels.git", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/antlr/antlr4", from: "4.13.1")
    ] + swiftLintPackage(),
    targets: [
        .target(
            name: "ResearchKitOnFHIR",
            dependencies: [
                .product(name: "ResearchKit", package: "ResearchKit"),
                .product(name: "ResearchKitSwiftUI", package: "ResearchKit"),
                .product(name: "ModelsR4", package: "FHIRModels"),
                .target(name: "FHIRPathParser")
            ],
            swiftSettings: [
                swiftConcurrency
            ],
            plugins: [] + swiftLintPlugin()
        ),
        .target(
            name: "FHIRQuestionnaires",
            dependencies: [
                .product(name: "ModelsR4", package: "FHIRModels")
            ],
            resources: [
                .copy("Resources/SkipLogicExample.json"),
                .copy("Resources/TextValidationExample.json"),
                .copy("Resources/ContainedValueSetExample.json"),
                .copy("Resources/NumberExample.json"),
                .copy("Resources/DateTimeExample.json"),
                .copy("Resources/PHQ-9.json"),
                .copy("Resources/GAD-7.json"),
                .copy("Resources/GCS.json"),
                .copy("Resources/IPSS.json"),
                .copy("Resources/FormExample.json"),
                .copy("Resources/MultipleEnableWhen.json"),
                .copy("Resources/ImageCapture.json"),
                .copy("Resources/SliderExample.json")
            ],
            swiftSettings: [
                swiftConcurrency
            ],
            plugins: [] + swiftLintPlugin()
        ),
        .target(
            name: "FHIRPathParser",
            dependencies: [
                .product(name: "Antlr4", package: "antlr4")
            ],
            exclude: [
                "ANTLUtils"
            ],
            swiftSettings: [
                swiftConcurrency
            ],
            plugins: [] + swiftLintPlugin()
        ),
        .testTarget(
            name: "ResearchKitOnFHIRTests",
            dependencies: [
                .target(name: "ResearchKitOnFHIR"),
                .target(name: "FHIRQuestionnaires")
            ],
            swiftSettings: [
                swiftConcurrency
            ],
            plugins: [] + swiftLintPlugin()
        ),
        .testTarget(
            name: "FHIRPathParserTests",
            dependencies: [
                .target(name: "FHIRPathParser")
            ],
            swiftSettings: [
                swiftConcurrency
            ],
            plugins: [] + swiftLintPlugin()
        )
    ]
)


func swiftLintPlugin() -> [Target.PluginUsage] {
    // Fully quit Xcode and open again with `open --env SPEZI_DEVELOPMENT_SWIFTLINT /Applications/Xcode.app`
    if ProcessInfo.processInfo.environment["SPEZI_DEVELOPMENT_SWIFTLINT"] != nil {
        [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
    } else {
        []
    }
}

func swiftLintPackage() -> [PackageDescription.Package.Dependency] {
    if ProcessInfo.processInfo.environment["SPEZI_DEVELOPMENT_SWIFTLINT"] != nil {
        [.package(url: "https://github.com/realm/SwiftLint.git", .upToNextMinor(from: "0.55.1"))]
    } else {
        []
    }
}
