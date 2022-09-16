//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable duplicate_imports
import Foundation
import ModelsR4
@_exported import class ModelsR4.QuestionnaireResponse
import ResearchKit
@_exported import class ResearchKit.ORKTaskResult


extension ORKTaskResult {
    /// Extracts results from a ResearchKit survey task and converts to a FHIR `QuestionnaireResponse`.
    public var fhirResponse: QuestionnaireResponse {
        var questionnaireResponses: [QuestionnaireResponseItem] = []
        let taskResults = self.results as? [ORKStepResult] ?? []
        let questionnaireID = self.identifier // a URL representing the questionnaire answered
        let questionnaireResponseID = UUID().uuidString // a unique identifier for this set of answers
        
        for result in taskResults.compactMap(\.results).flatMap({ $0 }) {
            let response = createResponse(result)
            if response.answer != nil {
                questionnaireResponses.append(response)
            }
        }

        let questionnaireResponse = QuestionnaireResponse(status: FHIRPrimitive(QuestionnaireResponseStatus.completed))
        questionnaireResponse.item = questionnaireResponses
        questionnaireResponse.id = FHIRPrimitive(FHIRString(questionnaireResponseID))
        questionnaireResponse.authored = FHIRPrimitive(try? DateTime(date: Date()))

        if let questionnaireURL = URL(string: questionnaireID) {
            questionnaireResponse.questionnaire = FHIRPrimitive(Canonical(questionnaireURL))
        }

        return questionnaireResponse
    }


    // MARK: Functions for creating FHIR responses from ResearchKit results
    
    private func createResponse(_ result: ORKResult) -> QuestionnaireResponseItem {
        let response = QuestionnaireResponseItem(linkId: FHIRPrimitive(FHIRString(result.identifier)))
        let responseAnswer = QuestionnaireResponseItemAnswer()

        switch result {
        case let result as ORKBooleanQuestionResult:
            responseAnswer.value = createBooleanResponse(result)
        case let result as ORKChoiceQuestionResult:
            responseAnswer.value = createChoiceResponse(result)
        case let result as ORKNumericQuestionResult:
            responseAnswer.value = createNumericResponse(result)
        case let result as ORKDateQuestionResult:
            responseAnswer.value = createDateResponse(result)
        case let result as ORKTextQuestionResult:
            responseAnswer.value = createTextResponse(result)
        default:
            // Unsupported result type
            responseAnswer.value = nil
        }

        response.answer = [responseAnswer]
        return response
    }

    private func createNumericResponse(_ result: ORKNumericQuestionResult) -> QuestionnaireResponseItemAnswer.ValueX? {
        guard let value = result.numericAnswer else {
            return nil
        }

        // If a unit is defined, then the result is a Quantity
        if let unit = result.unit {
            return .quantity(Quantity(unit: FHIRPrimitive(FHIRString(unit)),
                                      value: FHIRPrimitive(FHIRDecimal(value.decimalValue)))
                            )
        }

        if result.questionType == ORKQuestionType.integer {
            return .integer(FHIRPrimitive(FHIRInteger(value.int32Value)))
        } else {
            return .decimal(FHIRPrimitive(FHIRDecimal(value.decimalValue)))
        }
    }

    private func createTextResponse(_ result: ORKTextQuestionResult) -> QuestionnaireResponseItemAnswer.ValueX? {
        guard let text = result.textAnswer else {
            return nil
        }
        return .string(FHIRPrimitive(FHIRString(text)))
    }

    private func createChoiceResponse(_ result: ORKChoiceQuestionResult) -> QuestionnaireResponseItemAnswer.ValueX? {
        guard let answerArray = result.answer as? NSArray,
              answerArray.count > 0, // swiftlint:disable:this empty_count
              let answerDictionary = answerArray[0] as? NSDictionary else {
            return nil
        }

        var codingCode: FHIRPrimitive<FHIRString>?,
            codingDisplay: FHIRPrimitive<FHIRString>?,
            codingId: FHIRPrimitive<FHIRString>?,
            codingSystem: FHIRPrimitive<FHIRURI>?

        if let code = answerDictionary["code"] as? String {
            codingCode = FHIRPrimitive(FHIRString(code))
        }

        if let display = answerDictionary["display"] as? String {
            codingDisplay = FHIRPrimitive(FHIRString(display))
        }

        if let id = answerDictionary["id"] as? String {
            codingId = FHIRPrimitive(FHIRString(id))
        }

        if let system = answerDictionary["system"] as? URL {
            codingSystem = FHIRPrimitive(FHIRURI(system))
        }

        let coding = Coding(
            code: codingCode,
            display: codingDisplay,
            id: codingId,
            system: codingSystem
        )
        return .coding(coding)
    }

    private func createBooleanResponse(_ result: ORKBooleanQuestionResult) -> QuestionnaireResponseItemAnswer.ValueX? {
        guard let booleanAnswer = result.booleanAnswer else {
            return nil
        }
        return .boolean(FHIRPrimitive(FHIRBool(booleanAnswer.boolValue)))
    }

    private func createDateResponse(_ result: ORKDateQuestionResult) -> QuestionnaireResponseItemAnswer.ValueX? {
        guard let dateAnswer = result.dateAnswer else {
            return nil
        }

        if result.questionType == .date {
            let fhirDate = try? FHIRDate(date: dateAnswer)
            let answer = FHIRPrimitive(fhirDate)
            return .date(answer)
        } else {
            let fhirDateTime = try? DateTime(date: dateAnswer)
            let answer = FHIRPrimitive(fhirDateTime)
            return .dateTime(answer)
        }
    }
}
