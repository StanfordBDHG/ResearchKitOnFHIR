//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
import ResearchKit


extension ORKNavigableOrderedTask {
    /// This method converts predicates contained in the  "enableWhen" property on FHIR `QuestionnaireItem` to ResearchKit `ORKPredicateSkipStepNavigationRule` which are applied to an `ORKNavigableOrderedTask`.
    /// - Parameters:
    ///    - questions: An array of FHIR QuestionnaireItem objects.
    func constructNavigationRules(for items: [QuestionnaireItem]) throws {
        for item in items {
            guard let itemId = item.linkId.value?.string,
                  let enableWhen = item.enableWhen,
                  !enableWhen.isEmpty else {
                continue
            }
            
            let enableBehavior = item.enableBehavior?.value ?? .all
            // The translation from FHIR to ResearchKit predicates requires negating the FHIR predicates
            // as FHIR predicates activate steps while ResearchKit uses them to skip steps.
            let allPredicates = try enableWhen.compactMap { try $0.predicate?.negated() }
            let predicate: NSPredicate
            switch enableBehavior {
            case .all:
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: allPredicates)
            case .any:
                predicate = NSCompoundPredicate(orPredicateWithSubpredicates: allPredicates)
            }
            self.setSkip(ORKPredicateSkipStepNavigationRule(resultPredicate: predicate), forStepIdentifier: itemId)
        }
    }
}


extension QuestionnaireItemEnableWhen {
    /// The enableWhen, as a `NSPredicate`.
    /// - Note: This predicate will evaluate to true if the item should be enabled.
    ///     When using it with e.g. ResearchKit, you will typically need to negate it, since in that context
    ///     predicates are used mainly to determine when a step should be skipped (i.e., disabled).
    fileprivate var predicate: NSPredicate? {
        get throws {
            guard let enableQuestionId = question.value?.string,
                  let fhirOperator = `operator`.value else {
                return nil
            }
            let resultSelector = ORKResultSelector(resultIdentifier: enableQuestionId)
            switch answer {
            case .coding(let coding):
                return try coding.predicate(with: resultSelector, operator: fhirOperator)
            case .boolean(let boolean):
                return try boolean.predicate(with: resultSelector, operator: fhirOperator)
            case .date(let fhirDate):
                return try fhirDate.predicate(with: resultSelector, operator: fhirOperator)
            case .integer(let integerValue):
                return try integerValue.predicate(with: resultSelector, operator: fhirOperator)
            case .decimal(let decimalValue):
                return try decimalValue.predicate(with: resultSelector, operator: fhirOperator)
            default:
                throw FHIRToResearchKitConversionError.unsupportedAnswer(answer)
            }
        }
    }
}


extension Coding {
    fileprivate func predicate(with resultSelector: ORKResultSelector, operator fhirOperator: QuestionnaireItemOperator) throws -> NSPredicate? {
        guard let code = code?.value?.string,
              let system = system?.value?.url.absoluteString else {
            return nil
        }
        
        let expectedAnswer = ValueCoding(code: code, system: system, display: display?.value?.string)
        let predicate = ORKResultPredicate.predicateForChoiceQuestionResult(
            with: resultSelector,
            matchingPattern: expectedAnswer.patternForMatchingORKChoiceQuestionResult
        )
        switch fhirOperator {
        case .equal:
            return predicate
        case .notEqual:
            return predicate.negated()
        default:
            throw FHIRToResearchKitConversionError.unsupportedOperator(fhirOperator)
        }
    }
}

extension FHIRPrimitive where PrimitiveType == FHIRBool {
    fileprivate func predicate(with resultSelector: ORKResultSelector, operator fhirOperator: QuestionnaireItemOperator) throws -> NSPredicate? {
        guard let booleanValue = value?.bool else {
            return nil
        }
        switch fhirOperator {
        case .exists:
            let noAnswerPredicate = ORKResultPredicate.predicateForNilQuestionResult(with: resultSelector)
            // if booleanValue is true, then what we're checking for here is `EXISTS == TRUE`,
            // which is of course the same as "NO ANSWER == FALSE", hence why we need to negate in that case.
            return booleanValue ? noAnswerPredicate.negated() : noAnswerPredicate
        case .equal:
            return ORKResultPredicate.predicateForBooleanQuestionResult(
                with: resultSelector,
                expectedAnswer: booleanValue
            )
        case .notEqual:
            return ORKResultPredicate.predicateForBooleanQuestionResult(
                with: resultSelector,
                expectedAnswer: !booleanValue
            )
        default:
            throw FHIRToResearchKitConversionError.unsupportedOperator(fhirOperator)
        }
    }
}

extension FHIRPrimitive where PrimitiveType == FHIRDate {
    fileprivate func predicate(with resultSelector: ORKResultSelector, operator fhirOperator: QuestionnaireItemOperator) throws -> NSPredicate? {
        guard let value else {
            // If there is no value, there is nothing we can check against.
            return nil
        }
        let date: Date
        do {
            date = try value.asNSDate()
        } catch {
            throw FHIRToResearchKitConversionError.invalidDate(self)
        }
        switch fhirOperator {
        case .greaterThanOrEqual:
            return ORKResultPredicate.predicateForDateQuestionResult(
                with: resultSelector,
                minimumExpectedAnswer: date,
                maximumExpectedAnswer: nil
            )
        case .lessThanOrEqual:
            return ORKResultPredicate.predicateForDateQuestionResult(
                with: resultSelector,
                minimumExpectedAnswer: nil,
                maximumExpectedAnswer: date
            )
        case .greaterThan:
            return ORKResultPredicate.predicateForDateQuestionResult(
                with: resultSelector,
                minimumExpectedAnswer: Date(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate.nextUp),
                maximumExpectedAnswer: nil
            )
        case .lessThan:
            return ORKResultPredicate.predicateForDateQuestionResult(
                with: resultSelector,
                minimumExpectedAnswer: nil,
                maximumExpectedAnswer: Date(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate.nextDown)
            )
        default:
            throw FHIRToResearchKitConversionError.unsupportedOperator(fhirOperator)
        }
    }
}

extension FHIRPrimitive where PrimitiveType == FHIRInteger {
    fileprivate func predicate(with resultSelector: ORKResultSelector, operator fhirOperator: QuestionnaireItemOperator) throws -> NSPredicate? {
        guard let integerValue = value?.integer else {
            return nil
        }
        
        switch fhirOperator {
        case .equal:
            return ORKResultPredicate.predicateForNumericQuestionResult(
                with: resultSelector,
                expectedAnswer: Int(integerValue)
            )
        case .notEqual:
            return ORKResultPredicate.predicateForNumericQuestionResult(
                with: resultSelector,
                expectedAnswer: Int(integerValue)
            ).negated() // swiftlint:disable:this multiline_function_chains
        case .lessThanOrEqual:
            return ORKResultPredicate.predicateForNumericQuestionResult(
                with: resultSelector,
                maximumExpectedAnswerValue: Double(integerValue)
            )
        case .greaterThanOrEqual:
            return ORKResultPredicate.predicateForNumericQuestionResult(
                with: resultSelector,
                minimumExpectedAnswerValue: Double(integerValue)
            )
        case .lessThan:
            return ORKResultPredicate.predicateForNumericQuestionResult(
                with: resultSelector,
                maximumExpectedAnswerValue: Double(integerValue).nextDown
            )
        case .greaterThan:
            return ORKResultPredicate.predicateForNumericQuestionResult(
                with: resultSelector,
                minimumExpectedAnswerValue: Double(integerValue).nextUp
            )
        default:
            throw FHIRToResearchKitConversionError.unsupportedOperator(fhirOperator)
        }
    }
}

extension FHIRPrimitive where PrimitiveType == FHIRDecimal {
    fileprivate func predicate(with resultSelector: ORKResultSelector, operator fhirOperator: QuestionnaireItemOperator) throws -> NSPredicate? {
        guard let doubleValue = value?.decimal.doubleValue else {
            return nil
        }
        
        switch fhirOperator {
        case .equal:
            return ORKResultPredicate.predicateForNumericQuestionResult(
                with: resultSelector,
                expectedAnswer: doubleValue
            )
        case .notEqual:
            return ORKResultPredicate.predicateForNumericQuestionResult(
                with: resultSelector,
                expectedAnswer: doubleValue
            ).negated() // swiftlint:disable:this multiline_function_chains
        case .lessThanOrEqual:
            return ORKResultPredicate.predicateForNumericQuestionResult(
                with: resultSelector,
                maximumExpectedAnswerValue: doubleValue
            )
        case .greaterThanOrEqual:
            return ORKResultPredicate.predicateForNumericQuestionResult(
                with: resultSelector,
                minimumExpectedAnswerValue: doubleValue
            )
        case .lessThan:
            return ORKResultPredicate.predicateForNumericQuestionResult(
                with: resultSelector,
                maximumExpectedAnswerValue: doubleValue.nextDown
            )
        case .greaterThan:
            return ORKResultPredicate.predicateForNumericQuestionResult(
                with: resultSelector,
                minimumExpectedAnswerValue: doubleValue.nextUp
            )
        default:
            throw FHIRToResearchKitConversionError.unsupportedOperator(fhirOperator)
        }
    }
}


// MARK: Utilities

extension Decimal {
    fileprivate var doubleValue: Double {
        NSDecimalNumber(decimal: self).doubleValue
    }
}


extension NSPredicate {
    /// Returns a negated version of the predicate.
    func negated() -> NSPredicate {
        if let predicte = self as? NSCompoundPredicate,
           predicte.compoundPredicateType == .not,
           predicte.subpredicates.count == 1,
           let subpred = predicte.subpredicates.first as? NSPredicate {
            // if the predicate is already negated, we return the inner (i.e., non-negated) predicate.
            return subpred
        } else {
            return NSCompoundPredicate(notPredicateWithSubpredicate: self)
        }
    }
}


extension ORKResultPredicate {
    /// Constructs a predicate which evaluates to true if the answer for the selector is equal to the specified value.
    static func predicateForNumericQuestionResult(
        with selector: ORKResultSelector,
        expectedAnswer value: Double
    ) -> NSPredicate {
        Self.predicateForNumericQuestionResult(
            with: selector,
            minimumExpectedAnswerValue: value,
            maximumExpectedAnswerValue: value
        )
    }
}
