//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford Biodesign for Digital Health and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
import SwiftUI


struct QuestionnaireJSONView: View {
    @Binding var questionnaire: Questionnaire?
    
    
    var body: some View {
        NavigationStack {
            JSONView(json: questionnaire.flatMap { String(jsonFrom: $0) })
                .navigationTitle(questionnaire?.title?.value?.string ?? String(localized: "QUESTIONNAIRE_DEFAULT_TITLE"))
        }.navigationBarTitleDisplayMode(.inline)
    }
}


struct QuestionnaireJSONView_Previews: PreviewProvider {
    @State private static var questionnaire: Questionnaire? = .textValidationExample
    
    
    static var previews: some View {
        QuestionnaireJSONView(questionnaire: $questionnaire)
    }
}
