//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsR4
import ResearchKit
import ResearchKitOnFHIR

class ORKTaskFHIRDelegate: NSObject, ORKTaskViewControllerDelegate, ObservableObject {
    private var responseStorage: QuestionnaireResponseStorage
    
    
    init(_ responseStorage: QuestionnaireResponseStorage) {
        self.responseStorage = responseStorage
    }
    

    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        switch reason {
        case .completed:
            // Convert the ResearchKit task results into FHIR
            let fhirResponse = taskViewController.result.fhirResponse

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

                // Create a directory in the documents directory with the UUID of this task.
                let outputDirectory = documentDirectory.appendingPathComponent(taskViewController.taskRunUUID.uuidString)
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

                try taskViewController.removeTempFiles()
            } catch {
                print(error.localizedDescription)
            }

            fhirResponse.subject = Reference(reference: FHIRPrimitive(FHIRString("My Patient")))
            
            guard let questionnaireIdentifier = fhirResponse.questionnaire?.value?.url else {
                return
            }

            responseStorage.append(fhirResponse, for: questionnaireIdentifier)
        default:
            break
        }
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
