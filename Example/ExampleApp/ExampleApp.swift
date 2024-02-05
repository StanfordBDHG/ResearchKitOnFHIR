//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FHIRQuestionnaires
import ResearchKitOnFHIR
import SwiftUI


@main
struct ExampleApp: App {
    @State private var presentQuestionnaire = false
    
    
    var body: some Scene {
        WindowGroup {
            Button("Test") {
                presentQuestionnaire.toggle()
            }
                .sheet(isPresented: $presentQuestionnaire) {
                    QuestionnaireView(questionnaire: .textValidationExample)
                        .environmentObject(QuestionnaireResponseStorage())
                }
//            QuestionnaireListView()
//                .environmentObject(QuestionnaireResponseStorage())
        }
    }
}
