//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Antlr4
import Foundation


/// Error occurred when evaluating a date expression.
public enum DateExpressionError: Error {
    /// Internal error happened when trying to parse expression. This typically means there is a faulty implementation.
    case internalError
    /// The syntax tree has an unexpected shape. This typically hints that something changed with the generated parser or grammar.
    case malformedSyntaxTree
    /// Encountered an unknown identifier.
    case unknownIdentifier(identifier: String)
    /// Unexpected count of function parameters.
    case invalidFunctionParameters(expected: Int, received: Int)
    /// Unsupported unit.
    case unsupportedUnit(unit: String)
    /// The unit is missing.
    case missingUnit
    /// Unsupported operator.
    ///
    /// The operator either doesn't semantically make sense for the combination of the two operands, or the type of the result
    /// the operator produces is not supported.
    case unsupportedOperator(operator: String)
    /// Failed a date operation when evaluating.
    case failedDateOperation(reason: FailedDateOperationReason)

    /// Encountered an invalid operator.
    case invalidOperation

    /// This term is not supported.
    case unsupportedTerm
    /// Unsupported expression.
    case unsupportedExpression
    /// Unsupported or malformed literal.
    case invalidLiteral
    /// Unsupported invocation.
    case invalidInvocation
}


extension DateExpressionError {
    /// The reason of a failed date operation.
    public enum FailedDateOperationReason {
        /// The specified date components do not form a valid date.
        case componentsDoNotFormValidDate
        /// Failed addition of a Date and date components.
        case failedAddition(Date, DateComponents)
        /// Cannot add two dates
        case cannotAddTwoDates
    }
}


extension Result where Failure == Error {
    static func failure(_ token: Token?, _ error: DateExpressionError) -> Result<Success, Failure> {
        .failure(ExpressionError(token: token, underlyingError: error))
    }
}
