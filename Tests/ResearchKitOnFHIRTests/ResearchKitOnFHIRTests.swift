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


final class ResearchKitOnFHIRTests: XCTestCase {
    func testCreateORKNavigableOrderedTask() throws {
        let orknavigableOrderedTask = try ORKNavigableOrderedTask(questionnaire: Questionnaire.skipLogicExample)
        XCTAssert(!orknavigableOrderedTask.steps.isEmpty)
    }

    func testBooleanResponse() {
        let booleanResult = ORKBooleanQuestionResult()
        booleanResult.booleanAnswer = true
        booleanResult.identifier = UUID().uuidString

        let stepResult = ORKStepResult(identifier: UUID().uuidString)
        stepResult.results = [booleanResult as ORKResult]
        let taskResult = ORKTaskResult(identifier: UUID().uuidString)
        taskResult.results = [stepResult]
        let fhirResponse = taskResult.fhirResponse
        let answer = fhirResponse.item?.first?.answer?.first?.value

        if case let .boolean(value) = answer {
            XCTAssertEqual(true, value)
        } else {
            XCTFail()
        }
    }
}
