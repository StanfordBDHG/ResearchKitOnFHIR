//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
import SwiftUI


class QuestionnaireResponseStorage: ObservableObject {
    @Published
    private var responses: [URL: [QuestionnaireResponse]] = [:]
    
    
    func append(_ response: QuestionnaireResponse, for identifier: URL) {
        responses[identifier, default: []].append(response)
    }
    
    func responses(for identifier: URL) -> [QuestionnaireResponse] {
        responses[identifier, default: []]
    }
}
