//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FHIRQuestionnaires
import ModelsR4
@testable import ResearchKitOnFHIR
import XCTest


final class FHIRToResearchKitTests: XCTestCase {
    /// - Note: "FHIR extensions" here meaning Swift extensions on FHIR types, not actual FHIR extensions.
    func testFHIRExtensions() {
        XCTAssertEqual(Questionnaire.numberExample.flattenedItems.count, 3)
        XCTAssertEqual(Questionnaire.numberExample.flattenedQuestions.count, 3)
        XCTAssertEqual(Questionnaire.formExample.flattenedItems.count, 5)
        XCTAssertEqual(Questionnaire.formExample.flattenedQuestions.count, 3)
        XCTAssertEqual(Questionnaire.skipLogicExample.flattenedItems.count, 3)
        XCTAssertEqual(Questionnaire.skipLogicExample.flattenedQuestions.count, 3)
    }
    
    
    func testCreateORKNavigableOrderedTask() throws {
        let questionnaire = Questionnaire.skipLogicExample
        let task = try ORKNavigableOrderedTask(questionnaire: questionnaire)
        XCTAssert(!task.steps.isEmpty)
        XCTAssertEqual(task.steps.count, questionnaire.flattenedItems.count)
    }


    func testConvertQuestionnaireItemToORKSteps() throws {
        func testQuestionnaire(_ questionnaire: Questionnaire, expectedNumSteps: Int) throws {
            let steps = questionnaire.toORKSteps()
            XCTAssertEqual(steps.count, expectedNumSteps)
            for (item, step) in zip(questionnaire.flattenedItems, steps) {
                XCTAssertEqual(try XCTUnwrap(item.linkId.value).string, step.identifier)
            }
        }
        
        try testQuestionnaire(.numberExample, expectedNumSteps: 3)
        try testQuestionnaire(.formExample, expectedNumSteps: 2)
        try testQuestionnaire(.skipLogicExample, expectedNumSteps: 3)
    }

    func testImageCaptureStep() throws {
        let questionnaire = Questionnaire.imageCaptureExample
        let steps = questionnaire.toORKSteps()
        XCTAssertEqual(steps.count, 1)
    }

    func testGetContainedValueSets() throws {
        let valueSets = Questionnaire.containedValueSetExample.getContainedValueSets()
        XCTAssertEqual(valueSets.count, 1)
    }

    func testItemControlExtension() throws {
        let testItemControl = Questionnaire.sliderExample.item?.first?.itemControl
        let itemControlValue = try XCTUnwrap(testItemControl)
        XCTAssertEqual(itemControlValue, "slider")
    }
    
    func testCodingRegexPattern() throws {
        let codingWithDisplay = ValueCoding(code: "medication.value-yes", system: "http://researchkitonfhir.biodesign.stanford.edu/fhir/Coding/medication-value-exists", display: "Yes")
        let patternWithDisplay = codingWithDisplay.patternForMatchingORKChoiceQuestionResult
        let expressionWithDisplay = try NSRegularExpression(pattern: patternWithDisplay)
        let rawValueWithDisplay = codingWithDisplay.rawValue
        XCTAssert(!expressionWithDisplay.matches(in: rawValueWithDisplay, range: NSRange(location: 0, length: rawValueWithDisplay.count)).isEmpty)

        let codingWithoutDisplay = ValueCoding(code: "medication.value-yes", system: "http://researchkitonfhir.biodesign.stanford.edu/fhir/Coding/medication-value-exists", display: nil)
        let patternWithoutDisplay = codingWithoutDisplay.patternForMatchingORKChoiceQuestionResult
        let expressionWithoutDisplay = try NSRegularExpression(pattern: patternWithoutDisplay)
        XCTAssert(!expressionWithoutDisplay.matches(in: rawValueWithDisplay, range: NSRange(location: 0, length: rawValueWithDisplay.count)).isEmpty)
    }

    func testRegexExtension() throws {
        let testRegex = Questionnaire.textValidationExample.item?.first?.validationRegularExpression
        // swiftlint:disable:next line_length
        let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
        XCTAssertEqual(regex, testRegex)
    }

    func testSliderStepValueExtension() throws {
        let testSliderStepValue = Questionnaire.sliderExample.item?.first?.sliderStepValue
        let sliderStepValue = try XCTUnwrap(testSliderStepValue)
        XCTAssertEqual(sliderStepValue, 1)
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
        XCTAssertEqual(unwrappedMaxValue, 100)
    }

    func testMinDateValueExtension() throws {
        let minDateValue = Questionnaire.dateTimeExample.item?.first?.minDateValue
        let unwrappedMinDateValue = try XCTUnwrap(minDateValue)

        XCTAssertEqual(unwrappedMinDateValue, Calendar.current.date(from: DateComponents(year: 2001, month: 1, day: 1)))
    }

    func testMaxDateValueExtension() throws {
        let maxDateValue = Questionnaire.dateTimeExample.item?.first?.maxDateValue
        let unwrappedMaxDateValue = try XCTUnwrap(maxDateValue)

        XCTAssertEqual(unwrappedMaxDateValue, Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1)))
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
        if let url = URL(string: "http://biodesign.stanford.edu/fhir/questionnaire/test") {
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

    func testNoURL() throws {
        // Creates a questionnaire and adds an item but does not set a URL
        let questionnaire = Questionnaire(status: FHIRPrimitive(PublicationStatus.draft))
        questionnaire.item = [
            QuestionnaireItem(
                linkId: FHIRPrimitive(FHIRString(UUID().uuidString)),
                type: FHIRPrimitive(QuestionnaireItemType.display)
            )
        ]

        let task = try ORKNavigableOrderedTask(questionnaire: questionnaire)

        XCTAssertNotNil(
            UUID(uuidString: task.identifier),
            "In case there's no URL provided, random UUID will be generated and assigned to the ID"
        )
    }
}
