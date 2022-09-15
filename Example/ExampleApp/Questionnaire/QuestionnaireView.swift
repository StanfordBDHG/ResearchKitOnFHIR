//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FHIRQuestionnaires
import ModelsR4
import SwiftUI
import ResearchKit


/// Renders a ResearchKit task from the selected FHIR questionnaire
struct QuestionnaireView: View {
    @EnvironmentObject private var responseStorage: QuestionnaireResponseStorage
    @Binding var questionnaire: Questionnaire?
    

    var body: some View {
        if let activeQuestionnaire = questionnaire,
           let task = createTask(questionnaire: activeQuestionnaire) {
            ORKOrderedTaskView(tasks: task, delegate: ORKTaskFHIRDelegate(responseStorage))
        } else {
            Text("ERROR_MESSAGE")
        }
    }
    
    
    /// Creates a ResearchKit navigable task from a FHIR questionnaire
    /// - Parameter questionnaire: a FHIR questionnaire
    /// - Returns: a ResearchKit navigable task
    private func createTask(questionnaire: Questionnaire) -> ORKNavigableOrderedTask? {
        do {
            return try ORKNavigableOrderedTask(questionnaire: questionnaire)
        } catch {
            print("Error creating task: \(error)")
        }
        return nil
    }
}


struct QuestionnaireView_Previews: PreviewProvider {
    @State private static var questionnaire: Questionnaire? = .textValidationExample
    
    
    static var previews: some View {
        QuestionnaireView(questionnaire: $questionnaire)
    }
}
