//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import FHIRPathParser
import XCTest


final class FHIRPathParserTests: XCTestCase {
    func testBasicAddExpression() throws {
        let result: Date = try FHIRPathExpression.evaluate(expression: "today() + 3 months")

        let nowComponents = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        let resultComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: result)

        XCTAssertEqual(resultComponents.year, nowComponents.year)
        XCTAssertEqual(resultComponents.month, nowComponents.month.map { $0 + 3 })
        XCTAssertEqual(resultComponents.day, nowComponents.day)
        XCTAssertEqual(resultComponents.hour, 0)
        XCTAssertEqual(resultComponents.minute, 0)
        XCTAssertEqual(resultComponents.second, 0)
    }

    func testBasicSubtractExpression() throws {
        let result: Date = try FHIRPathExpression.evaluate(expression: "today() - 3 months")

        let nowComponents = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        let resultComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: result)

        XCTAssertEqual(resultComponents.year, nowComponents.year)
        XCTAssertEqual(resultComponents.month, nowComponents.month.map { $0 - 3 })
        XCTAssertEqual(resultComponents.day, nowComponents.day)
        XCTAssertEqual(resultComponents.hour, 0)
        XCTAssertEqual(resultComponents.minute, 0)
        XCTAssertEqual(resultComponents.second, 0)
    }

    func testUnaryExpression() throws {
        let result: Date = try FHIRPathExpression.evaluate(expression: "today() + (- 3 months)")

        let nowComponents = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        let resultComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: result)

        XCTAssertEqual(resultComponents.year, nowComponents.year)
        XCTAssertEqual(resultComponents.month, nowComponents.month.map { $0 - 3 })
        XCTAssertEqual(resultComponents.day, nowComponents.day)
        XCTAssertEqual(resultComponents.hour, 0)
        XCTAssertEqual(resultComponents.minute, 0)
        XCTAssertEqual(resultComponents.second, 0)
    }

    func testNowExpression() throws {
        let result: Date = try FHIRPathExpression.evaluate(expression: "now()")

        let nowComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: .now)
        let resultComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: result)

        XCTAssertEqual(resultComponents.year, nowComponents.year)
        XCTAssertEqual(resultComponents.month, nowComponents.month)
        XCTAssertEqual(resultComponents.day, nowComponents.day)
        XCTAssertEqual(resultComponents.hour, nowComponents.hour)
        XCTAssertEqual(resultComponents.minute, nowComponents.minute)
    }

    func testFixedDateTimeExpression() throws {
        let date: Date = try FHIRPathExpression.evaluate(expression: "@2015-02-04T14:34:28+00:00 + 3 minutes")

        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 0))
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone


        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        XCTAssertEqual(components.year, 2015)
        XCTAssertEqual(components.month, 2)
        XCTAssertEqual(components.day, 4)
        XCTAssertEqual(components.hour, 14)
        XCTAssertEqual(components.minute, 34 + 3)
        XCTAssertEqual(components.second, 28)
    }

    func testFixedDateExpression() throws {
        let date: Date = try FHIRPathExpression.evaluate(expression: "@2015-02-04 + 1 day")

        let timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 0))
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone


        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        XCTAssertEqual(components.year, 2015)
        XCTAssertEqual(components.month, 2)
        XCTAssertEqual(components.day, 5)
        XCTAssertEqual(components.hour, 0)
        XCTAssertEqual(components.minute, 0)
        XCTAssertEqual(components.second, 0)
    }

    func testUnsupportedExpression() throws {
        XCTAssertThrowsError(try FHIRPathExpression.evaluate(expression: "today() = today()", as: Date.self)) { error in
            guard let error = error as? ExpressionError,
                  let dateError = error.underlyingError as? DateExpressionError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }

            guard case let .unsupportedOperator(`operator`) = dateError else {
                XCTFail("Unexpected error type: \(dateError)")
                return
            }

            XCTAssertEqual(`operator`, "=")
        }
    }
}
