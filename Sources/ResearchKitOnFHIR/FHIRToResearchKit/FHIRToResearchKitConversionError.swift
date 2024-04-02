//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4


/// An error that is thrown when translating a FHIR `Questionnaire` to an `ORKNavigableOrderedTask`
public enum FHIRToResearchKitConversionError: Error, CustomStringConvertible, Equatable {
    /// The parsed FHIR Questionnaire didn't contain any items.
    case noItems
    /// An unsupported operator was used.
    case unsupportedOperator(QuestionnaireItemOperator)
    /// An unsupported answer type was used.
    case unsupportedAnswer(QuestionnaireItemEnableWhen.AnswerX)
    /// No option was provided.
    case noOptions
    /// Encountered an invalid date when parsing the questionnaire.
    case invalidDate(FHIRPrimitive<FHIRDate>)
    
    
    public var description: String {
        switch self {
        case .noItems:
            return "The parsed FHIR Questionnaire didn't contain any items"
        case let .unsupportedOperator(fhirOperator):
            return "An unsupported operator was used: \(fhirOperator)"
        case let .unsupportedAnswer(answer):
            return "An unsupported answer type was used: \(answer)"
        case .noOptions:
            return "No option was provided"
        case let .invalidDate(date):
            return "Encountered an invalid date when parsing the questionnaire: \(date)"
        }
    }
}
