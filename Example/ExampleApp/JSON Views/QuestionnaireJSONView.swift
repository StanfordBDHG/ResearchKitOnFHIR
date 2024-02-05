//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
import SwiftUI


struct QuestionnaireJSONView: View {
    let questionnaire: Questionnaire
    
    
    var body: some View {
        NavigationStack {
            JSONView(
                json: String(jsonFrom: questionnaire)
            )
                .navigationTitle(questionnaire.title?.value?.string ?? String(localized: "QUESTIONNAIRE_DEFAULT_TITLE"))
        }.navigationBarTitleDisplayMode(.inline)
    }
}


struct QuestionnaireJSONView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireJSONView(questionnaire: .textValidationExample)
    }
}
