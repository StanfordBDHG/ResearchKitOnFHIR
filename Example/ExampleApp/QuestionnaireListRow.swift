//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FHIRQuestionnaires
import SwiftUI


struct QuestionnaireListRow: View {
    let questionnaire: Questionnaire
    
    @State private var presentQuestionnaire = false
    @State private var presentQuestionnaireJSON = false
    @State private var presentQuestionnaireResponses = false
    
    
    var body: some View {
        Button(questionnaire.title?.value?.string ?? String(localized: "QUESTIONNAIRE_DEFAULT_TITLE")) {
            presentQuestionnaire = true
        }
            .contextMenu {
                Button {
                    presentQuestionnaireJSON = true
                } label: {
                    Label(
                        String(localized: "QUESTIONNAIRES_VIEW_JSON"),
                        systemImage: "doc.badge.gearshape"
                    )
                }
                Button {
                    presentQuestionnaireResponses = true
                } label: {
                    Label(
                        String(localized: "QUESTIONNAIRES_VIEW_RESPONSES"),
                        systemImage: "arrow.right.doc.on.clipboard"
                    )
                }
            }
            .sheet(isPresented: $presentQuestionnaire) {
                QuestionnaireView(questionnaire: questionnaire)
                    .interactiveDismissDisabled(true)
            }
            .sheet(isPresented: $presentQuestionnaireJSON) {
                QuestionnaireJSONView(questionnaire: questionnaire)
            }
            .sheet(isPresented: $presentQuestionnaireResponses) {
                QuestionnaireResponsesView(questionnaire: questionnaire)
            }
    }
}
