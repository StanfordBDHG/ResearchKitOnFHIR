//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


extension Date: _FHIRPathValue {
    public static func evaluate(_ expression: FHIRPathParser.ExpressionContext) throws -> Date {
        switch expression.accept(DateExpressionEvaluation()) {
        case .none:
            throw DateExpressionError.internalError
        case let .failure(error):
            throw error
        case let .success(value):
            switch value {
            case let .components(components):
                // if the date components represent a valid date, we try the conversion
                guard let date = Calendar.current.date(from: components) else {
                    throw DateExpressionError.failedDateOperation(reason: .componentsDoNotFormValidDate)
                }
                return date
            case let .date(date):
                return date
            }
        }
    }
}


extension DateComponents: _FHIRPathValue {
    public static func evaluate(_ expression: FHIRPathParser.ExpressionContext) throws -> DateComponents {
        switch expression.accept(DateExpressionEvaluation()) {
        case .none:
            throw DateExpressionError.internalError
        case let .failure(error):
            throw error
        case let .success(value):
            switch value {
            case let .components(components):
                return components
            case let .date(date):
                return Calendar.current.dateComponents(
                    [.timeZone, .year, .month, .day, .hour, .minute, .second],
                    from: date
                )
            }
        }
    }
}
