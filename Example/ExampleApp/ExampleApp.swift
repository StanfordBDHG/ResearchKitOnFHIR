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
    @State private var presentQuestionnaire = false
    @State private var activeQuestionnaire: Questionnaire?

    private let exampleQuestionnaires: [Questionnaire] = [
        .iceCreamExample,
        .emailExample
    ]
    
    var body: some Scene {
        WindowGroup {
            List {
                Section{
                    ForEach(exampleQuestionnaires, id: \.self) { questionnaire in
                        Button(questionnaire.title?.value?.string ?? "Untitled Questionnaire") {
                            activeQuestionnaire = questionnaire
                            presentQuestionnaire = true
                        }
                    }
                } header: {
                    Text("Example FHIR Questionnaires")
                }
            }
            .sheet(isPresented: $presentQuestionnaire) {
                QuestionnaireView(questionnaire: self.$activeQuestionnaire)
            }
        }
    }
}

struct QuestionnaireView: View {
    @Binding var questionnaire: Questionnaire?

    func createTask(questionnaire: Questionnaire) -> ORKNavigableOrderedTask? {
        do {
            return try ORKNavigableOrderedTask(questionnaire: questionnaire)
        } catch {
            print("Error creating task: \(error)")
        }
        return nil
    }

    var body: some View {
        if let activeQuestionnaire = questionnaire,
           let task = createTask(questionnaire: activeQuestionnaire) {
            ORKOrderedTaskView(tasks: task)
        } else {
            Text("ERROR_MESSAGE")
        }
    }
}
