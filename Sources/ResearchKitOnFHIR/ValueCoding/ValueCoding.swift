//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


struct ValueCoding: Equatable, Codable, RawRepresentable {
    enum CodingKeys: String, CodingKey {
        case code
        case system
    }
    
    
    let code: String
    let system: String
    
    
    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self) else {
            return "{}"
        }
        
        return String(decoding: data, as: UTF8.self)
    }
    
    
    init(code: String, system: String) {
        self.code = code
        self.system = system
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
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(system, forKey: .system)
    }
}
