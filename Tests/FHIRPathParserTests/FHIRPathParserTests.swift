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
    func testLiteralParsing() throws { // swiftlint:disable:this function_body_length
        enum ExpectedOutput {
            /// we expect the parsing to fail and throw an error
            case invalid
            /// we expect the parsed result to be equivalent to the specified `DateComponents`
            /// - Note: this will compare, based on the components' timeZone, the year, month, day, hour, minute, and second components.
            /// - Note: Since we (currently?) don't support partial dates, in this context a component having a 0-value
            ///     and a component having a nil value will be considered as being equivalent.
            case date(DateComponents)
        }
        struct Test {
            let input: String
            let expectedOutput: ExpectedOutput
        }
        
        let tz1 = try XCTUnwrap(TimeZone(identifier: "Europe/Berlin"))
        
        let tests: [Test] = [
            Test(input: "@1998-06-02Z", expectedOutput: .invalid),
            Test(input: "@1998-06-02T20:15:00", expectedOutput: .date(.init(
                timeZone: tz1,
                year: 1998,
                month: 6,
                day: 2,
                hour: 20,
                minute: 15
            ))),
            Test(input: "@1998-06-02T18:15:00Z", expectedOutput: .date(.init(
                timeZone: tz1,
                year: 1998,
                month: 6,
                day: 2,
                hour: 20,
                minute: 15
            ))),
            Test(input: "@2017-11-05T01:30:00-04:00", expectedOutput: .date(.init(
                timeZone: try XCTUnwrap(.init(secondsFromGMT: -4 * 60 * 60)),
                year: 2017,
                month: 11,
                day: 5,
                hour: 1,
                minute: 30,
                second: 0
            )))
        ]
        let componentsToTest: [(KeyPath<DateComponents, Int?>, String)] = [
            (\.year, "year"),
            (\.month, "month"),
            (\.day, "day"),
            (\.hour, "hour"),
            (\.minute, "minute"),
            (\.second, "second")
        ]
        
        for test in tests {
            switch test.expectedOutput {
            case .invalid:
                XCTAssertThrowsError(try FHIRPathExpression.evaluate(expression: test.input, as: Date.self))
            case .date(let expectedComponents):
                let cal = Calendar.current
                let parsedDate = try FHIRPathExpression.evaluate(expression: test.input, as: Date.self)
                let parsedDateComponents = try XCTUnwrap(cal.convert(
                    components: cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: parsedDate),
                    bySettingTimeZoneTo: .gmt,
                    componentsToReturn: [.year, .month, .day, .hour, .minute, .second]
                ))
                let expectedComponents = try XCTUnwrap(cal.convert(
                    components: expectedComponents,
                    bySettingTimeZoneTo: .gmt,
                    componentsToReturn: [.year, .month, .day, .hour, .minute, .second]
                ))
                let expectedDate = try XCTUnwrap(cal.date(from: expectedComponents))
                for (keyPath, componentName) in componentsToTest {
                    let actual = parsedDateComponents[keyPath: keyPath]
                    let expected = expectedComponents[keyPath: keyPath]
                    XCTAssert(
                        actual == expected || (actual == nil && expected == 0) || (actual == 0 && expected == nil),
                        "[\(componentName)] Expected: \(String(describing: expected)); Actual: \(String(describing: actual)) (for test input '\(test.input)'; parsedDate: \(parsedDate); expectedDate: \(expectedDate)"
                    )
                }
            }
        }
    }
    
    func testDateTypeHasNoTime() throws {
        let cal = Calendar.current
        let inputs: [String] = [
            "today()",
            "@1998-06-02",
            "@2024-12-05",
            "@1998-06-02",
            "@2024-12-05"
        ]
        for expr in inputs {
            let result: Date = try FHIRPathExpression.evaluate(expression: expr)
            let components = cal.dateComponents(
                [.year, .month, .day, .hour, .minute, .second, .nanosecond],
                from: result
            )
            XCTAssertEqual(components.hour, 0)
            XCTAssertEqual(components.minute, 0)
            XCTAssertEqual(components.second, 0)
            XCTAssertEqual(components.nanosecond, 0)
        }
    }
    
    
    func testTimeLiteralParsing() throws {
        // (non-date) time objects are currently not supported; we expect all of these to fail.
        let inputs = ["timeOfDay()", "@T10:30:00", "@T11:21:09", "@T14:34:28"]
        for expr in inputs {
            XCTAssertThrowsError(try FHIRPathExpression.evaluate(expression: expr, as: Date.self))
        }
    }
    
    
    func testBasicAddExpression() throws {
        let cal = Calendar.current
        let result: Date = try FHIRPathExpression.evaluate(expression: "today() + 3 months")
        let resultComponents = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: result)
        let nowComponents = cal.dateComponents(
            [.year, .month, .day],
            from: try XCTUnwrap(cal.date(byAdding: .month, value: 3, to: .now))
        )
        
        XCTAssertEqual(resultComponents.year, nowComponents.year)
        XCTAssertEqual(resultComponents.month, nowComponents.month)
        XCTAssertEqual(resultComponents.day, nowComponents.day)
        XCTAssertEqual(resultComponents.hour, 0)
        XCTAssertEqual(resultComponents.minute, 0)
        XCTAssertEqual(resultComponents.second, 0)
    }

    
    func testBasicSubtractExpression() throws {
        let cal = Calendar.current
        let result: Date = try FHIRPathExpression.evaluate(expression: "today() - 3 months")
        let resultComponents = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: result)
        let nowComponents = cal.dateComponents(
            [.year, .month, .day],
            from: try XCTUnwrap(cal.date(byAdding: .month, value: -3, to: .now))
        )

        XCTAssertEqual(resultComponents.year, nowComponents.year)
        XCTAssertEqual(resultComponents.month, nowComponents.month)
        XCTAssertEqual(resultComponents.day, nowComponents.day)
        XCTAssertEqual(resultComponents.hour, 0)
        XCTAssertEqual(resultComponents.minute, 0)
        XCTAssertEqual(resultComponents.second, 0)
    }

    
    func testUnaryExpression() throws {
        let cal = Calendar.current
        let result: Date = try FHIRPathExpression.evaluate(expression: "today() + (- 3 months)")
        let resultComponents = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: result)
        let nowComponents = cal.dateComponents(
            [.year, .month, .day],
            from: try XCTUnwrap(cal.date(byAdding: .month, value: -3, to: .now))
        )

        XCTAssertEqual(resultComponents.year, nowComponents.year)
        XCTAssertEqual(resultComponents.month, nowComponents.month)
        XCTAssertEqual(resultComponents.day, nowComponents.day)
        XCTAssertEqual(resultComponents.hour, 0)
        XCTAssertEqual(resultComponents.minute, 0)
        XCTAssertEqual(resultComponents.second, 0)
    }

    
    func testNowExpression() throws {
        let cal = Calendar.current
        let result: Date = try FHIRPathExpression.evaluate(expression: "now()")
        let nowComponents = cal.dateComponents([.year, .month, .day, .hour, .minute], from: .now)
        let resultComponents = cal.dateComponents([.year, .month, .day, .hour, .minute], from: result)

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

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
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
