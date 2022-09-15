//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import FHIRQuestionnaires


/// List of example FHIR questionnaires to be rendered as ResearchKit tasks
struct QuestionnaireListView: View {
    @State private var activeQuestionnaire: Questionnaire?
    @State private var presentQuestionnaire = false
    @State private var presentQuestionnaireJSON = false
    @State private var presentQuestionnaireResponses = false
    
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(Questionnaire.allQuestionnaires, id: \.self) { questionnaire in
                        Button(questionnaire.title?.value?.string ?? "Untitled Questionnaire") {
                            activeQuestionnaire = questionnaire
                            presentQuestionnaire = true
                        }
                            .contextMenu {
                                Button {
                                    activeQuestionnaire = questionnaire
                                    presentQuestionnaireJSON = true
                                } label: {
                                    Label("View JSON", systemImage: "doc.badge.gearshape")
                                }

                                Button {
                                    activeQuestionnaire = questionnaire
                                    presentQuestionnaireResponses = true
                                } label: {
                                    Label("View Responses", systemImage: "arrow.right.doc.on.clipboard")
                                }
                            }
                    }
                } header: {
                    Text("QUESTIONNAIRE_LIST_EXAMPLES_HEADER")
                }
            }
                .navigationTitle("QUESTIONNAIRE_LIST_TITLE")
        }
            .sheet(isPresented: $presentQuestionnaire) {
                QuestionnaireView(questionnaire: $activeQuestionnaire)
                    .interactiveDismissDisabled(false)
            }
            .sheet(isPresented: $presentQuestionnaireJSON) {
                QuestionnaireJSONView(questionnaire: $activeQuestionnaire)
            }
            .sheet(isPresented: $presentQuestionnaireResponses) {
                QuestionnaireResponsesView(questionnaire: $activeQuestionnaire)
            }
    }
}


struct QuestionnaireListView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireListView()
    }
}
