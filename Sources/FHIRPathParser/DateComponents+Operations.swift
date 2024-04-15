//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


extension DateComponents {
    static var supportedKeyPaths: [WritableKeyPath<DateComponents, Int?>] {
        [\.year, \.month, \.weekOfYear, \.day, \.hour, \.minute, \.second, \.nanosecond]
    }

    static prefix func - (components: DateComponents) -> DateComponents {
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

    static func + (lhs: DateComponents, rhs: DateComponents) -> DateComponents {
        var result = DateComponents()

        for keyPath in Self.supportedKeyPaths {
            guard lhs[keyPath: keyPath] != nil || rhs[keyPath: keyPath] != nil else {
                continue
            }

            result[keyPath: keyPath] = (lhs[keyPath: keyPath] ?? 0) + (rhs[keyPath: keyPath] ?? 0)
        }

        return result
    }
}
