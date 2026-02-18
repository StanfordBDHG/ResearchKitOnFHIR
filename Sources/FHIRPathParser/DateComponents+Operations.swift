//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


extension DateComponents {
    static var supportedKeyPaths: [WritableKeyPath<Self, Int?>] {
        [\.year, \.month, \.weekOfYear, \.day, \.hour, \.minute, \.second, \.nanosecond]
    }
    
    static prefix func - (components: Self) -> Self {
        var components = components
        for keyPath in Self.supportedKeyPaths {
            // check if the value is set
            guard let value = components[keyPath: keyPath] else {
                continue
            }
            components[keyPath: keyPath] = -value
        }
        return components
    }
}


extension DateComponents {
    var hasYear: Bool {
        year != nil
    }
}


extension Calendar {
    func components(byAdding rhs: DateComponents, to lhs: DateComponents) -> DateComponents? {
        if !lhs.hasYear && rhs.hasYear {
            // swap so that lhs has a year
            return components(byAdding: lhs, to: rhs)
        }
        let timeZone = lhs.timeZone ?? rhs.timeZone ?? self.timeZone
        var lhs = lhs
        lhs.timeZone = timeZone
        guard let lhsDate = self.date(from: lhs) else {
            return nil
        }
        guard let sumDate = self.date(byAdding: rhs, to: lhsDate) else {
            return nil
        }
        var result = self.dateComponents(in: timeZone, from: sumDate)
        result.calendar = nil
        return result
    }
}
