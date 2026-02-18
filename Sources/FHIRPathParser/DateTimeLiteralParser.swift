//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


private let asciiDigits: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]


/// Parser for ISO8601 DateTime literals as used in FHIRPath.
/// Implemented in conformance with the `DATE`, `DATETIME`, and `TIME` rules
/// [in the FHIRPath grammar](https://hl7.org/fhirpath/N1/grammar.html)
struct DateTimeLiteralParser<Input: StringProtocol>: ~Copyable {
    enum ParseError: Error {
        case unexpectedToken(expected: [Character], found: Character?)
        case invalidInput(reason: String)
        case unsupportedLiteral
    }
    
    /// A `Date` as defined by FHIRPath.
    /// - Note: FHIRPath allows for partial `Date`s, in which case only some of the components are specified and,
    ///     starting at the first omitted component, all following components are omitted as well.
    ///     We currently do not support this; partial `Date`s are treated and represented the same as non-partial `Date`s with the omitted components set to 0.
    struct Date: Equatable {
        var year: Int = 0
        var month: Int = 0
        var day: Int = 0
        
        var components: DateComponents {
            DateComponents(year: year, month: month, day: day)
        }
    }
    
    /// A `Time` as defined by FHIRPath.
    /// - Note: FHIRPath allows for partial `Time`s, in which case only some of the components are specified and,
    ///     starting at the first omitted component, all following components are omitted as well.
    ///     We currently do not support this; partial `Time`s are treated and represented the same as non-partial `Time`s with the omitted components set to 0.
    struct Time: Equatable {
        var hour: Int = 0
        var minute: Int = 0
        var second: Int = 0
        
        init() {}
        
        init?(hour: Int = 0, minute: Int = 0, second: Int = 0) {
            guard (0..<24).contains(hour), (0..<60).contains(minute), (0..<60).contains(second) else {
                return nil
            }
            self.hour = hour
            self.minute = minute
            self.second = second
        }
        
        var components: DateComponents {
            DateComponents(hour: hour, minute: minute, second: second)
        }
    }
    
    /// A `DateTime` as defined by FHIRPath.
    /// - Note: FHIRPath allows for partial `DateTime`s, in which case the date component is specified, and the time component is omitted.
    ///     We currently do not support this; partial `DateTime`s are treated and represented the same as non-partial `DateTime`s with the ``Time`` components all set to 0.
    struct DateTime: Equatable {
        var date: Date
        var time: Time
        
        var components: DateComponents {
            DateComponents(
                year: date.year,
                month: date.month,
                day: date.day,
                hour: time.hour,
                minute: time.minute,
                second: time.second
            )
        }
    }
    
    enum Result: Equatable {
        case date(Date)
        case time(Time)
        case dateTime(DateTime)
    }
    
    private let input: Input
    private var position: Input.Index
    
    private var current: Character? {
        input[safe: position]
    }
    private var next: Character? {
        input[safe: input.index(after: position)]
    }
    private var isAtEnd: Bool {
        position >= input.endIndex
    }
    private var numRemainingTokens: Int {
        input.distance(from: position, to: input.endIndex)
    }
    
    
    private mutating func consume(_ count: Int = 1) {
        input.formIndex(&position, offsetBy: count)
    }
    
    /// Checks that the current token is equal to the specified expected value.
    /// If yes, the token is consumed (i.e., the position is advanced by 1).
    /// - Throws: if the current token is not equal to the specified expected value.
    private mutating func expectAndConsume(_ expected: Character) throws(ParseError) {
        if current == expected {
            consume()
        } else {
            throw .unexpectedToken(expected: [expected], found: current)
        }
    }
    
    /// Checks that the current token is equal to one of the specified expected values.
    /// If yes, the token is consumed (i.e., the position is advanced by 1).
    /// - parameter expected: Non-empty list of tokens we allow to appear at the current position.
    /// - Throws: if the current token is not equal to the specified expected value.
    /// - Returns: the token that matched.
    private mutating func expectAnyOfAndConsume(_ expected: [Character]) throws(ParseError) -> Character {
        if let current, expected.contains(current) {
            consume()
            return current
        } else {
            throw .unexpectedToken(expected: expected, found: current)
        }
    }
    
    
    /// Parses a decimal `Int`, consuming its digits and returning the resulting value.
    /// - Note: This function will consume tokens until it reaches the first which is not an ASCII decimal digit character.
    /// - Throws: if, when the function is called, the first token is not a decimal digit.
    private mutating func parseInt() throws(ParseError) -> Int {
        guard !isAtEnd else {
            throw .unexpectedToken(expected: asciiDigits, found: nil)
        }
        if let current, !asciiDigits.contains(current) {
            throw .unexpectedToken(expected: asciiDigits, found: current)
        }
        var value = 0
        while let current, asciiDigits.contains(current) {
            value *= 10
            // Safety: we know that current is an ascii character, and we know that the "0" literal is an ascii character.
            // Therefore, we can safely access the asciiValue for both of them.
            value += Int(current.asciiValue! - ("0" as Character).asciiValue!) // swiftlint:disable:this force_unwrapping
            consume()
        }
        return value
    }
}


extension DateTimeLiteralParser {
    // MARK: Date/Time Literal Parsing
    
    /// Parses the provided string into a FHIRPath `Date` or `DateTime` type.
    /// - Returns: A tuple of a `Date` object representing the parse result, and the `TimeZone`
    ///     in which the date should be interpreted, if specified.
    /// - Throws: if the input cannot be parsed, e.g. because it is in an invalid format.
    static func parse(_ input: Input) throws(ParseError) -> (Result, TimeZone?) {
        let parser = Self(input: input, position: input.startIndex)
        return try parser.run()
    }
    
    
    /// Implements parsing of the `DATE` and `TIME` rules defined in the grammar.
    consuming private func run() throws(ParseError) -> (Result, TimeZone?) {
        try expectAndConsume("@")
        if current == "T" {
            consume()
            let time = try parseTimeFormat()
            return (.time(time), nil)
        } else {
            let date = try parseDateFormat()
            if isAtEnd {
                // A Date, without any time information.
                return (.date(date), nil)
            } else if current == "T" {
                // Not just a Date, but a DateTime...
                consume()
                var dateTime = DateTime(date: date, time: .init())
                if isAtEnd {
                    // ...which is partial, and does not have any time information.
                    return (.dateTime(dateTime), nil)
                } else {
                    // ...which has time information following the date...
                    dateTime.time = try parseTimeFormat()
                    if isAtEnd {
                        // ...but does not specify a time zone offset.
                        return (.dateTime(dateTime), nil)
                    } else {
                        // ...and also specifies a time zone.
                        let timeZone = try parseTimeZoneOffsetFormat()
                        return (.dateTime(dateTime), timeZone)
                    }
                }
            } else {
                // we're not at the end, but the next token after the DATEFORMAT is something other than a 'T'.
                // -> this is invalid
                throw .unexpectedToken(expected: ["T"], found: current)
            }
        }
    }
    
    
    /// Implements parsing of the `TIMEFORMAT` rule defined in the grammar.
    private mutating func parseTimeFormat() throws(ParseError) -> Time {
        // [0-9][0-9] (':'[0-9][0-9] (':'[0-9][0-9] ('.'[0-9]+)?)?)?
        let hour = try parseInt()
        guard current == ":" else {
            if let time = Time(hour: hour) {
                return time
            } else {
                throw .invalidInput(reason: "Invalid hour value '\(hour)'")
            }
        }
        try expectAndConsume(":")
        let minute = try parseInt()
        guard current == ":" else {
            if let time = Time(hour: hour, minute: minute) {
                return time
            } else {
                throw .invalidInput(reason: "Invalid time value '\(hour):\(minute)'")
            }
        }
        try expectAndConsume(":")
        let second = try parseInt()
        switch current {
        case ".":
            // The time value can optionally have a fractional suffix.
            // (In ISO8601, for the last-specified component; in FHIR for the seconds component).
            // We currently do not support this.
            throw .unsupportedLiteral
        default:
            if let time = Time(hour: hour, minute: minute, second: second) {
                return time
            } else {
                throw .invalidInput(reason: "Invalid time value '\(hour):\(minute):\(second)'")
            }
        }
    }
    
    
    /// Implements parsing of the `DATEFORMAT` rule defined in the grammar.
    private mutating func parseDateFormat() throws(ParseError) -> Date {
        // [0-9][0-9][0-9][0-9] ('-'[0-9][0-9] ('-'[0-9][0-9])?)?
        let year = try parseInt()
        guard current == "-" else {
            return .init(year: year)
        }
        try expectAndConsume("-")
        let month = try parseInt()
        guard current == "-" else {
            return .init(year: year, month: month)
        }
        try expectAndConsume("-")
        let day = try parseInt()
        return .init(year: year, month: month, day: day)
    }
    
    
    /// Implements parsing of the `TIMEZONEOFFSETFORMAT` rule defined in the grammar.
    /// - Throws: if the input tokens are invalid.
    /// - Returns: a `TimeZone` matching the specified offset.
    ///     May return `nil` if the input string specified a valid (w.r.t. the grammar) offset, which however cannot be represented by the `TimeZone` type.
    private mutating func parseTimeZoneOffsetFormat() throws(ParseError) -> TimeZone? {
        // ('Z' | ('+' | '-') [0-9][0-9]':'[0-9][0-9])
        if current == "Z" {
            // if the time zone is 'Z', it is interpreted UTC.
            consume()
            // Safety: it's guaranteed that a TimeZone with this identifier exists.
            return TimeZone(identifier: "UTC")! // swiftlint:disable:this force_unwrapping
        } else {
            let `operator` = try expectAnyOfAndConsume(["+", "-"])
            let hours = try parseInt()
            try expectAndConsume(":")
            let minutes = try parseInt()
            var offsetInSeconds = 0
            offsetInSeconds += hours * 60 * 60
            offsetInSeconds += minutes * 60
            offsetInSeconds *= `operator` == "-" ? -1 : 1
            return TimeZone(secondsFromGMT: offsetInSeconds)
        }
    }
}


// MARK: Utilities

extension Collection {
    subscript(safe idx: Index) -> Element? {
        indices.contains(idx) ? self[idx] : nil
    }
}


extension Calendar {
    func dateBySetting(timeZone: TimeZone, of date: Date) -> Date? {
        var components = dateComponents(in: self.timeZone, from: date)
        components.timeZone = timeZone
        return self.date(from: components)
    }
    
    func convert(
        components: DateComponents,
        bySettingTimeZoneTo newTimeZone: TimeZone,
        componentsToReturn: Set<Component>
    ) -> DateComponents? {
        guard let date = date(from: components),
              let adjDate = dateBySetting(timeZone: newTimeZone, of: date) else {
            return nil
        }
        return dateComponents(componentsToReturn, from: adjDate)
    }
}
