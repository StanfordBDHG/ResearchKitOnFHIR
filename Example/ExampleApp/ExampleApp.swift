//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FHIRQuestionaires
import ResearchKitOnFHIR
import SwiftUI


@main
struct ExampleApp: App {
    @State
    private var presentQuestionaire = false
    
    
    var body: some Scene {
        WindowGroup {
            if let orknavigableOrderedTask = try? ORKNavigableOrderedTask(questionnaire: Questionnaire.iceCreamExample) {
                VStack {
                    Button("START_QUESTIONAIRE") {
                        presentQuestionaire = true
                    }
                        .buttonStyle(.borderedProminent)
                }
                    .sheet(isPresented: $presentQuestionaire) {
                        ORKOrderedTaskView(tasks: orknavigableOrderedTask)
                    }
            } else {
                Text("ERROR_MESSAGE")
                    .multilineTextAlignment(.center)
            }
        }
    }
}
