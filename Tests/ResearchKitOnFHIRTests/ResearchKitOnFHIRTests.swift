//
// This source file is part of the ResearchKitOnFHIR open source project
// 
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import FHIRQuestionnaires
@testable import ResearchKitOnFHIR
import XCTest


final class ResearchKitOnFHIRTests: XCTestCase {
    func testCreateORKNavigableOrderedTask() throws {
        let orknavigableOrderedTask = try ORKNavigableOrderedTask(questionnaire: Questionnaire.skipLogicExample)
        XCTAssert(!orknavigableOrderedTask.steps.isEmpty)
    }

    func testCreateNavigationRule() throws {
        // The skip logic questionnaire has a skip navigation rule on the second step
        let orknavigableOrderedTask = try ORKNavigableOrderedTask(questionnaire: Questionnaire.skipLogicExample)
        let secondStepId = try XCTUnwrap(Questionnaire.skipLogicExample.item?[1].linkId.value?.string)
        XCTAssertNotNil(orknavigableOrderedTask.skipNavigationRule(forStepIdentifier: secondStepId))
    }

    func testConvertQuestionnaireItemToORKSteps() throws {
        let title = Questionnaire.numberExample.title?.value?.string ?? "title"
        let steps = Questionnaire.numberExample.item?.fhirQuestionnaireItemsToORKSteps(title: title, valueSets: [])
        let unwrappedSteps = try XCTUnwrap(steps)
        XCTAssertEqual(unwrappedSteps.count, 3)
    }

    func testGetContainedValueSets() throws {
        let valueSets = Questionnaire.containedValueSetExample.getContainedValueSets()
        XCTAssertEqual(valueSets.count, 1)
    }

}
