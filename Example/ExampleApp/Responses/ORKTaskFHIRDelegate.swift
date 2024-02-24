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
            break
        default:
            break
        }
        
        taskViewController.dismiss(animated: true, completion: nil)
    }
}
