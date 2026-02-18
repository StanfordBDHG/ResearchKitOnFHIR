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


@Suite(.serialized)
struct FHIRPathParserTests {
    @Test func literalParsing() throws { // swiftlint:disable:this function_body_length
        enum ExpectedOutput {
            /// we expect the parsing to fail and throw an error
            case invalid
            /// we expect the parsed result to be equivalent to the specified `DateComponents`
            /// - Note: this will compare, based on the components' timeZone, the year, month, day, hour, minute, and second components.
            /// - Note: Since we (currently?) don't support partial dates, in this context a component having a 0-value
            ///     and a component having a nil value will be considered as being equivalent.
            case date(asDate: DateComponents, asComponents: DateComponents)
        }
        
        struct Test {
            let input: String
            let expectedOutput: ExpectedOutput
        }
        
        let tz1 = try #require(TimeZone(identifier: "Europe/Berlin"))
        
        let tests: [Test] = [
            Test(input: "@1998-06-02Z", expectedOutput: .invalid),
            Test(input: "@T", expectedOutput: .invalid),
            Test(input: "@1998-06-02T13:15:00-05:00", expectedOutput: .date(
                asDate: .init(timeZone: tz1, year: 1998, month: 6, day: 2, hour: 20, minute: 15),
                asComponents: .init(timeZone: .init(secondsFromGMT: -5 * 60 * 60), year: 1998, month: 6, day: 2, hour: 13, minute: 15, second: 0)
            )),
            Test(input: "@1998-06-03T02:15:00+08:00", expectedOutput: .date(
                asDate: .init(timeZone: tz1, year: 1998, month: 6, day: 2, hour: 20, minute: 15),
                asComponents: .init(timeZone: .init(secondsFromGMT: 8 * 60 * 60), year: 1998, month: 6, day: 3, hour: 2, minute: 15, second: 0)
            )),
            Test(input: "@1998-06-02T18:15:00Z", expectedOutput: .date(
                asDate: .init(timeZone: tz1, year: 1998, month: 6, day: 2, hour: 20, minute: 15),
                asComponents: .init(timeZone: .init(secondsFromGMT: 0), year: 1998, month: 6, day: 2, hour: 18, minute: 15, second: 0)
            )),
            Test(input: "@2017-11-05T01:30:00-04:00", expectedOutput: .date(
                asDate: .init(timeZone: .init(secondsFromGMT: -4 * 60 * 60), year: 2017, month: 11, day: 5, hour: 1, minute: 30, second: 0),
                asComponents: .init(timeZone: .init(secondsFromGMT: -4 * 60 * 60), year: 2017, month: 11, day: 5, hour: 1, minute: 30, second: 0)
            ))
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
            case let .date(expectedComponentsWhenParsedAsDate, expectedComponentsWhenParsedAsComponents):
                let cal = Calendar.current
                do {
                    let parsedComponents = try FHIRPathExpression.evaluate(expression: test.input, as: DateComponents.self)
                    #expect(parsedComponents == expectedComponentsWhenParsedAsComponents)
                }
                do {
                    let parsedDate = try FHIRPathExpression.evaluate(expression: test.input, as: Date.self)
                    let parsedDateComponents = try #require(cal.convert(
                        components: cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: parsedDate),
                        bySettingTimeZoneTo: .gmt,
                        componentsToReturn: [.year, .month, .day, .hour, .minute, .second]
                    ))
                    let expectedComponents = try #require(cal.convert(
                        components: expectedComponentsWhenParsedAsDate,
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
    }
    
    @Test
    func dateTypeHasNoTime() throws {
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
    
    
    @Test
    func timeLiteralParsing() throws {
        enum ExpectedResult {
            case timeOfDay
            case components(DateComponents)
        }
        let inputs: [String: ExpectedResult] = [
            "timeOfDay()": .timeOfDay,
            "@T10:30:00": .components(.init(hour: 10, minute: 30, second: 0)),
            "@T11:21:09": .components(.init(hour: 11, minute: 21, second: 9)),
            "@T14:34:28": .components(.init(hour: 14, minute: 34, second: 28))
        ]
        for (input, expected) in inputs {
            // (non-date) time objects cannot be parsed into `Date`
            #expect(throws: (any Error).self) {
                try FHIRPathExpression.evaluate(expression: input, as: Date.self)
            }
            // ... but they can be parsed into `DateComponents`
            let parsedComponents = try FHIRPathExpression.evaluate(expression: input, as: DateComponents.self)
            switch expected {
            case .timeOfDay:
                let nowComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: .now)
                #expect(parsedComponents.hour == nowComponents.hour)
                #expect(parsedComponents.minute == nowComponents.minute)
                let parsedSecond = try #require(parsedComponents.second)
                let nowSecond = try #require(nowComponents.second)
                #expect(parsedSecond == nowSecond || parsedSecond == nowSecond - 1)
            case .components(let expectedComponents):
                #expect(parsedComponents == expectedComponents)
            }
        }
    }
    
    
    @Test
    func basicAddExpression() throws {
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

    
    @Test
    func basicSubtractExpression() throws {
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

    
    @Test
    func unaryExpression() throws {
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
    
    
    @Test
    func nowExpression() throws {
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
    
    
    @Test
    func fixedDateTimeExpression() throws {
        let inputs: [String: DateComponents] = [
            "@2015-02-04T14:34:28+00:00": .init(timeZone: .init(secondsFromGMT: 0), year: 2015, month: 2, day: 4, hour: 14, minute: 34, second: 28),
            "@2015-02-04T14:34:28+00:00 + 0 minutes": .init(timeZone: .init(secondsFromGMT: 0), year: 2015, month: 2, day: 4, hour: 14, minute: 34, second: 28),
            "@2015-02-04T14:34:28+00:00 + 3 minutes": .init(timeZone: .init(secondsFromGMT: 0), year: 2015, month: 2, day: 4, hour: 14, minute: 37, second: 28)
        ]
        for (input, expected) in inputs {
            do {
                let parsedComponents = try FHIRPathExpression.evaluate(expression: input, as: DateComponents.self)
                #expect(parsedComponents.timeZone == expected.timeZone)
                #expect(parsedComponents.year == expected.year)
                #expect(parsedComponents.month == expected.month)
                #expect(parsedComponents.day == expected.day)
                #expect(parsedComponents.hour == expected.hour)
                #expect(parsedComponents.minute == expected.minute)
                #expect(parsedComponents.second == expected.second)
            }
            do {
                let parsedDate = try FHIRPathExpression.evaluate(expression: input, as: Date.self)
                var calendar = Calendar(identifier: .gregorian)
                calendar.timeZone = try #require(TimeZone(secondsFromGMT: 0))
                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: parsedDate)
                #expect(components.year == expected.year)
                #expect(components.month == expected.month)
                #expect(components.day == expected.day)
                #expect(components.hour == expected.hour)
                #expect(components.minute == expected.minute)
                #expect(components.second == expected.second)
            }
        }
    }
    
    
    @Test
    func fixedDateExpression() throws {
        let inputs: [String: DateComponents] = [
            "@2015-02-04": .init(timeZone: .current, year: 2015, month: 2, day: 4),
            "@2015-02-04 + 1 day": .init(timeZone: .current, year: 2015, month: 2, day: 5),
            "@2015-02-04 + 2 days": .init(timeZone: .current, year: 2015, month: 2, day: 6),
            "@2015-02-04 - 7 days": .init(timeZone: .current, year: 2015, month: 1, day: 28),
            "@2015-02-04 - 7 weeks": .init(timeZone: .current, year: 2014, month: 12, day: 17),
        ]
        for (input, expected) in inputs {
            do {
                let parsedComponents = try FHIRPathExpression.evaluate(expression: input, as: DateComponents.self)
                #expect(parsedComponents.timeZone == nil || parsedComponents.timeZone == expected.timeZone)
                #expect(parsedComponents.year == expected.year)
                #expect(parsedComponents.month == expected.month)
                #expect(parsedComponents.day == expected.day)
                #expect(parsedComponents.hour == nil || parsedComponents.hour == 0)
                #expect(parsedComponents.minute == nil || parsedComponents.minute == 0)
                #expect(parsedComponents.second == nil || parsedComponents.second == 0)
            }
            do {
                let parsedDate = try FHIRPathExpression.evaluate(expression: input, as: Date.self)
                let components = Calendar.current.dateComponents([.timeZone, .year, .month, .day], from: parsedDate)
                #expect(components == expected)
            }
        }
//        let date: Date = try FHIRPathExpression.evaluate(expression: "@2015-02-04 + 1 day")
//        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//        #expect(components.year == 2015)
//        #expect(components.month == 2)
//        #expect(components.day == 5)
//        #expect(components.hour == 0)
//        #expect(components.minute == 0)
//        #expect(components.second == 0)
    }
    
    
    @Test
    func unsupportedExpression() throws {
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
