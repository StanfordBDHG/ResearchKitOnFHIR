//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import ResearchKit
import ModelsR4

/// Renders a ResearchKit task from the selected FHIR questionnaire
struct QuestionnaireView: View {
    @Binding var questionnaire: Questionnaire?

    /// Creates a ResearchKit navigable task from a FHIR questionnaire
    /// - Parameter questionnaire: a FHIR questionnaire
    /// - Returns: a ResearchKit navigable task
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
