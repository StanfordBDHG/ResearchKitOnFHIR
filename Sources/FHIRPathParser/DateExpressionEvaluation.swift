//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Antlr4
import Foundation


enum DateEvaluationValue {
    case date(Date)
    case components(DateComponents)
}


final class DateExpressionEvaluation: FHIRPathBaseVisitor<Result<DateEvaluationValue, Error>> {
    private lazy var now = Date.now // ensure today is consistent across tokens

    override func visitPolarityExpression(_ ctx: FHIRPathParser.PolarityExpressionContext) -> Result<DateEvaluationValue, Error>? {
        guard let `operator` = ctx.getToken(at: 0),
              let expression = ctx.expression() else {
            return .failure(ctx.start, .malformedSyntaxTree)
        }

        let evaluation = expression.accept(self)
        guard case var .success(value) = evaluation else {
            return evaluation // propagate error
        }

        if `operator`.getText() == "-" {
            guard case let .components(dateComponents) = value else {
                // taking the inverse of a date doesn't make sense
                return .failure(`operator`.getSymbol(), .unsupportedOperator(operator: `operator`.getText()))
            }

            value = .components(-dateComponents)
        }

        return .success(value)
    }

    override func visitAdditiveExpression(_ ctx: FHIRPathParser.AdditiveExpressionContext) -> Result<DateEvaluationValue, Error>? {
        guard let lhs = ctx.expression(0),
              let `operator` = ctx.getToken(at: 0),
              let rhs = ctx.expression(1) else {
            return .failure(ctx.start, .malformedSyntaxTree)
        }

        guard `operator`.getText() == "+" || `operator`.getText() == "-" else {
            // we don't support '&' on dates
            return .failure(`operator`.getSymbol(), .unsupportedOperator(operator: `operator`.getText()))
        }

        let lhsEvaluation = lhs.accept(self)

        guard case let .success(lhsValue) = lhsEvaluation else {
            return lhsEvaluation // propagate error
        }

        let rhsEvaluation = rhs.accept(self)

        guard case var .success(rhsValue) = rhsEvaluation else {
            return rhsEvaluation // propagate error
        }

        if `operator`.getText() == "-" {
            guard case let .components(dateComponents) = rhsValue else {
                // subtracting two dates doesn't make sense
                return .failure(`operator`.getSymbol(), .unsupportedOperator(operator: `operator`.getText()))
            }

            rhsValue = .components(-dateComponents)
        }

        switch (lhsValue, rhsValue) {
        case let (.date(date), .components(components)),
             let (.components(components), .date(date)):
            guard let result = Calendar.current.date(byAdding: components, to: date) else {
                return .failure(DateExpressionError.failedDateOperation(reason: .failedAddition(date, components)))
            }
            return .success(.date(result))
        case (.date, .date):
            return .failure(ctx.getStart(), .failedDateOperation(reason: .cannotAddTwoDates))
        case let (.components(lhs), .components(rhs)):
            return .success(.components(lhs + rhs))
        }
    }

    override func visitLiteralTerm(_ ctx: FHIRPathParser.LiteralTermContext) -> Result<DateEvaluationValue, Error>? {
        guard let result = visitChildren(ctx) else {
            // literals like string, null, bool, numbers, ... are not supported with date expressions
            return .failure(ctx.start, .invalidLiteral)
        }

        return result
    }

    override func visitDateTimeLiteral(_ ctx: FHIRPathParser.DateTimeLiteralContext) -> Result<DateEvaluationValue, Error>? {
        guard let node = ctx.DATETIME() else {
            return .failure(ctx.start, .malformedSyntaxTree)
        }

        // we either have a date like `@2015-02-04`
        // or we have a date time like `@2015-02-04T14:34:28+09:00`
        // so we need two different parsers

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        let dateTimeFormatter = ISO8601DateFormatter()
        dateTimeFormatter.formatOptions = .withInternetDateTime

        let text = node.getText()
        let startIndex = text.index(after: text.startIndex) // skip the `@`

        let string = String(text.suffix(from: startIndex))

        guard let date = dateTimeFormatter.date(from: string) ?? dateFormatter.date(from: string) else {
            return .failure(node.getSymbol(), .invalidLiteral)
        }

        return .success(.date(date))
    }

    override func visitTimeLiteral(_ ctx: FHIRPathParser.TimeLiteralContext) -> Result<DateEvaluationValue, Error>? {
        guard let node = ctx.TIME() else {
            return .failure(ctx.start, .malformedSyntaxTree)
        }

        return .failure(node.getSymbol(), .unsupportedTerm) // we currently cannot represent time
    }

    // swiftlint:disable:next cyclomatic_complexity
    override func visitQuantityLiteral(_ ctx: FHIRPathParser.QuantityLiteralContext) -> Result<DateEvaluationValue, Error>? {
        guard let quantity = ctx.quantity(),
              let number = quantity.NUMBER() else {
            return .failure(ctx.start, .malformedSyntaxTree)
        }

        guard let unit = quantity.unit() else {
            return .failure(quantity.start, .missingUnit)
        }

        let precision: String
        if let singular = unit.dateTimePrecision() {
            precision = singular.getText()
        } else if let plural = unit.pluralDateTimePrecision() {
            precision = plural.getText()
        } else if let string = unit.STRING() {
            return .failure(string.getSymbol(), .unsupportedUnit(unit: string.getText()))
        } else {
            return .failure(unit.start, .unsupportedUnit(unit: unit.getText()))
        }

        guard var value = Int(number.getText()) else {
            return .failure(number.getSymbol(), .invalidLiteral)
        }

        let keyPath: WritableKeyPath<DateComponents, Int?>
        switch precision {
        case "year", "years":
            keyPath = \.year
        case "month", "months":
            keyPath = \.month
        case "week", "weeks":
            keyPath = \.weekOfYear
        case "day", "days":
            keyPath = \.day
        case "hour", "hours":
            keyPath = \.hour
        case "minute", "minutes":
            keyPath = \.minute
        case "second", "seconds":
            keyPath = \.second
        case "millisecond", "milliseconds":
            keyPath = \.nanosecond
            value *= 1_000_000
        default:
            return .failure(unit.start, .unsupportedUnit(unit: unit.getText()))
        }
        if !DateComponents.supportedKeyPaths.contains(keyPath) {
            return .failure(unit.start, .internalError)
        }

        var components = DateComponents()
        components[keyPath: keyPath] = value
        return .success(.components(components))
    }

    override func visitInvocationTerm(_ ctx: FHIRPathParser.InvocationTermContext) -> Result<DateEvaluationValue, Error>? {
        guard let invocation = ctx.invocation() else {
            return .failure(ctx.start, .malformedSyntaxTree)
        }

        guard let functionInvocation = invocation as? FHIRPathParser.FunctionInvocationContext else {
            // we don't support $this, $index, $total or identifier based invocations
            return .failure(invocation.start, .invalidInvocation)
        }

        guard let function = functionInvocation.function(),
              let identifier = function.identifier(),
              let identifierToken = identifier.IDENTIFIER() else {
            return .failure(functionInvocation.start, .malformedSyntaxTree)
        }

        // see https://build.fhir.org/ig/HL7/FHIRPath/#current-date-and-time-functions
        switch identifierToken.getText() {
        case "today", "now":
            if let paramList = function.paramList() {
                return .failure(paramList.start, .invalidFunctionParameters(expected: 0, received: (paramList.getChildCount() / 2) + 1))
            }

            let date: Date
            if identifierToken.getText() == "today" { // yields a Date
                let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: now)
                date = Calendar.current.date(from: todayComponents) ?? now
            } else { // "now" yields a DateTime
                date = now
            }

            return .success(.date(date))
        default:
            return .failure(identifierToken.getSymbol(), .unknownIdentifier(identifier: identifierToken.getText()))
        }
    }


    override func aggregateResult(
        _ aggregate: Result<DateEvaluationValue, Error>?,
        _ nextResult: Result<DateEvaluationValue, Error>?
    ) -> Result<DateEvaluationValue, Error>? {
        nextResult ?? aggregate
    }

    // MARK: - Unsupported

    override func visitExternalConstant(_ ctx: FHIRPathParser.ExternalConstantContext) -> Result<DateEvaluationValue, Error>? {
        .failure(ctx.start, .unsupportedTerm)
    }

    override func visitInvocationExpression(_ ctx: FHIRPathParser.InvocationExpressionContext) -> Result<DateEvaluationValue, Error>? {
        .failure(ctx.start, .unsupportedExpression)
    }

    override func visitIndexerExpression(_ ctx: FHIRPathParser.IndexerExpressionContext) -> Result<DateEvaluationValue, Error>? {
        .failure(ctx.start, .unsupportedExpression)
    }

    override func visitMultiplicativeExpression(_ ctx: FHIRPathParser.MultiplicativeExpressionContext) -> Result<DateEvaluationValue, Error>? {
        returnUnsupportedOperator(for: ctx)
    }

    override func visitTypeExpression(_ ctx: FHIRPathParser.TypeExpressionContext) -> Result<DateEvaluationValue, Error>? {
        returnUnsupportedOperator(for: ctx)
    }

    override func visitUnionExpression(_ ctx: FHIRPathParser.UnionExpressionContext) -> Result<DateEvaluationValue, Error>? {
        returnUnsupportedOperator(for: ctx)
    }

    override func visitInequalityExpression(_ ctx: FHIRPathParser.InequalityExpressionContext) -> Result<DateEvaluationValue, Error>? {
        returnUnsupportedOperator(for: ctx)
    }

    override func visitEqualityExpression(_ ctx: FHIRPathParser.EqualityExpressionContext) -> Result<DateEvaluationValue, Error>? {
        returnUnsupportedOperator(for: ctx)
    }

    override func visitMembershipExpression(_ ctx: FHIRPathParser.MembershipExpressionContext) -> Result<DateEvaluationValue, Error>? {
        returnUnsupportedOperator(for: ctx)
    }

    override func visitAndExpression(_ ctx: FHIRPathParser.AndExpressionContext) -> Result<DateEvaluationValue, Error>? {
        returnUnsupportedOperator(for: ctx)
    }

    override func visitOrExpression(_ ctx: FHIRPathParser.OrExpressionContext) -> Result<DateEvaluationValue, Error>? {
        returnUnsupportedOperator(for: ctx)
    }

    override func visitImpliesExpression(_ ctx: FHIRPathParser.ImpliesExpressionContext) -> Result<DateEvaluationValue, Error>? {
        returnUnsupportedOperator(for: ctx)
    }

    private func returnUnsupportedOperator<Context: ParserRuleContext>(for context: Context) -> Result<DateEvaluationValue, Error> {
        let opToken = context.getToken(at: 0)
        let string = opToken?.getText() ?? context.getText()
        return .failure(opToken?.getSymbol(), .unsupportedOperator(operator: string))
    }
}


extension ParserRuleContext {
    fileprivate func getToken(at index: Int = 0) -> TerminalNode? {
        guard let children else {
            return nil
        }

        var currentIndex = 0

        for child in children {
            guard let node = child as? TerminalNode else {
                continue
            }

            if currentIndex == index {
                return node
            }
            currentIndex += 1
        }

        return nil
    }
}
