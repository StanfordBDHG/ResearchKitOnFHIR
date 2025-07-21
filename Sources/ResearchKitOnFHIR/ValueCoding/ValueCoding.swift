//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


struct ValueCoding: Equatable, Codable, RawRepresentable {
    enum CodingKeys: String, CodingKey {
        case code
        case system
        case display
    }
    
    
    let code: String
    let system: String
    let display: String?
    
    var rawValue: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        
        guard let data = try? encoder.encode(self) else {
            return "{}"
        }
        
        return String(decoding: data, as: UTF8.self)
    }
    
    
    init(code: String, system: String, display: String?) {
        self.code = code
        self.system = system
        self.display = display
    }
    
    init?(rawValue: String) {
        let data = Data(rawValue.utf8)
        guard let valueCoding = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        
        self = valueCoding
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try values.decode(String.self, forKey: .code)
        self.system = try values.decode(String.self, forKey: .system)
        self.display = try values.decodeIfPresent(String.self, forKey: .display)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(system, forKey: .system)
        try container.encode(display, forKey: .display)
    }
}


extension ValueCoding {
    /// Returns a regular expression which can be used when creating `ORKChoiceQuestionResult` predicates.
    /// The reason why this exists, is that there might, in some cases, be a mismatch between the information we have here
    /// in the ValueCoding, and the information the `ORKChoiceQuestionResult` stores.
    /// This is caused by the fact that in the context in which the question is answered (i.e., in the context of the question item itself),
    /// the `display` value is known (and encoded into the result object), but if we want to check for some previous question's result
    /// (e.g., in the context of a later question's `enableWhen` conditions), then the `display` value will not be known.
    /// (Because it typically isn't included in the `enableWhen` condition.)
    /// However, if we were to check the `enableWhen` condition's valueCoding against the one of the question answering context,
    /// we'd end up comparing one with a null `display` value against one with a non-null `display` value.
    /// (This would, obviously, cause the comparison to always fail, and conditional questions would never be enabled and presented to the patient.)
    var patternForMatchingORKChoiceQuestionResult: String { // swiftlint:disable:this identifier_name
        let jsonEncodedCode = (try? String(data: JSONEncoder().encode(code), encoding: .utf8)) ?? code
        let escapedCode = NSRegularExpression.escapedPattern(for: jsonEncodedCode)
        let jsonEncodedSystem = (try? String(data: JSONEncoder().encode(system), encoding: .utf8)) ?? system
        let escapedSystem = NSRegularExpression.escapedPattern(for: jsonEncodedSystem)
        if let display {
            let jsonEncodedDisplay = (try? String(data: JSONEncoder().encode(display), encoding: .utf8)) ?? display
            let escapedDisplay = NSRegularExpression.escapedPattern(for: jsonEncodedDisplay)
            let pattern = #"^\{"code":"\#(escapedCode)","display":"\#(escapedDisplay)","system":"\#(escapedSystem)"\}$"#
            print("PATTERN", pattern)
            return pattern
        } else {
            let pattern = #"^\{"code":"\#(escapedCode)","display":.*,"system":"\#(escapedSystem)"\}$"#
            print("PATTERN", pattern)
            return pattern
        }
    }
}
