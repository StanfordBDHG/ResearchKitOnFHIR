// swift-tools-version:5.9

//
// This source file is part of the ResearchKitOnFHIR open source project
// 
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import PackageDescription


let package = Package(
    name: "ResearchKitOnFHIR",
    platforms: [
        .iOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1),
        .macOS(.v12)
    ],
    products: [
        .library(name: "ResearchKitOnFHIR", targets: ["ResearchKitOnFHIR"]),
        .library(name: "FHIRQuestionnaires", targets: ["FHIRQuestionnaires"])
    ],
    dependencies: [
        .package(url: "https://github.com/StanfordBDHG/ResearchKit", .upToNextMinor(from: "2.2.25")),
        .package(url: "https://github.com/apple/FHIRModels.git", .upToNextMinor(from: "0.5.0"))
    ],
    targets: [
        .target(
            name: "ResearchKitOnFHIR",
            dependencies: [
                .product(name: "ResearchKit", package: "ResearchKit"),
                .product(name: "ResearchKitSwiftUI", package: "ResearchKit"),
                .product(name: "ModelsR4", package: "FHIRModels")
            ]
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
            ]
        ),
        .testTarget(
            name: "ResearchKitOnFHIRTests",
            dependencies: [
                .target(name: "ResearchKitOnFHIR"),
                .target(name: "FHIRQuestionnaires")
            ]
        )
    ]
)
