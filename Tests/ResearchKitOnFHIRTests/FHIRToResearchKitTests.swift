//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest
import FHIRQuestionnaires
import ModelsR4
@testable import ResearchKitOnFHIR

final class FHIRToResearchKitTests: XCTestCase {
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

    func testRegexExtension() throws {
        let testRegex = Questionnaire.textValidationExample.item?.first?.validationRegularExpression
        // swiftlint:disable:next line_length
        let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
        XCTAssertEqual(regex, testRegex)
    }

    func testValidationMessageExtension() throws {
        let testValidationMessage = Questionnaire.textValidationExample.item?.first?.validationMessage
        let validationMessage = "Please enter a valid email address."
        XCTAssertEqual(validationMessage, testValidationMessage)
    }

    func testUnitExtension() throws {
        let unit = Questionnaire.numberExample.item?[2].unit
        let unwrappedUnit = try XCTUnwrap(unit)
        XCTAssertEqual(unwrappedUnit, "g")
    }

    func testMinValueExtension() throws {
        let minValue = Questionnaire.numberExample.item?.first?.minValue
        let unwrappedMinValue = try XCTUnwrap(minValue)
        XCTAssertEqual(unwrappedMinValue, 1)
    }

    func testMaxValueExtension() throws {
        let maxValue = Questionnaire.numberExample.item?.first?.maxValue
        let unwrappedMaxValue = try XCTUnwrap(maxValue)
        XCTAssertEqual(unwrappedMaxValue, 1000)
    }

    func testMaxDecimalExtension() throws {
        let maxDecimals = Questionnaire.numberExample.item?[1].maximumDecimalPlaces
        let unwrappedMaxDecimals = try XCTUnwrap(maxDecimals)
        XCTAssertEqual(unwrappedMaxDecimals, 3)
    }

    func testNoItemsException() throws {
        var thrownError: Error?

        // Creates a questionnaire and set a URL, but does not add items
        let questionnaire = Questionnaire(status: FHIRPrimitive(PublicationStatus.draft))
        if let url = URL(string: "http://cardinalkit.org/fhir/questionnaire/test") {
            questionnaire.url?.value = FHIRURI(url)
        }

        XCTAssertThrowsError(try ORKNavigableOrderedTask(questionnaire: questionnaire)) {
            thrownError = $0
        }

        XCTAssertTrue(
            thrownError is FHIRToResearchKitConversionError,
            "The parsed FHIR Questionnaire didn't contain any items"
        )

        XCTAssertEqual(thrownError as? FHIRToResearchKitConversionError, .noItems)
    }

    func testNoURLException() throws {
        var thrownError: Error?

        // Creates a questionnaire and adds an item but does not set a URL
        let questionnaire = Questionnaire(status: FHIRPrimitive(PublicationStatus.draft))
        questionnaire.item = [
            QuestionnaireItem(linkId: FHIRPrimitive(FHIRString(UUID().uuidString)),
                              type: FHIRPrimitive(QuestionnaireItemType.display))
        ]

        XCTAssertThrowsError(try ORKNavigableOrderedTask(questionnaire: questionnaire)) {
            thrownError = $0
        }

        XCTAssertTrue(
            thrownError is FHIRToResearchKitConversionError,
            "This FHIR Questionnaire does not have a URL"
        )

        XCTAssertEqual(thrownError as? FHIRToResearchKitConversionError, .noURL)
    }
}
