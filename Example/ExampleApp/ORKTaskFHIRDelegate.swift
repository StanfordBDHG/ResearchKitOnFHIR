//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsR4
import ResearchKit
import ResearchKitOnFHIR


class ORKTaskFHIRDelegate: NSObject, ORKTaskViewControllerDelegate, ObservableObject {
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        switch reason {
        case .completed:
            let fhirResponses = taskViewController.result.fhirResponses
            fhirResponses.subject = Reference(reference: FHIRPrimitive(FHIRString("My Patient")))

            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            let data = try! encoder.encode(fhirResponses)
            print(String(decoding: data, as: UTF8.self))
        default:
            break
        }
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
