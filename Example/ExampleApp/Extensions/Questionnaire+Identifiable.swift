//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsR4


extension Questionnaire: Identifiable {
    var identifier: String {
        url?.value?.url.formatted() ?? id?.value?.string ?? title?.value?.string ?? ""
    }
}
