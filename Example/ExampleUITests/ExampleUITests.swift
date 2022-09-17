//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class ExampleUITests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
    }
    
    
    func testQuestionnaireJSON() throws {
        let app = XCUIApplication()
        app.launch()
        
        let skipLogicExampleButton = app.collectionViews.buttons["Skip Logic Example"]
        
        // Open context menu and view JSON
        skipLogicExampleButton.press(forDuration: 1.0)
        app.collectionViews.buttons["View JSON"].tap()
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }
    
    func testQuestionnaireResults() throws {
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
        app.buttons["Done"].tap()

        
        // Second run through questionnaire
        skipLogicExampleButton.tap()
        app.tables.staticTexts["No"].tap()
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
}
