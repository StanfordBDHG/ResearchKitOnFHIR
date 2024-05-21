//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FHIRQuestionnaires
import ModelsR4
import ResearchKit
import ResearchKitSwiftUI
import SwiftUI


/// Renders a ResearchKit task from the selected FHIR questionnaire
struct QuestionnaireView: View {
    @Environment(QuestionnaireResponseStorage.self) private var responseStorage
    @Environment(\.dismiss) private var dismiss
    
    @Binding var questionnaire: Questionnaire?
    
    
    var body: some View {
        if let activeQuestionnaire = questionnaire,
           let task = createTask(questionnaire: activeQuestionnaire) {
            ORKOrderedTaskView(tasks: task, result: handleResult)
                .ignoresSafeArea(.container, edges: .bottom)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        } else {
            Text("ERROR_MESSAGE")
        }
    }

    private func handleResult(_ result: TaskResult) {
        defer {
            dismiss()
        }

        guard case let .completed(result) = result else {
            return // user cancelled
        }

        // Convert the ResearchKit task results into FHIR
        let fhirResponse = result.fhirResponse

        // First, we will look for any attachments in the QuestionnaireResponse
        // and move them from their temporary location to a permanent location.
        do {
            // Get the path to the user's documents directory.
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )

            let outputDirectory = documentDirectory.appendingPathComponent(UUID().uuidString)
            try FileManager.default.createDirectory(
                at: outputDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )

            // Search for attachments in the QuestionnaireResponse and move them to the newly created directory.
            if let responseItems = fhirResponse.item {
                for item in responseItems {
                    if case let .attachment(value) = item.answer?.first?.value {
                        guard let fileURL = value.url?.value?.url else {
                            continue
                        }

                        let fileName = fileURL.lastPathComponent
                        let newPath = outputDirectory.appendingPathComponent(fileName)

                        do {
                            try FileManager.default.moveItem(at: fileURL, to: newPath)

                            // Update the item's answer with the new URL.
                            item.answer?.first?.value = .attachment(
                                Attachment(url: newPath.asFHIRURIPrimitive())
                            )
                        } catch {
                            print(error.localizedDescription)
                            continue
                        }
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }

        fhirResponse.subject = Reference(reference: FHIRPrimitive(FHIRString("My Patient")))

        guard let questionnaireIdentifier = fhirResponse.questionnaire?.value?.url else {
            return
        }

        responseStorage.append(fhirResponse, for: questionnaireIdentifier)
    }

    
    /// Creates a ResearchKit navigable task from a FHIR questionnaire
    /// - Parameter questionnaire: a FHIR questionnaire
    /// - Returns: a ResearchKit navigable task
    private func createTask(questionnaire: Questionnaire) -> ORKNavigableOrderedTask? {
        // Create a completion step to add to the end of the Questionnaire (optional)
        let completionStep = ORKCompletionStep(identifier: "completion-step")
        completionStep.text = String(localized: "COMPLETION_STEP_MESSAGE")
        
        // Create a navigable task from the Questionnaire
        do {
            return try ORKNavigableOrderedTask(questionnaire: questionnaire, completionStep: completionStep)
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
