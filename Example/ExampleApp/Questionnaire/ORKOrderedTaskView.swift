//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford Biodesign for Digital Health and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ResearchKit
import SwiftUI
import UIKit


struct ORKOrderedTaskView: UIViewControllerRepresentable {
    private let tasks: ORKOrderedTask
    private let tintColor: Color
    // We need to have a non-weak reference here to keep the retain count of the delegate above 0.
    private var delegate: ORKTaskViewControllerDelegate
    private var outputDirectory: URL?
    
    
    /// - Parameters:
    ///   - tasks: The `ORKOrderedTask` that should be displayed by the `ORKTaskViewController`
    ///   - delegate: An `ORKTaskViewControllerDelegate` that handles delegate calls from the `ORKTaskViewController`. If no  view controller delegate is provided the view uses an instance of `CKUploadFHIRTaskViewControllerDelegate`.
    init(
        tasks: ORKOrderedTask,
        delegate: ORKTaskViewControllerDelegate,
        tintColor: Color = Color(UIColor(named: "AccentColor") ?? .tintColor),
        outputDirectory: URL? = nil
    ) {
        self.tasks = tasks
        self.tintColor = tintColor
        self.delegate = delegate
        self.outputDirectory = outputDirectory
    }

    func getTaskOutputDirectory(_ taskViewController: ORKTaskViewController) -> URL? {
        do {
            let defaultFileManager = FileManager.default

            // Identify the documents directory.
            let documentsDirectory = try defaultFileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )

            // Create a directory based on the `taskRunUUID` to store output from the task.
            let outputDirectory = documentsDirectory.appendingPathComponent(
                taskViewController.taskRunUUID.uuidString
            )
            try defaultFileManager.createDirectory(
                at: outputDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )

            return outputDirectory
        } catch let error as NSError {
            print("The output directory for the task with UUID: \(taskViewController.taskRunUUID.uuidString) could not be created. Error: \(error.localizedDescription)")
        }

        return nil
    }
    
    func updateUIViewController(_ uiViewController: ORKTaskViewController, context: Context) {
        uiViewController.view.tintColor = UIColor(tintColor)
    }
    
    func makeUIViewController(context: Context) -> ORKTaskViewController {
        // Create a new instance of the view controller and pass in the assigned delegate.
        let viewController = ORKTaskViewController(task: tasks, taskRun: nil)
        viewController.outputDirectory = outputDirectory ?? getTaskOutputDirectory(viewController)
        viewController.view.tintColor = UIColor(tintColor)
        viewController.delegate = delegate
        return viewController
    }
}
