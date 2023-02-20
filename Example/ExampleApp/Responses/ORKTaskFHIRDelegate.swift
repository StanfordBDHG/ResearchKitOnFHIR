//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford Biodesign for Digital Health and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsR4
import ResearchKit
import ResearchKitOnFHIR

enum TaskFileError: Error {
    case noOutputDirectory
}

extension ORKTaskViewController {
    /// Removes all files created by the task
    func removeTempFiles() throws {
        guard let outputDirectory else {
            throw TaskFileError.noOutputDirectory
        }
        try FileManager.default.removeItem(at: outputDirectory)
    }
}

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
                // Get the path to the user's documents directory
                // where we will store the files.
                let documentDirectory = try FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                )

                // Create a directory in the documents directory
                // with the UUID of this task.
                let outputDirectory = documentDirectory.appendingPathComponent(
                    taskViewController.taskRunUUID.uuidString
                )
                try FileManager.default.createDirectory(
                    at: outputDirectory,
                    withIntermediateDirectories: true,
                    attributes: nil
                )

                // Search for attachments in the QuestionnaireResponse
                // and move them to the newly created directory.
                if let responseItems = fhirResponse.item {
                    for item in responseItems {
                        if case let .attachment(value) = item.answer?.first?.value {
                            guard let fileURL = value.url?.value?.url else {
                                continue
                            }

                            let fileName = fileURL.lastPathComponent
                            let newPath = outputDirectory.appendingPathComponent(fileName)

                            try? FileManager.default.moveItem(
                                at: fileURL,
                                to: newPath
                            )

                            // Update the item's answer with the new URL.
                            item.answer?.first?.value = .attachment(
                                Attachment(
                                    url: newPath.asFHIRURIPrimitive()
                                )
                            )
                        }

                    }
                }

                // Clear out temporary files.
                try taskViewController.removeTempFiles()

            } catch let error as NSError {
                print(error.localizedDescription)
            }

            // Set the subject of the QuestionnaireResponse to a sample patient.
            fhirResponse.subject = Reference(reference: FHIRPrimitive(FHIRString("My Patient")))
            
            guard let questionnaireIdentifier = fhirResponse.questionnaire?.value?.url else {
                return
            }

            // Store the QuestionnaireResponse locally.
            responseStorage.append(fhirResponse, for: questionnaireIdentifier)
        default:
            break
        }
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
