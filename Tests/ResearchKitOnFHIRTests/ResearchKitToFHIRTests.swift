//
// This source file is part of the ResearchKitOnFHIR open source project
// 
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import FHIRQuestionnaires
@testable import ResearchKitOnFHIR
import ResearchKit
import XCTest

final class ResearchKitToFHIRTests: XCTestCase {
    func testTextResponse() {
        let testValue = "test answer"
        var responseValue: String?

        let textResult = ORKTextQuestionResult()
        textResult.textAnswer = testValue

        let stepResult = ORKStepResult()
        stepResult.results = [textResult]

        let taskResult = ORKTaskResult()
        taskResult.results = [stepResult]

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

        let stepResult = ORKStepResult()
        stepResult.results = [booleanResult]

        let taskResult = ORKTaskResult()
        taskResult.results = [stepResult]

        let fhirResponse = taskResult.fhirResponse
        let answer = fhirResponse.item?.first?.answer?.first?.value

        if case let .boolean(value) = answer,
           let unwrappedValue = value.value?.bool {
            responseValue = unwrappedValue
        }
        XCTAssertEqual(testValue, responseValue)
    }

    func testNumericResponse() {
        let testValue: Decimal = 1.5
        var responseValue: Decimal?

        let numericResult = ORKNumericQuestionResult()
        numericResult.numericAnswer = testValue as NSNumber

        let stepResult = ORKStepResult()
        stepResult.results = [numericResult]

        let taskResult = ORKTaskResult()
        taskResult.results = [stepResult]

        let fhirResponse = taskResult.fhirResponse
        let answer = fhirResponse.item?.first?.answer?.first?.value

        if case let .decimal(value) = answer,
           let unwrappedValue = value.value?.decimal {
            responseValue = unwrappedValue
        }
        XCTAssertEqual(testValue, responseValue)
    }

    func testDateTimeResponse() {
        let testValue = Date()
        var responseValue: Date?

        let dateResult = ORKDateQuestionResult()
        dateResult.dateAnswer = testValue

        let stepResult = ORKStepResult()
        stepResult.results = [dateResult]

        let taskResult = ORKTaskResult()
        taskResult.results = [stepResult]

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
        var testValue = DateComponents(hour: hour, minute: minute)
        var responseValue = DateComponents()

        let timeResult = ORKTimeOfDayQuestionResult()
        timeResult.dateComponentsAnswer = testValue

        let stepResult = ORKStepResult()
        stepResult.results = [timeResult]

        let taskResult = ORKTaskResult()
        taskResult.results = [stepResult]

        let fhirResponse = taskResult.fhirResponse
        let answer = fhirResponse.item?.first?.answer?.first?.value

        if case let .time(value) = answer,
           let minuteValue = value.value?.minute,
           let hourValue = value.value?.hour {
            responseValue = DateComponents(hour: Int(hourValue), minute: Int(minuteValue))
        }
        XCTAssertEqual(testValue, responseValue)
    }
}
