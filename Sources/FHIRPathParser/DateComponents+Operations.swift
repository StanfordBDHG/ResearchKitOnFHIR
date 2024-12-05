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

    
    static func + (lhs: Self, rhs: Self) -> Self {
        var result = Self()
        for keyPath in Self.supportedKeyPaths {
            guard lhs[keyPath: keyPath] != nil || rhs[keyPath: keyPath] != nil else {
                // if the component is nil in both inputs, we keep it nil in the output.
                continue
            }
            result[keyPath: keyPath] = (lhs[keyPath: keyPath] ?? 0) + (rhs[keyPath: keyPath] ?? 0)
        }
        return result
    }
}
