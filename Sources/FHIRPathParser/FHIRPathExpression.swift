//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Antlr4
import Foundation


/// A type can be evaluated from a FHIRPath expression.
public protocol _FHIRPathValue { // swiftlint:disable:this type_name
    /// Evaluate the expression for the given type
    /// - Parameter expression: The expression to evalaute.
    /// - Returns: The resulting value
    /// - Throws: Domain-specific error if the evaluation failed. Should use ``ExpressionError``.
    static func evaluate(_ expression: FHIRPathParser.ExpressionContext) throws -> Self
}


/// Evaluate FHIRPath expressions.
public enum FHIRPathExpression {
    /// Evaluate a FHIRPath expression.
    ///
    /// For more information refer to [FHIRPath](https://hl7.org/fhirpath/).
    ///
    /// Below is a short code example on how to evaluate a Date expression:
    /// ```swift
    /// let date: Date = try FHIRPathExpression.evalaute("today() + 3 months")
    /// ```
    ///
    /// - Parameters:
    ///   - expression: The FHIRPath expression to evaluate.
    ///   - value: The Swift Type the expression should be evalauted to.
    /// - Returns: The evalauted value.
    /// - Throws: Throws an error of ``ExpressionError`` if evaluation failed. Throws a respective parser error if the
    ///     provided expression doesn't follow the FHIRPath grammar.
    public static func evaluate<Value: _FHIRPathValue>(expression: String, as value: Value.Type = Value.self) throws -> Value {
        let stream = ANTLRInputStream(expression)
        let lexer = FHIRPathLexer(stream)
        let tokenStream = CommonTokenStream(lexer)
        let parser = try FHIRPathParser(tokenStream)
        let expression = try parser.expression()
        return try value.evaluate(expression)
    }
}
