//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford Biodesign for Digital Health and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest

// We disable type body length rule because this is a test
// swiftlint:disable:next type_body_length
final class ExampleUITests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
    }

    // MARK: UI Tests for Example Questionnaires
    
    func testQuestionnaireJSON() throws {
        let app = XCUIApplication()
        app.launch()
        
        let skipLogicExampleButton = app.collectionViews.buttons["Skip Logic Example"]
        
        // Open context menu and view JSON
        skipLogicExampleButton.press(forDuration: 1.0)
        app.collectionViews.buttons["View JSON"].tap()
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }
    
    func testSkipLogicExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        let skipLogicExampleButton = app.collectionViews.buttons["Skip Logic Example"]
        
        // First run through questionnaire
        skipLogicExampleButton.tap()
        app.tables.staticTexts["Yes"].tap()
        app.tables.buttons["Next"].tap()
        app.tables.staticTexts["Chocolate"].tap()
        app.tables.staticTexts["Next"].tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "August")
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "31")
        app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2021")
        app.buttons["Next"].tap()

        // Close the completion step
        app.buttons["Done"].tap()
        
        // Second run through questionnaire
        skipLogicExampleButton.tap()
        app.tables.staticTexts["No"].tap()
        app.buttons["Next"].tap()

        // Close the completion step
        app.buttons["Done"].tap()
        
        // Open context menu and view results
        skipLogicExampleButton.press(forDuration: 1.0)
        app.collectionViews.buttons["View Responses"].tap()
        
        let buttonsInResultView = app.collectionViews.allElementsBoundByIndex[1].buttons
        XCTAssertEqual(buttonsInResultView.count, 2)
        
        // First result
        buttonsInResultView.allElementsBoundByIndex[0].tap()
        app.navigationBars.buttons["Back"].tap()
        
        // Second result
        buttonsInResultView.allElementsBoundByIndex[1].tap()
        app.navigationBars.buttons["Back"].tap()
        
        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }

    func testOpenChoiceExample() throws {
        let app = XCUIApplication()
        app.launch()

        let skipLogicExampleButton = app.collectionViews.buttons["Skip Logic Example"]

        // First run through questionnaire
        skipLogicExampleButton.tap()
        app.tables.staticTexts["Yes"].tap()
        app.tables.buttons["Next"].tap()

        // Select the "other" option and fill in a free-text answer
        app.tables.staticTexts["Other"].tap()
        let otherField = app.textViews.element(boundBy: 0)
        otherField.tap()
        otherField.typeText("Cookie Dough")
        app.tables.staticTexts["Next"].tap()

        // Enter in a date on the next screen
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "August")
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "31")
        app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2021")
        app.buttons["Next"].tap()

        // Close the completion step
        app.buttons["Done"].tap()
    }

    func testContainedValueSetExample() throws {
        let app = XCUIApplication()
        app.launch()

        let containedValueSetExampleButton = app.collectionViews.buttons["Contained ValueSet Example"]

        // Complete questionnaire
        containedValueSetExampleButton.tap()
        app.tables.staticTexts["Yes"].tap()
        app.buttons["Next"].tap()

        // Close the completion step
        app.buttons["Done"].tap()

        // Open context menu and view results
        containedValueSetExampleButton.press(forDuration: 1.0)
        app.collectionViews.buttons["View Responses"].tap()

        // Check results
        let buttonsInResultView = app.collectionViews.allElementsBoundByIndex[1].buttons
        XCTAssertEqual(buttonsInResultView.count, 1)
        buttonsInResultView.allElementsBoundByIndex[0].tap()
        app.navigationBars.buttons["Back"].tap()

        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }

    func testNumberExample() throws {
        let app = XCUIApplication()
        app.launch()

        let numberExampleButton = app.collectionViews.buttons["Number Validation Example"]

        // Open questionnaire
        numberExampleButton.tap()

        // Fill in integer field
        let integerField = app.textFields.element
        integerField.tap()
        integerField.typeText("1\n")
        app.buttons["Next"].tap()

        // Fill in decimal field
        let decimalField = app.textFields.element
        decimalField.tap()
        decimalField.typeText("1.5\n")
        app.buttons["Next"].tap()

        // Fill in quantity field
        let quantityField = app.textFields.element
        quantityField.tap()
        quantityField.typeText("2.5\n")

        // Finish questionnaire
        app.buttons["Next"].tap()

        // Close the completion step
        app.buttons["Done"].tap()

        // Open context menu and view results
        numberExampleButton.press(forDuration: 1.0)
        app.collectionViews.buttons["View Responses"].tap()

        // Check results
        let buttonsInResultView = app.collectionViews.allElementsBoundByIndex[1].buttons
        XCTAssertEqual(buttonsInResultView.count, 1)
        buttonsInResultView.allElementsBoundByIndex[0].tap()
        app.navigationBars.buttons["Back"].tap()

        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }

    func textValidationExample() throws {
        let app = XCUIApplication()
        app.launch()

        let textValidationExampleButton = app.collectionViews.buttons["Text Validation Example"]

        // Open questionnaire
        textValidationExampleButton.tap()

        // Fill in email
        let emailField = app.textFields.element
        emailField.tap()
        emailField.typeText("vishnu@example.com")

        // Finish survey
        app.buttons["Next"].tap()

        // Close the completion step
        app.buttons["Done"].tap()

        // Open context menu and view results
        textValidationExampleButton.press(forDuration: 1.0)
        app.collectionViews.buttons["View Responses"].tap()

        // Check results
        let buttonsInResultView = app.collectionViews.allElementsBoundByIndex[1].buttons
        XCTAssertEqual(buttonsInResultView.count, 1)
        buttonsInResultView.allElementsBoundByIndex[0].tap()
        app.navigationBars.buttons["Back"].tap()

        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }

    func testDateTimeExample() throws {
        let app = XCUIApplication()
        app.launch()

        let dateTimeExampleButton = app.collectionViews.buttons["Date and Time Example"]

        // Open questionnaire
        dateTimeExampleButton.tap()
        
        let dateFormatter = DateFormatter()
        let randomDateInProximity = Date().addingTimeInterval(TimeInterval.random(in: -(60 * 60 * 24 * 7)...(60 * 60 * 24 * 7)))
        func dateFormatOfRandomDateInProximity(_ dateFormat: String) -> String {
            dateFormatter.dateFormat = dateFormat
            return dateFormatter.string(from: randomDateInProximity)
        }

        // Choose a date
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("MMMM"))
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("d"))
        app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("yyyy"))
        app.buttons["Next"].tap()

        // Chose a date and time
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("MMM d"))
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("h"))
        app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("mm"))
        app.pickerWheels.element(boundBy: 3).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("a"))
        app.buttons["Next"].tap()

        // Choose a time
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("h"))
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("mm"))
        app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("a"))
        app.buttons["Next"].tap()

        // Close the completion step
        app.buttons["Done"].tap()

        // Open context menu and view results
        dateTimeExampleButton.press(forDuration: 1.0)
        app.collectionViews.buttons["View Responses"].tap()

        // Check results
        let buttonsInResultView = app.collectionViews.allElementsBoundByIndex[1].buttons
        XCTAssertEqual(buttonsInResultView.count, 1)
        buttonsInResultView.allElementsBoundByIndex[0].tap()
        app.navigationBars.buttons["Back"].tap()

        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }

    func testFormExample() throws {
        let app = XCUIApplication()
        app.launch()

        let formExampleButton = app.collectionViews.buttons["Form Example"]

        // Open questionnaire and start
        formExampleButton.tap()
        app.buttons["Get Started"].tap()

        // Answer the three questions
        app.tables.staticTexts["Yes"].tap()
        app.tables.staticTexts["Chocolate"].tap()
        app.tables.staticTexts["Sprinkles"].tap()
        app.buttons["Next"].tap()

        // Finish survey
        app.buttons["Done"].tap()

        // Open context menu and view results
        formExampleButton.press(forDuration: 1.0)
        app.collectionViews.buttons["View Responses"].tap()

        // Check results
        let buttonsInResultView = app.collectionViews.allElementsBoundByIndex[1].buttons
        XCTAssertEqual(buttonsInResultView.count, 1)
        buttonsInResultView.allElementsBoundByIndex[0].tap()
        app.navigationBars.buttons["Back"].tap()

        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }

    // MARK: UI Tests for Clinical Questionnaires

    func testPHQ9Example() throws {
        let app = XCUIApplication()
        app.launch()

        let phq9ExampleButton = app.collectionViews.buttons["Patient Health Questionnaire - 9 Item"]

        // Open questionnaire
        phq9ExampleButton.tap()

        // Answer all 9 questions
        let options = ["Not at all", "Several days", "More than half the days", "Nearly every day"]

        for question in 0...8 {
            let buttonQuery = app.tables.staticTexts.matching(identifier: options.randomElement() ?? options[0]).element(boundBy: question)
            buttonQuery.tap()
        }

        // Finish survey
        app.buttons["Next"].tap()

        // Close the completion step
        app.buttons["Done"].tap()

        // Open context menu and view results
        phq9ExampleButton.press(forDuration: 1.0)
        app.collectionViews.buttons["View Responses"].tap()

        // Check results
        let buttonsInResultView = app.collectionViews.allElementsBoundByIndex[1].buttons
        XCTAssertEqual(buttonsInResultView.count, 1)
        buttonsInResultView.allElementsBoundByIndex[0].tap()
        app.navigationBars.buttons["Back"].tap()

        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }

    func testGAD7Example() throws {
        let app = XCUIApplication()
        app.launch()

        let gad7ExampleButton = app.collectionViews.buttons["Generalized Anxiety Disorder - 7"]

        // Open questionnaire
        gad7ExampleButton.tap()

        // Answer all 7 questions
        let options = ["Not at all", "Several days", "More than half the days", "Nearly every day"]

        for question in 0...6 {
            let buttonQuery = app.tables.staticTexts.matching(identifier: options.randomElement() ?? options[0]).element(boundBy: question)
            buttonQuery.tap()
        }

        // Finish survey
        app.buttons["Next"].tap()

        // Close the completion step
        app.buttons["Done"].tap()

        // Open context menu and view results
        gad7ExampleButton.press(forDuration: 1.0)
        app.collectionViews.buttons["View Responses"].tap()

        // Check results
        let buttonsInResultView = app.collectionViews.allElementsBoundByIndex[1].buttons
        XCTAssertEqual(buttonsInResultView.count, 1)
        buttonsInResultView.allElementsBoundByIndex[0].tap()
        app.navigationBars.buttons["Back"].tap()

        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }

    func testGCSExample() throws {
        let app = XCUIApplication()
        app.launch()

        let gcsExampleButton = app.collectionViews.buttons["Glasgow Coma Score"]

        // Open questionnaire
        gcsExampleButton.tap()

        // Answer questions
        app.tables.staticTexts["Oriented"].tap()
        app.buttons["Next"].tap()

        app.tables.staticTexts["Obeys commands"].tap()
        app.buttons["Next"].tap()

        app.tables.staticTexts["Eyes open spontaneously"].tap()
        app.buttons["Next"].tap()

        // Close the completion step
        app.buttons["Done"].tap()

        // Open context menu and view results
        gcsExampleButton.press(forDuration: 1.0)
        app.collectionViews.buttons["View Responses"].tap()

        // Check results
        let buttonsInResultView = app.collectionViews.allElementsBoundByIndex[1].buttons
        XCTAssertEqual(buttonsInResultView.count, 1)
        buttonsInResultView.allElementsBoundByIndex[0].tap()
        app.navigationBars.buttons["Back"].tap()

        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }

    func testMultipleEnableWhenExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        let multipleEnableWhenButton = app.collectionViews.buttons["Multiple EnableWhen Expressions"]
        multipleEnableWhenButton.tap()

        // We will first answer all questions correctly
        app.tables.staticTexts["Yes"].tap()
        app.buttons["Next"].tap()

        app.tables.staticTexts["green"].tap()
        app.buttons["Next"].tap()

        let integerField = app.textFields.element(boundBy: 0)
        integerField.tap()
        integerField.typeText("12\n")
        app.buttons["Next"].tap()

        // First result screen appears if at least one answer is correct.
        app.buttons["Next"].tap()

        // Second result screen appears if all answers are correct.
        app.buttons["Next"].tap()

        // Now the completion screen will appear with a "Done" button that we can tap
        app.buttons["Done"].tap()

        // Now we relaunch the survey
        multipleEnableWhenButton.tap()

        // This time we answer only one question correctly
        app.tables.staticTexts["Yes"].tap()
        app.buttons["Next"].tap()

        app.tables.staticTexts["orange"].tap()
        app.buttons["Next"].tap()

        integerField.tap()
        integerField.typeText("2\n")
        app.buttons["Next"].tap()

        // Only one result screen should appear.
        app.buttons["Next"].tap()

        // Now the completion screen should appear.
        app.buttons["Done"].tap()
    }
}
