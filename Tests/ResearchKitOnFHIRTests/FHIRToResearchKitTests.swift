//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FHIRQuestionnaires
import Foundation
import ModelsR4
@testable import ResearchKitOnFHIR
import Testing


struct FHIRToResearchKitTests {
    /// - Note: "FHIR extensions" here meaning Swift extensions on FHIR types, not actual FHIR extensions.
    @Test("FHIR extensions")
    func testFHIRExtensions() {
        #expect(Questionnaire.numberExample.flattenedItems.count == 3)
        #expect(Questionnaire.numberExample.flattenedQuestions.count == 3)
        #expect(Questionnaire.formExample.flattenedItems.count == 5)
        #expect(Questionnaire.formExample.flattenedQuestions.count == 3)
        #expect(Questionnaire.skipLogicExample.flattenedItems.count == 3)
        #expect(Questionnaire.skipLogicExample.flattenedQuestions.count == 3)
    }
    
    
    @Test("Create ORKNavigableOrderedTask")
    func testCreateORKNavigableOrderedTask() throws {
        let questionnaire = Questionnaire.skipLogicExample
        let task = try ORKNavigableOrderedTask(questionnaire: questionnaire)
        #expect(!task.steps.isEmpty)
        #expect(task.steps.count == questionnaire.flattenedItems.count)
    }


    @Test("Convert QuestionnaireItem to ORKSteps")
    func testConvertQuestionnaireItemToORKSteps() throws {
        func testQuestionnaire(_ questionnaire: Questionnaire, expectedNumSteps: Int) throws {
            let steps = questionnaire.toORKSteps()
            #expect(steps.count == expectedNumSteps)
            for (item, step) in zip(questionnaire.flattenedItems, steps) {
                #expect(try #require(item.linkId.value).string == step.identifier)
            }
        }
        
        try testQuestionnaire(.numberExample, expectedNumSteps: 3)
        try testQuestionnaire(.formExample, expectedNumSteps: 2)
        try testQuestionnaire(.skipLogicExample, expectedNumSteps: 3)
    }

    @Test("Image capture step")
    func testImageCaptureStep() throws {
        let questionnaire = Questionnaire.imageCaptureExample
        let steps = questionnaire.toORKSteps()
        #expect(steps.count == 1)
    }

    @Test("Get contained value sets")
    func testGetContainedValueSets() throws {
        let valueSets = Questionnaire.containedValueSetExample.getContainedValueSets()
        #expect(valueSets.count == 1)
    }

    @Test("Item control extension")
    func testItemControlExtension() throws {
        let testItemControl = Questionnaire.sliderExample.item?.first?.itemControl
        let itemControlValue = try #require(testItemControl)
        #expect(itemControlValue == "slider")
    }
    
    @Test("Coding Regex Pattern")
    func codingRegexPattern() throws {
        let codingWithDisplay = ValueCoding(
            code: "medication.value-yes",
            system: "http://researchkitonfhir.biodesign.stanford.edu/fhir/Coding/medication-value-exists",
            display: "Yes"
        )
        let patternWithDisplay = codingWithDisplay.patternForMatchingORKChoiceQuestionResult
        let expressionWithDisplay = try NSRegularExpression(pattern: patternWithDisplay)
        let rawValueWithDisplay = codingWithDisplay.rawValue
        #expect(!expressionWithDisplay.matches(in: rawValueWithDisplay, range: NSRange(location: 0, length: rawValueWithDisplay.count)).isEmpty)

        let codingWithoutDisplay = ValueCoding(
            code: "medication.value-yes",
            system: "http://researchkitonfhir.biodesign.stanford.edu/fhir/Coding/medication-value-exists",
            display: nil
        )
        let patternWithoutDisplay = codingWithoutDisplay.patternForMatchingORKChoiceQuestionResult
        let expressionWithoutDisplay = try NSRegularExpression(pattern: patternWithoutDisplay)
        #expect(!expressionWithoutDisplay.matches(in: rawValueWithDisplay, range: NSRange(location: 0, length: rawValueWithDisplay.count)).isEmpty)
    }

    @Test("Regex extension")
    func testRegexExtension() throws {
        let testRegex = Questionnaire.textValidationExample.item?.first?.validationRegularExpression
        // swiftlint:disable:next line_length
        let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
        #expect(regex == testRegex)
    }

    @Test("Slider step value extension")
    func testSliderStepValueExtension() throws {
        let testSliderStepValue = Questionnaire.sliderExample.item?.first?.sliderStepValue
        let sliderStepValue = try #require(testSliderStepValue)
        #expect(sliderStepValue == 1)
    }

    @Test("Validation message extension")
    func testValidationMessageExtension() throws {
        let testValidationMessage = Questionnaire.textValidationExample.item?.first?.validationMessage
        let validationMessage = "Please enter a valid email address."
        #expect(validationMessage == testValidationMessage)
    }

    @Test("Unit extension")
    func testUnitExtension() throws {
        let unit = Questionnaire.numberExample.item?[2].unit
        let unwrappedUnit = try #require(unit)
        #expect(unwrappedUnit == "g")
    }

    @Test("Minimum value extension")
    func testMinValueExtension() throws {
        let minValues = try #require(Questionnaire.numberExample.item).map(\.minValue)
        #expect(minValues == [
            NSNumber(value: 1),
            NSNumber(value: 1),
            NSNumber(value: 1)
        ])
    }

    @Test("Maximum value extension")
    func testMaxValueExtension() throws {
        let minValues = try #require(Questionnaire.numberExample.item).map(\.maxValue)
        #expect(minValues == [
            NSNumber(value: 100),
            NSNumber(value: 100),
            NSNumber(value: 100)
        ])
    }

    @Test("Minimum date value extension")
    func testMinDateValueExtension() throws {
        let minDateValue = Questionnaire.dateTimeExample.item?.first?.minDateValue
        let unwrappedMinDateValue = try #require(minDateValue)
        #expect(unwrappedMinDateValue == Calendar.current.date(from: DateComponents(year: 2001, month: 1, day: 1)))
    }

    @Test("Maximum date value extension")
    func testMaxDateValueExtension() throws {
        let maxDateValue = Questionnaire.dateTimeExample.item?.first?.maxDateValue
        let unwrappedMaxDateValue = try #require(maxDateValue)
        #expect(unwrappedMaxDateValue == Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1)))
    }

    @Test("Maximum decimal extension")
    func testMaxDecimalExtension() throws {
        let maxDecimals = Questionnaire.numberExample.item?[1].maximumDecimalPlaces
        let unwrappedMaxDecimals = try #require(maxDecimals)
        #expect(unwrappedMaxDecimals == 3)
    }

    @Test("Questionnaire with no items")
    func testNoItemsException() throws {
        // Creates a questionnaire and set a URL, but does not add items
        let questionnaire = Questionnaire(status: FHIRPrimitive(PublicationStatus.draft))
        if let url = URL(string: "http://biodesign.stanford.edu/fhir/questionnaire/test") {
            questionnaire.url?.value = FHIRURI(url)
        }
        #expect(throws: FHIRToResearchKitConversionError.noItems) {
            try ORKNavigableOrderedTask(questionnaire: questionnaire)
        }
    }

    @Test("Questionnaire with no URL")
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
        #expect(
            UUID(uuidString: task.identifier) != nil,
            "In case there's no URL provided, random UUID will be generated and assigned to the ID"
        )
    }
}
