//
// This source file is part of the ResearchKitOnFHIR open source project
// 
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import FHIRQuestionnaires
import ResearchKit
@testable import ResearchKitOnFHIR
import XCTest

final class ResearchKitToFHIRTests: XCTestCase {
    private func createStepResult(_ result: ORKResult) -> ORKStepResult {
        let stepResult = ORKStepResult()
        stepResult.results = [result]
        return stepResult
    }

    private func createTaskResult(_ result: ORKResult) -> ORKTaskResult {
        let stepResult = createStepResult(result)
        let taskResult = ORKTaskResult()
        taskResult.results = [stepResult]
        return taskResult
    }

    func testTextResponse() {
        let testValue = "test answer"
        var responseValue: String?

        let textResult = ORKTextQuestionResult()
        textResult.textAnswer = testValue
        let taskResult = createTaskResult(textResult)

        let fhirResponse = taskResult.fhirResponse
        let answer = fhirResponse.item?.first?.answer?.first?.value

        if case let .string(value) = answer,
           let unwrappedValue = value.value?.string {
            responseValue = unwrappedValue
        }
        XCTAssertEqual(testValue, responseValue)
    }

    func testBooleanResponse() {
        let testValue = true
        var responseValue = false

        let booleanResult = ORKBooleanQuestionResult()
        booleanResult.booleanAnswer = NSNumber(true)
        let taskResult = createTaskResult(booleanResult)

        let fhirResponse = taskResult.fhirResponse
        let answer = fhirResponse.item?.first?.answer?.first?.value

        if case let .boolean(value) = answer,
           let unwrappedValue = value.value?.bool {
            responseValue = unwrappedValue
        }
        XCTAssertEqual(testValue, responseValue)
    }

    func testDecimalResponse() {
        let testValue: Decimal = 1.5
        var responseValue: Decimal?

        let numericResult = ORKNumericQuestionResult()
        numericResult.numericAnswer = testValue as NSNumber
        let taskResult = createTaskResult(numericResult)

        let fhirResponse = taskResult.fhirResponse
        let answer = fhirResponse.item?.first?.answer?.first?.value

        if case let .decimal(value) = answer,
           let unwrappedValue = value.value?.decimal {
            responseValue = unwrappedValue
        }
        XCTAssertEqual(testValue, responseValue)
    }

    func testIntegerResponse() {
        let testValue = 1
        var responseValue: Int?

        let numericResult = ORKNumericQuestionResult()
        numericResult.numericAnswer = testValue as NSNumber
        numericResult.questionType = ORKQuestionType.integer
        let taskResult = createTaskResult(numericResult)

        let fhirResponse = taskResult.fhirResponse
        let answer = fhirResponse.item?.first?.answer?.first?.value

        if case let .integer(value) = answer,
           let unwrappedValue = value.value?.integer {
            responseValue = Int(unwrappedValue)
        }
        XCTAssertEqual(testValue, responseValue)
    }

    func testQuantityResponse() {
        let testValue: Decimal = 1.5
        let testUnit = "g"
        var responseValue: Decimal?
        var responseUnit = ""

        let numericResult = ORKNumericQuestionResult()
        numericResult.numericAnswer = testValue as NSNumber
        numericResult.unit = testUnit
        numericResult.questionType = ORKQuestionType.decimal
        let taskResult = createTaskResult(numericResult)

        let fhirResponse = taskResult.fhirResponse
        let answer = fhirResponse.item?.first?.answer?.first?.value

        if case let .quantity(value) = answer,
           let unwrappedValue = value.value?.value?.decimal,
           let unit = value.unit?.value?.string {
            responseValue = unwrappedValue
            responseUnit = unit
        }
        XCTAssertEqual(testValue, responseValue)
        XCTAssertEqual(testUnit, responseUnit)
    }

    func testDateTimeResponse() {
        let testValue = Date()
        var responseValue: Date?

        let dateResult = ORKDateQuestionResult()
        dateResult.dateAnswer = testValue
        let taskResult = createTaskResult(dateResult)

        let fhirResponse = taskResult.fhirResponse
        let answer = fhirResponse.item?.first?.answer?.first?.value

        if case let .dateTime(value) = answer,
           let unwrappedValue = try? value.value?.asNSDate() {
            responseValue = unwrappedValue
        }
        XCTAssertEqual(testValue, responseValue)
    }

    func testTimeResponse() {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        let minute = calendar.component(.minute, from: Date())
        let testValue = DateComponents(hour: hour, minute: minute)
        var responseValue = DateComponents()

        let timeResult = ORKTimeOfDayQuestionResult()
        timeResult.dateComponentsAnswer = testValue
        let taskResult = createTaskResult(timeResult)

        let fhirResponse = taskResult.fhirResponse
        let answer = fhirResponse.item?.first?.answer?.first?.value

        if case let .time(value) = answer,
           let minuteValue = value.value?.minute,
           let hourValue = value.value?.hour {
            responseValue = DateComponents(hour: Int(hourValue), minute: Int(minuteValue))
        }
        XCTAssertEqual(testValue, responseValue)
    }

    func testChoiceResponse() {
        let testValue = ["code": "testCode", "system": "testSystem"]
        var responseValue = [String: String]()

        let choiceResult = ORKChoiceQuestionResult()
        choiceResult.choiceAnswers = [testValue as NSCoding & NSCopying & NSObjectProtocol]
        let taskResult = createTaskResult(choiceResult)

        let fhirResponse = taskResult.fhirResponse
        let answer = fhirResponse.item?.first?.answer?.first?.value

        if case let .coding(value) = answer,
           let code = value.code?.value?.string,
           let system = value.system?.value?.url.absoluteString {
            responseValue = ["code": code, "system": system]
        }
        XCTAssertEqual(testValue, responseValue)
    }
}
