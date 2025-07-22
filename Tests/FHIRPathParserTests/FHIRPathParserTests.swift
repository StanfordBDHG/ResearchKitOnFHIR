//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import FHIRPathParser
import Foundation
import Testing


struct FHIRPathParserTests {
    @Test("Literal parsing")
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
        
        let tz1 = try #require(TimeZone(identifier: "Europe/Berlin"))
        
        let tests: [Test] = [
            Test(input: "@1998-06-02Z", expectedOutput: .invalid),
            Test(input: "@T", expectedOutput: .invalid),
            Test(input: "@1998-06-02T13:15:00-05:00", expectedOutput: .date(.init(
                timeZone: tz1,
                year: 1998,
                month: 6,
                day: 2,
                hour: 20,
                minute: 15
            ))),
            Test(input: "@1998-06-03T02:15:00+08:00", expectedOutput: .date(.init(
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
                timeZone: .init(secondsFromGMT: -4 * 60 * 60),
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
                #expect(throws: (any Error).self) {
                    try FHIRPathExpression.evaluate(expression: test.input, as: Date.self)
                }
            case .date(let expectedComponents):
                let cal = Calendar.current
                let parsedDate = try FHIRPathExpression.evaluate(expression: test.input, as: Date.self)
                let parsedDateComponents = try #require(cal.convert(
                    components: cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: parsedDate),
                    bySettingTimeZoneTo: .gmt,
                    componentsToReturn: [.year, .month, .day, .hour, .minute, .second]
                ))
                let expectedComponents = try #require(cal.convert(
                    components: expectedComponents,
                    bySettingTimeZoneTo: .gmt,
                    componentsToReturn: [.year, .month, .day, .hour, .minute, .second]
                ))
                let expectedDate = try #require(cal.date(from: expectedComponents))
                for (keyPath, componentName) in componentsToTest {
                    let actual = parsedDateComponents[keyPath: keyPath]
                    let expected = expectedComponents[keyPath: keyPath]
                    #expect(
                        actual == expected || (actual == nil && expected == 0) || (actual == 0 && expected == nil),
                        "[\(componentName)] Expected: \(String(describing: expected)); Actual: \(String(describing: actual)) (for test input '\(test.input)'; parsedDate: \(parsedDate); expectedDate: \(expectedDate)"
                    )
                }
            }
        }
    }
    
    @Test("Date type has no time")
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
            #expect(components.hour == 0)
            #expect(components.minute == 0)
            #expect(components.second == 0)
            #expect(components.nanosecond == 0)
        }
    }
    
    
    @Test("Time literal parsing")
    func testTimeLiteralParsing() throws {
        // (non-date) time objects are currently not supported; we expect all of these to fail.
        let inputs = ["timeOfDay()", "@T10:30:00", "@T11:21:09", "@T14:34:28"]
        for expr in inputs {
            #expect(throws: (any Error).self) {
                try FHIRPathExpression.evaluate(expression: expr, as: Date.self)
            }
        }
    }
    
    
    @Test("Basic add expression")
    func testBasicAddExpression() throws {
        let cal = Calendar.current
        let result: Date = try FHIRPathExpression.evaluate(expression: "today() + 3 months")
        let resultComponents = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: result)
        let nowComponents = cal.dateComponents(
            [.year, .month, .day],
            from: try #require(cal.date(byAdding: .month, value: 3, to: .now))
        )
        
        #expect(resultComponents.year == nowComponents.year)
        #expect(resultComponents.month == nowComponents.month)
        #expect(resultComponents.day == nowComponents.day)
        #expect(resultComponents.hour == 0)
        #expect(resultComponents.minute == 0)
        #expect(resultComponents.second == 0)
    }

    
    @Test("Basic subtract expression")
    func testBasicSubtractExpression() throws {
        let cal = Calendar.current
        let result: Date = try FHIRPathExpression.evaluate(expression: "today() - 3 months")
        let resultComponents = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: result)
        let nowComponents = cal.dateComponents(
            [.year, .month, .day],
            from: try #require(cal.date(byAdding: .month, value: -3, to: .now))
        )

        #expect(resultComponents.year == nowComponents.year)
        #expect(resultComponents.month == nowComponents.month)
        #expect(resultComponents.day == nowComponents.day)
        #expect(resultComponents.hour == 0)
        #expect(resultComponents.minute == 0)
        #expect(resultComponents.second == 0)
    }

    
    @Test("Unary expression")
    func testUnaryExpression() throws {
        let cal = Calendar.current
        let result: Date = try FHIRPathExpression.evaluate(expression: "today() + (- 3 months)")
        let resultComponents = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: result)
        let nowComponents = cal.dateComponents(
            [.year, .month, .day],
            from: try #require(cal.date(byAdding: .month, value: -3, to: .now))
        )

        #expect(resultComponents.year == nowComponents.year)
        #expect(resultComponents.month == nowComponents.month)
        #expect(resultComponents.day == nowComponents.day)
        #expect(resultComponents.hour == 0)
        #expect(resultComponents.minute == 0)
        #expect(resultComponents.second == 0)
    }

    
    @Test("Now expression")
    func testNowExpression() throws {
        let cal = Calendar.current
        let result: Date = try FHIRPathExpression.evaluate(expression: "now()")
        let nowComponents = cal.dateComponents([.year, .month, .day, .hour, .minute], from: .now)
        let resultComponents = cal.dateComponents([.year, .month, .day, .hour, .minute], from: result)

        #expect(resultComponents.year == nowComponents.year)
        #expect(resultComponents.month == nowComponents.month)
        #expect(resultComponents.day == nowComponents.day)
        #expect(resultComponents.hour == nowComponents.hour)
        #expect(resultComponents.minute == nowComponents.minute)
    }

    
    @Test("Fixed date time expression")
    func testFixedDateTimeExpression() throws {
        let date: Date = try FHIRPathExpression.evaluate(expression: "@2015-02-04T14:34:28+00:00 + 3 minutes")
        let timeZone = try #require(TimeZone(secondsFromGMT: 0))
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone

        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        #expect(components.year == 2015)
        #expect(components.month == 2)
        #expect(components.day == 4)
        #expect(components.hour == 14)
        #expect(components.minute == 34 + 3)
        #expect(components.second == 28)
    }

    
    @Test("Fixed date expression")
    func testFixedDateExpression() throws {
        let date: Date = try FHIRPathExpression.evaluate(expression: "@2015-02-04 + 1 day")

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        #expect(components.year == 2015)
        #expect(components.month == 2)
        #expect(components.day == 5)
        #expect(components.hour == 0)
        #expect(components.minute == 0)
        #expect(components.second == 0)
    }

    
    @Test("Unsupported expression")
    func testUnsupportedExpression() throws {
        do {
            _ = try FHIRPathExpression.evaluate(expression: "today() = today()", as: Date.self)
            Issue.record("Expected an error to be thrown")
        } catch let error as ExpressionError {
            guard let dateError = error.underlyingError as? DateExpressionError else {
                Issue.record("Unexpected error type: \(error)")
                return
            }
            guard case let .unsupportedOperator(`operator`) = dateError else {
                Issue.record("Unexpected error type: \(dateError)")
                return
            }
            #expect(`operator` == "=")
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
}
