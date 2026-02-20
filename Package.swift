// swift-tools-version:6.0

//
// This source file is part of the ResearchKitOnFHIR open source project
// 
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import class Foundation.ProcessInfo
import PackageDescription


let package = Package(
    name: "ResearchKitOnFHIR",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1),
        .macOS(.v14)
    ],
    products: [
        .library(name: "ResearchKitOnFHIR", targets: ["ResearchKitOnFHIR"])
    ],
    dependencies: [
        .package(url: "https://github.com/StanfordBDHG/ResearchKit.git", .upToNextMinor(from: "3.1.1")),
        .package(url: "https://github.com/apple/FHIRModels.git", from: "0.7.0"),
        .package(url: "https://github.com/StanfordBDHG/FHIRModelsExtensions.git", revision: "da8a582df550bcbcaf61a8922cb6b928efe0fb36")
    ] + swiftLintPackage(),
    targets: [
        .target(
            name: "ResearchKitOnFHIR",
            dependencies: [
                .product(name: "ResearchKit", package: "ResearchKit"),
                .product(name: "ResearchKitSwiftUI", package: "ResearchKit"),
                .product(name: "ModelsR4", package: "FHIRModels"),
                .product(name: "FHIRModelsExtensions", package: "FHIRModelsExtensions"),
                .product(name: "FHIRPathParser", package: "FHIRModelsExtensions")
            ],
            plugins: [] + swiftLintPlugin()
        ),
        .testTarget(
            name: "ResearchKitOnFHIRTests",
            dependencies: [
                "ResearchKitOnFHIR",
                .product(name: "FHIRQuestionnaires", package: "FHIRModelsExtensions")
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
        [.package(url: "https://github.com/realm/SwiftLint.git", from: "0.55.1")]
    } else {
        []
    }
}
