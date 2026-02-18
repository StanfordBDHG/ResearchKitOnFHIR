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

@Suite
struct DateTimeLiteralParserTests {
    @Test
    func parseSimple() throws {
        do {
            let (result, timeZone) = try DateTimeLiteralParser.parse("@1998-06-02T13:15:00-05:00")
            #expect(try result == .dateTime(.init(
                date: .init(year: 1998, month: 6, day: 2),
                time: #require(DateTimeLiteralParser.Time(hour: 13, minute: 15, second: 0))
            )))
            #expect(timeZone == .init(secondsFromGMT: -18000))
        }
        do {
            let (result, timeZone) = try DateTimeLiteralParser.parse("@1998-06-03T02:15:00+08:00")
            #expect(try result == .dateTime(.init(
                date: .init(year: 1998, month: 6, day: 3),
                time: #require(DateTimeLiteralParser.Time(hour: 2, minute: 15, second: 0))
            )))
            #expect(timeZone == .init(secondsFromGMT: 28800))
        }
        do {
            let (result, timeZone) = try DateTimeLiteralParser.parse("@1998-06-02T18:15:00Z")
            #expect(try result == .dateTime(.init(
                date: .init(year: 1998, month: 6, day: 2),
                time: #require(DateTimeLiteralParser.Time(hour: 18, minute: 15, second: 0))
            )))
            #expect(timeZone == .gmt)
        }
        do {
            let (result, timeZone) = try DateTimeLiteralParser.parse("@2017-11-05T01:30:00-04:00")
            #expect(try result == .dateTime(.init(
                date: .init(year: 2017, month: 11, day: 5),
                time: #require(DateTimeLiteralParser.Time(hour: 1, minute: 30, second: 0))
            )))
            #expect(timeZone == .init(secondsFromGMT: -14400))
        }
    }
    
    @Test
    func timeOnly() throws {
        let inputs: [String: DateComponents] = [
            "@T10:30:00": .init(hour: 10, minute: 30, second: 0),
            "@T11:21:09": .init(hour: 11, minute: 21, second: 9),
            "@T14:34:28": .init(hour: 14, minute: 34, second: 28)
        ]
        for (input, expected) in inputs {
            let (result, timeZone) = try DateTimeLiteralParser.parse(input)
            #expect(timeZone == nil)
            switch result {
            case .time(let time):
                #expect(time.hour == expected.hour)
                #expect(time.minute == expected.minute)
                #expect(time.second == expected.second)
            case .date, .dateTime:
                Issue.record("Invalid result: expected a time, got \(result)")
            }
        }
    }
}
