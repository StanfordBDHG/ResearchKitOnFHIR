//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FHIRQuestionnaires
import ResearchKitOnFHIR
import SwiftUI


@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            QuestionnaireListView()
        }
    }
}
