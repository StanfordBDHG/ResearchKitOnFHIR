//
// This source file is part of the ResearchKitOnFHIR open source project
// 
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import ModelsR4
import ResearchKit
@testable import ResearchKitOnFHIR
import XCTest


final class ResearchKitOnFHIRTests: XCTestCase {
    func testFHIRToResearchKit() throws {
        let exampleJSONData = try Data(contentsOf: try XCTUnwrap(Bundle.module.url(forResource: "IceCreamExample", withExtension: "json")))
        let questionaire = try JSONDecoder().decode(Questionnaire.self, from: exampleJSONData)
        let orknavigableOrderedTask = try ORKNavigableOrderedTask(questionnaire: questionaire)
        
        XCTAssert(!orknavigableOrderedTask.steps.isEmpty)
    }
}
