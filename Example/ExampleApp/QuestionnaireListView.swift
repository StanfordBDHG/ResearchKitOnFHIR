//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FHIRQuestionnaires
import SwiftUI


private struct QuestionnaireSection: Hashable, Identifiable {
    var questionnaires: [Questionnaire]
    var header: String
    
    
    var id: String {
        header
    }
}


/// List of example FHIR questionnaires to be rendered as ResearchKit tasks
struct QuestionnaireListView: View {
    private var questionnaireSections: [QuestionnaireSection] = [
        QuestionnaireSection(
            questionnaires: [
                .formExample,
                .formExample,
                .formExample
            ],
            header: String(localized: "QUESTIONNAIRE_LIST_EXAMPLES_HEADER")
        ),
        QuestionnaireSection(
            questionnaires: [
                .formExample,
                .formExample,
                .formExample
            ],
            header: String(localized: "QUESTIONNAIRE_LIST_RESEARCH_EXAMPLES_HEADER")
        )
    ]
    
    var body: some View {
        NavigationStack {
             List {
                ForEach(questionnaireSections) { section in
                     Section {
                        ForEach(section.questionnaires) { questionnaire in
                            QuestionnaireListRow(questionnaire: questionnaire)
                        }
                     } header: {
                        Text(section.header)
                    }
                }
             }
                .navigationTitle("QUESTIONNAIRE_LIST_TITLE")
        }
    }
}


struct QuestionnaireListView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireListView()
    }
}
