//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford Biodesign for Digital Health and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ResearchKit


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
