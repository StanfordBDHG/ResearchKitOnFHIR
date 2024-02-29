//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsR4


extension QuestionnaireItem {
    /// Supported FHIR extensions for QuestionnaireItems
    private enum SupportedExtensions {
        static let itemControl = "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl"
        static let questionnaireUnit = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
        static let regex = "http://hl7.org/fhir/StructureDefinition/regex"
        static let sliderStepValue = "http://hl7.org/fhir/StructureDefinition/questionnaire-sliderStepValue"
        static let validationMessage = "http://biodesign.stanford.edu/fhir/StructureDefinition/validationtext"
        static let maxDecimalPlaces = "http://hl7.org/fhir/StructureDefinition/maxDecimalPlaces"
        static let minValue = "http://hl7.org/fhir/StructureDefinition/minValue"
        static let maxValue = "http://hl7.org/fhir/StructureDefinition/maxValue"
        static let hidden = "http://hl7.org/fhir/StructureDefinition/questionnaire-hidden"
    }
    
    
    /// Is the question hidden
    /// - Returns: A boolean representing whether the question should be shown to the user
    var hidden: Bool {
        guard let hiddenExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.hidden),
              case let .boolean(booleanValue) = hiddenExtension.value,
              let isHidden = booleanValue.value?.bool as? Bool else {
            return false
        }
        return isHidden
    }

    /// Defines the control type for the answer for a question
    /// - Returns: A code representing the control type (i.e. slider)
    var itemControl: String? {
        guard let itemControlExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.itemControl),
              case let .codeableConcept(concept) = itemControlExtension.value,
              let itemControlCode = concept.coding?.first?.code?.value?.string else {
            return nil
        }
        return itemControlCode
    }

    
    /// The minimum value for a numerical answer.
    /// - Returns: An optional `NSNumber` containing the minimum value allowed.
    var minValue: NSNumber? {
        guard let minValueExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.minValue),
              case let .integer(integerValue) = minValueExtension.value,
              let minValue = integerValue.value?.integer as? Int32 else {
            return nil
        }
        return NSNumber(value: minValue)
    }
    
    /// The minimum value for a date answer.
    /// - Returns: An optional `Date` containing the minimum date allowed.
    var minDateValue: Date? {
        guard let minValueExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.minValue),
              case let .date(dateValue) = minValueExtension.value,
              let minDateValue = dateValue.value?.asDateAtStartOfDay
        else {
            return nil
        }
        
        return minDateValue
    }
    
    /// The maximum value for a numerical answer.
    /// - Returns: An optional `NSNumber` containing the maximum value allowed.
    var maxValue: NSNumber? {
        guard let maxValueExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.maxValue),
              case let .integer(integerValue) = maxValueExtension.value,
              let maxValue = integerValue.value?.integer as? Int32 else {
            return nil
        }
        return NSNumber(value: maxValue)
    }
    
    /// The maximum value for a date answer.
    /// - Returns: An optional `Date` containing the maximum date allowed.
    var maxDateValue: Date? {
        guard let maxValueExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.maxValue),
              case let .date(dateValue) = maxValueExtension.value,
              let maxDateValue = dateValue.value?.asDateAtStartOfDay
        else {
            return nil
        }
        
        return maxDateValue
    }
    
    /// The maximum number of decimal places for a decimal answer.
    /// - Returns: An optional `NSNumber` representing the maximum number of digits to the right of the decimal place.
    var maximumDecimalPlaces: NSNumber? {
        guard let maxDecimalPlacesExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.maxDecimalPlaces),
              case let .integer(integerValue) = maxDecimalPlacesExtension.value,
              let maxDecimalPlaces = integerValue.value?.integer as? Int32 else {
            return nil
        }
        return NSNumber(value: maxDecimalPlaces)
    }

    /// The offset between numbers on a numerical slider
    /// - Returns: An optional `NSNumber` representing the size of each discrete offset on the scale.
    var sliderStepValue: NSNumber? {
        guard let sliderStepValueExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.sliderStepValue),
              case let .integer(integerValue) = sliderStepValueExtension.value,
              let sliderStepValue = integerValue.value?.integer as? Int32 else {
            return nil
        }
        return NSNumber(value: sliderStepValue)
    }
    
    /// The unit of a quantity answer type.
    /// - Returns: An optional `String` containing the unit (i.e. cm) if it was provided.
    var unit: String? {
        guard let unitExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.questionnaireUnit),
              case let .coding(coding) = unitExtension.value else {
            return nil
        }
        return coding.code?.value?.string
    }
    
    /// The regular expression specified for validating a text input in a question.
    /// - Returns: An optional `String` containing the regular expression, if it exists.
    var validationRegularExpression: NSRegularExpression? {
        guard let regexExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.regex),
              case let .string(regex) = regexExtension.value,
              let stringRegularExpression = regex.value?.string else {
            return nil
        }
        return try? NSRegularExpression(pattern: stringRegularExpression)
    }
    
    /// The validation message for a question.
    /// - Returns: An optional `String` containing the validation message, if it exists.
    var validationMessage: String? {
        guard let validationMessageExtension = getExtensionInQuestionnaireItem(url: SupportedExtensions.validationMessage),
              case let .string(message) = validationMessageExtension.value,
              let stringMessage = message.value?.string else {
            return nil
        }
        return stringMessage
    }
    
    
    /// Checks this QuestionnaireItem for an extension matching the given URL and then return it if it exists.
    /// - Parameters:
    ///   - url: A `String` identifying the extension.
    /// - Returns: an optional Extension if it was found.
    private func getExtensionInQuestionnaireItem(url: String) -> Extension? {
        self.`extension`?.first(where: { $0.url.value?.url.absoluteString == url })
    }
}

extension FHIRDate {
    var asDateAtStartOfDay: Date? {
        guard let month, let day else {
            return nil
        }
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = Int(month)
        dateComponents.day = Int(day)

        if let date = Calendar.current.date(from: dateComponents) {
            return Calendar.current.startOfDay(for: date)
        }
        
        return nil
    }
}
