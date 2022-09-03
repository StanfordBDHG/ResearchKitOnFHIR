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
    @State private var presentQuestionnaire = false
    @State private var activeQuestionnaire: Questionnaire?
    
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(Questionnaire.allQuestionnaires, id: \.self) { questionnaire in
                        Button(questionnaire.title?.value?.string ?? "Untitled Questionnaire") {
                            activeQuestionnaire = questionnaire
                            presentQuestionnaire = true
                        }
                    }
                } header: {
                    Text("QUESTIONNAIRE_LIST_EXAMPLES_HEADER")
                }
            }
                .navigationTitle("QUESTIONNAIRE_LIST_TITLE")
        }
            .sheet(isPresented: $presentQuestionnaire) {
                QuestionnaireView(questionnaire: self.$activeQuestionnaire)
            }
    }
}

struct QuestionnaireListView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireListView()
    }
}
