//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ResearchKit
import SwiftUI
import UIKit


struct ORKOrderedTaskView: UIViewControllerRepresentable {
    private let tasks: ORKOrderedTask
    private weak var delegate: ORKTaskViewControllerDelegate
    
    
    /// - Parameters:
    ///   - tasks: The `ORKOrderedTask` that should be displayed by the `ORKTaskViewController`
    ///   - delegate: An `ORKTaskViewControllerDelegate` that handles delegate calls from the `ORKTaskViewController`. If no  view controller delegate is provided the view uses an instance of `CKUploadFHIRTaskViewControllerDelegate`.
    init(tasks: ORKOrderedTask, delegate: ORKTaskViewControllerDelegate) {
        self.tasks = tasks
        self.delegate = delegate
    }
    
    
    func updateUIViewController(_ uiViewController: ORKTaskViewController, context: Context) {}
    
    func makeUIViewController(context: Context) -> ORKTaskViewController {
        // Create a new instance of the view controller and pass in the assigned delegate.
        let viewController = ORKTaskViewController(task: tasks, taskRun: nil)
        viewController.delegate = delegate
        return viewController
    }
}
