//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
@_exported import class ModelsR4.Questionnaire


extension Questionnaire {
    public static var iceCreamExample: Questionnaire = loadQuestionaire(withName: "IceCreamExample")
    
    
    private static func loadQuestionaire(withName name: String) -> Questionnaire {
        guard let resourceURL = Bundle.module.url(forResource: name, withExtension: "json") else {
            fatalError("Could not find the resource \"\(name)\".json in the FHIRQuestionaires Resources folder.")
        }
        
        do {
            let resourceData = try Data(contentsOf: resourceURL)
            return try JSONDecoder().decode(Questionnaire.self, from: resourceData)
        } catch {
            fatalError("Could not decode the FHIR questionnaire named \"\(name)\".json: \(error)")
        }
    }
}
