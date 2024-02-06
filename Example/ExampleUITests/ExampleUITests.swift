//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

// We disable file length because this is a test
// swiftlint:disable file_length
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
        app.staticTexts["Yes"].tap()
        app.buttons["Next"].tap()
        
        app.staticTexts["Chocolate"].tap()
        app.buttons["Next"].tap()
        
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
        XCTAssert(buttonsInResultView.allElementsBoundByIndex[0].waitForExistence(timeout: 2))
        buttonsInResultView.allElementsBoundByIndex[0].tap()
        app.navigationBars.buttons["Back"].tap()
        
        // Second result
        XCTAssert(buttonsInResultView.allElementsBoundByIndex[1].waitForExistence(timeout: 2))
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
        #warning("This functionality seems to be broken since the last changes with the open text choices: https://github.com/StanfordBDHG/ResearchKit/commit/54913426d31e6131119318f2568cd937d629b2ae#diff-965a610b20ace92ce0f85d16f2b046520f06041f3929cfedd8d18e671596af15")
        app.tables.staticTexts["Other"].tap()
        let otherField = app.textViews.element(boundBy: 0)
        otherField.tap()
        otherField.typeText("Cookie Dough")
        app.buttons["Next"].tap()

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

        // Complete questionnaire
        let containedValueSetExampleButton = app.collectionViews.buttons["Contained ValueSet Example"]
        XCTAssert(containedValueSetExampleButton.waitForExistence(timeout: 2))
        containedValueSetExampleButton.tap()
        
        let yesButton = app.tables.staticTexts["Yes"]
        XCTAssert(yesButton.waitForExistence(timeout: 2))
        yesButton.tap()
        
        let nextButton = app.buttons["Next"]
        XCTAssert(nextButton.waitForExistence(timeout: 2))
        nextButton.tap()

        // Close the completion step
        let doneButton = app.buttons["Done"]
        XCTAssert(doneButton.waitForExistence(timeout: 2))
        doneButton.tap()

        // Open context menu and view results
        sleep(1)
        XCTAssert(containedValueSetExampleButton.waitForExistence(timeout: 2))
        containedValueSetExampleButton.press(forDuration: 1.0)
        app.collectionViews.buttons["View Responses"].tap()

        // Check results
        let buttonsInResultView = app.collectionViews.allElementsBoundByIndex[1].buttons
        XCTAssertEqual(buttonsInResultView.count, 1)
        XCTAssert(buttonsInResultView.allElementsBoundByIndex[0].waitForExistence(timeout: 2))
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
        XCTAssert(buttonsInResultView.allElementsBoundByIndex[0].waitForExistence(timeout: 2))
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
        XCTAssert(buttonsInResultView.allElementsBoundByIndex[0].waitForExistence(timeout: 2))
        buttonsInResultView.allElementsBoundByIndex[0].tap()
        app.navigationBars.buttons["Back"].tap()

        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }

    func testDateTimeExample() throws {
        let app = XCUIApplication()
        app.launch()

        let dateTimeExampleButton = app.collectionViews.buttons["Date and Time Example"]
        XCTAssert(dateTimeExampleButton.waitForExistence(timeout: 2))
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
        sleep(1)
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("MMM d"))
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("h"))
        app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("mm"))
        app.pickerWheels.element(boundBy: 3).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("a"))
        app.buttons["Next"].tap()

        // Choose a time
        sleep(1)
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("h"))
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("mm"))
        app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: dateFormatOfRandomDateInProximity("a"))
        app.buttons["Next"].tap()

        // Close the completion step
        let doneButton = app.buttons["Done"]
        XCTAssert(doneButton.waitForExistence(timeout: 2))
        doneButton.tap()

        // Open context menu and view results
        XCTAssert(dateTimeExampleButton.waitForExistence(timeout: 2))
        dateTimeExampleButton.press(forDuration: 1.0)
        
        let viewReponsesButton = app.collectionViews.buttons["View Responses"]
        XCTAssert(viewReponsesButton.waitForExistence(timeout: 2))
        viewReponsesButton.tap()

        // Check results
        sleep(1)
        let buttonsInResultView = app.collectionViews.allElementsBoundByIndex[1].buttons
        XCTAssertEqual(buttonsInResultView.count, 1)
        XCTAssert(buttonsInResultView.allElementsBoundByIndex[0].waitForExistence(timeout: 2))
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
        app.tables.staticTexts["Marshmallows"].tap()
        app.buttons["Next"].tap()

        // Finish survey
        app.buttons["Done"].tap()

        // Open context menu and view results
        formExampleButton.press(forDuration: 1.0)
        app.collectionViews.buttons["View Responses"].tap()

        // Check results
        let buttonsInResultView = app.collectionViews.allElementsBoundByIndex[1].buttons
        XCTAssertEqual(buttonsInResultView.count, 1)
        XCTAssert(buttonsInResultView.allElementsBoundByIndex[0].waitForExistence(timeout: 2))
        buttonsInResultView.allElementsBoundByIndex[0].tap()
        app.navigationBars.buttons["Back"].tap()

        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }

    func testSliderExample() throws {
        let app = XCUIApplication()
        app.launch()

        let sliderExampleButton = app.collectionViews.buttons["Slider Example"]

        // Open questionnaire and start
        sliderExampleButton.tap()

        // Access the slider
        let slider = app.sliders.firstMatch
        XCTAssertTrue(slider.exists, "The slider does not exist")

        // Calculate normalized position for the desired value
        let desiredValue: CGFloat = 5
        let sliderRange: CGFloat = 10
        let normalizedPosition = desiredValue / sliderRange

        // Adjust the slider's value
        slider.adjust(toNormalizedSliderPosition: normalizedPosition)

        // Check that the slider's value is now equal to the desired value
        if let valueString = slider.value as? String, let value = Double(valueString) {
            let sliderValue = CGFloat(value)
            XCTAssertEqual(sliderValue, desiredValue, accuracy: 1)
        } else {
            XCTFail("Slider value is not a readable number.")
        }
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
        XCTAssert(buttonsInResultView.allElementsBoundByIndex[0].waitForExistence(timeout: 2))
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
        XCTAssert(buttonsInResultView.allElementsBoundByIndex[0].waitForExistence(timeout: 2))
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
        XCTAssert(buttonsInResultView.allElementsBoundByIndex[0].waitForExistence(timeout: 2))
        buttonsInResultView.allElementsBoundByIndex[0].tap()
        app.navigationBars.buttons["Back"].tap()

        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }

    func testMultipleEnableWhenExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        let multipleEnableWhenButton = app.collectionViews.buttons["Multiple EnableWhen Expressions"]
        XCTAssert(multipleEnableWhenButton.waitForExistence(timeout: 2))
        multipleEnableWhenButton.tap()

        // We will first answer all questions correctly
        XCTAssert(app.tables.staticTexts["Yes"].waitForExistence(timeout: 2))
        app.tables.staticTexts["Yes"].tap()
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 2))
        app.buttons["Next"].tap()

        XCTAssert(app.tables.staticTexts["green"].waitForExistence(timeout: 2))
        app.tables.staticTexts["green"].tap()
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 2))
        app.buttons["Next"].tap()

        
        let integerField = app.textFields.element(boundBy: 0)
        XCTAssert(integerField.waitForExistence(timeout: 2))
        integerField.tap()
        integerField.typeText("12\n")
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 2))
        app.buttons["Next"].tap()

        // First result screen appears if at least one answer is correct.
        sleep(1)
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 2))
        app.buttons["Next"].tap()

        // Second result screen appears if all answers are correct.
        sleep(1)
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 2))
        app.buttons["Next"].tap()

        // Now the completion screen will appear with a "Done" button that we can tap
        sleep(1)
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 2))
        app.buttons["Done"].tap()

        // Now we relaunch the survey
        XCTAssert(multipleEnableWhenButton.waitForExistence(timeout: 2))
        multipleEnableWhenButton.tap()

        // This time we answer only one question correctly
        XCTAssert(app.tables.staticTexts["Yes"].waitForExistence(timeout: 2))
        app.tables.staticTexts["Yes"].tap()
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 2))
        app.buttons["Next"].tap()

        XCTAssert(app.tables.staticTexts["orange"].waitForExistence(timeout: 2))
        app.tables.staticTexts["orange"].tap()
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 2))
        app.buttons["Next"].tap()

        XCTAssert(integerField.waitForExistence(timeout: 2))
        integerField.tap()
        integerField.typeText("2\n")
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 2))
        app.buttons["Next"].tap()

        // Only one result screen should appear.
        sleep(1)
        XCTAssert(app.buttons["Next"].waitForExistence(timeout: 2))
        app.buttons["Next"].tap()

        // Now the completion screen should appear.
        sleep(1)
        XCTAssert(app.buttons["Done"].waitForExistence(timeout: 2))
        app.buttons["Done"].tap()
    }

    func testImageCaptureExample() {
        let app = XCUIApplication()
        app.launch()

        let imageCaptureButton = app.collectionViews.buttons["Image Capture Example"]
        XCTAssert(imageCaptureButton.waitForExistence(timeout: 2))
        imageCaptureButton.tap()

        // This example requires access to a device camera, which can't be simulated,
        // so we will get an error message.
        XCTAssert(app.staticTexts["No camera found.  This step cannot be completed."].waitForExistence(timeout: 2))

        let skipButton = app.buttons["Skip"]
        XCTAssert(skipButton.waitForExistence(timeout: 2))
        skipButton.tap()

        let doneButton = app.buttons["Done"]
        XCTAssert(doneButton.waitForExistence(timeout: 2))
        doneButton.tap()
    }
}
