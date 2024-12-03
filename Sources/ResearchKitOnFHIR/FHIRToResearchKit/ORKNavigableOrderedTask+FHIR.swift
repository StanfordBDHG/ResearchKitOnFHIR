//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable function_default_parameter_at_end
import ModelsR4
import ResearchKit
@_exported import class ResearchKit.ORKNavigableOrderedTask


extension ORKNavigableOrderedTask {
    /// Create a `ORKNavigableOrderedTask` by parsing a FHIR `Questionnaire`. Throws a `FHIRToResearchKitConversionError` if an error happens during the parsing.
    /// - Parameters:
    ///  - title: The title of the questionnaire. If you pass in a `String` the translation overrides the title that might be provided in the FHIR `Questionnaire`.
    ///  - questionnaire: The FHIR `Questionnaire` used to create the `ORKNavigableOrderedTask`.
    ///  - completionStep: An optional `ORKCompletionStep` that can be displayed at the end of the ResearchKit survey.
    public convenience init(
        title: String? = nil,
        questionnaire: Questionnaire,
        completionStep: ORKCompletionStep? = nil
    ) throws {
        guard questionnaire.item?.isEmpty == false else {
            throw FHIRToResearchKitConversionError.noItems
        }
        
        // The task ID is set to the canonical URL of the questionnaire. If not present, random UUID string will be used
        let id = questionnaire.url?.value?.url.absoluteString ?? UUID().uuidString
        
        // Convert each FHIR Questionnaire Item to an ORKStep
        var steps = questionnaire.toORKSteps()
        
        // Add a completion step at the end of the task if defined
        if let completionStep = completionStep {
            steps.append(completionStep)
        }
        
        self.init(identifier: id, steps: steps)
        
        // If any questions have defined skip logic, convert to ResearchKit navigation rules
        try constructNavigationRules(for: questionnaire.flattenedItems)
    }
}


extension Questionnaire {
    /// All items in the questionnaire, flattened.
    /// - Note: individual items in the returned array may still contain nested items;
    ///     the purpose of this property is to easily be able to access all items in the questionnaire, without having to explicitly take any nesting into account.
    var flattenedItems: [QuestionnaireItem] {
        flattenedItems()
    }
    
    /// Flattens all `QuestionnaireItem`s in the questionnaire into an array.
    /// - parameter predicate: A predicate for filtering which items should be included. By default, all items are included.
    ///     Note that excluding an item via the predicate will only exclude it from being added to the returned array.
    ///     Children of excluded items will still be considered and may be included in the returned value, if the predicate returns true.
    private func flattenedItems(
        filter predicate: (QuestionnaireItem) -> Bool = { _ in true }
    ) -> [QuestionnaireItem] {
        var retval: [QuestionnaireItem] = []
        func imp(_ item: QuestionnaireItem) {
            if predicate(item) {
                retval.append(item)
            }
            item.item?.forEach(imp)
        }
        item?.forEach(imp)
        return retval
    }
    
    // TODO check that this is correct (eg: it should skip sections/etc!)
    var flattenedQuestions: [QuestionnaireItem] {
        flattenedItems { $0.type.value?.isDirectlyAnswerableQuestion == true }
    }
}



extension QuestionnaireItemType {
    /// Whether the item type refers to a directly answerable question.
    public var isDirectlyAnswerableQuestion: Bool {
        switch self {
        case .group:
            false
        case .display:
            false
        case .question, .boolean, .decimal, .integer, .date, .dateTime, .time, .string, .text, .url, .choice, .openChoice, .attachment, .reference, .quantity:
            true
        }
    }
}
