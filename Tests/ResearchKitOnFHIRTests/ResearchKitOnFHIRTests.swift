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
    func testFHIRToResearchKit() throws {
        let orknavigableOrderedTask = try ORKNavigableOrderedTask(questionnaire: Questionnaire.skipLogicExample)
        
        XCTAssert(!orknavigableOrderedTask.steps.isEmpty)
    }
}
