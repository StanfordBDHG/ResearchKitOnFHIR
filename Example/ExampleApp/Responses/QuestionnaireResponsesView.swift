//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FHIRQuestionnaires
import ModelsR4
import SwiftUI


struct QuestionnaireResponsesView: View {
    @EnvironmentObject private var responseStorage: QuestionnaireResponseStorage
    @Binding var questionnaire: Questionnaire?
    @State private var selection: QuestionnaireResponse?
    
    
    var body: some View {
        NavigationSplitView {
            if responses.isEmpty {
                Text("RESPONSES_LIST_NO_RESPONSES")
            } else {
                List(responses, id: \.self, selection: $selection) { response in
                    NavigationLink(description(for: response), value: response)
                }
            }
        } detail: {
            if let response = selection {
                JSONView(json: String(jsonFrom: response))
            } else {
                Text("RESPONSES_LIST_NO_SELECTION")
            }
        }
            .navigationTitle("RESPONSES_LIST_TITLE")
    }
    
    
    private var responses: [QuestionnaireResponse] {
        guard let url = questionnaire?.url?.value?.url else {
            return []
        }
        
        return responseStorage.responses(for: url)
    }
    
    private func description(for response: QuestionnaireResponse) -> String {
        guard let date = try? response.authored?.value?.asNSDate() else {
            return String(localized: "RESPONSE_DATE_ERROR_MESSAGE")
        }
        return RelativeDateTimeFormatter().localizedString(for: date, relativeTo: Date())
    }
}


struct QuestionnaireResponsesView_Previews: PreviewProvider {
    @State private static var questionnaire: Questionnaire? = .textValidationExample
    
    static var previews: some View {
        QuestionnaireResponsesView(questionnaire: $questionnaire)
    }
}
