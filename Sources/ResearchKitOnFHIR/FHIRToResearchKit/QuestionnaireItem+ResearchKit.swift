//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
import ResearchKit


extension Questionnaire {
    /// Translates a FHIR `Questionnaire` into a series of ResearchKit `ORKSteps`.
    /// - throws: if there is an issue with one of the items in the questionnaire,
    ///     or if the questionnaire contains items which cannot be represented using the ResearchKit types.
    func toORKSteps() -> [ORKStep] {
        (item ?? []).flatMap { $0.toORKSteps(in: self) }
    }
}


extension QuestionnaireItem {
    fileprivate func toORKSteps(in questionnaire: Questionnaire) -> [ORKStep] { // swiftlint:disable:this cyclomatic_complexity
        guard !self.hidden,
              let questionType = self.type.value else {
            return []
        }
        let title = questionnaire.title?.value?.string ?? ""
        let valueSets = questionnaire.getContainedValueSets()
        
        var steps: [ORKStep] = []
        var alreadyHandledNestedItems = false
        
        switch questionType {
        case .group:
            // Converts multiple questions in a group into a ResearchKit form step
            if let groupStep = self.groupToORKFormStep(title: title, valueSets: valueSets) {
                steps.append(groupStep)
            }
            // -groupToORKFormStep turns any potential nested items into parts of the form;
            // we need to skip them here since otherwise we'd end up including them twice.
            alreadyHandledNestedItems = true
        case .display:
            // Creates a ResearchKit instruction step with the string to display
            if let instructionStep = self.displayToORKInstructionStep(title: title) {
                steps.append(instructionStep)
            }
        case .question, .boolean, .decimal, .integer, .date, .dateTime, .time, .string, .text, .url, .choice, .openChoice, .reference, .quantity:
            // Converts individual questions to ResearchKit Question steps
            if let step = self.toORKQuestionStep(title: title, valueSets: valueSets) {
                if let required = self.required?.value?.bool {
                    step.isOptional = !required
                }
                steps.append(step)
            }
        case .attachment:
            // The FHIR Questionnaire attachment type is meant to support binary file upload, including
            // images. ResearchKit does not support arbitrary binary file upload, but does support image
            // capture, so we map this type to an ORKImageCaptureStep.
            if let attachmentStep = self.attachmentToORKImageCaptureStep() {
                steps.append(attachmentStep)
            }
        }
        
        // Also handle any potential nested questions, if necessary.
        if !alreadyHandledNestedItems, let nestedItems = self.item {
            for item in nestedItems {
                steps.append(contentsOf: item.toORKSteps(in: questionnaire))
            }
        }
        
        return steps
    }
    
    /// Converts a FHIR `QuestionnaireItem` to a ResearchKit `ORKQuestionStep`.
    /// - Parameters:
    ///   - title: A `String` that will be displayed above the question when rendered by ResearchKit.
    ///   - valueSets: An array of `ValueSet` items containing sets of answer choices
    /// - Returns: An `ORKQuestionStep` object (a ResearchKit question step containing the above question).
    fileprivate func toORKQuestionStep(title: String, valueSets: [ValueSet]) -> ORKQuestionStep? {
        guard let identifier = linkId.value?.string else {
            return nil
        }
        
        let answer = try? self.toORKAnswerFormat(valueSets: valueSets)

        let prefix = prefix?.value?.string
        let questionText = prefix ?? text?.value?.string ?? ""

        let step = ORKQuestionStep(identifier: identifier, title: title, question: questionText, answer: answer)

        if prefix != nil {
            step.text = text?.value?.string
        }

        return step
    }
    
    /// Converts a FHIR QuestionnaireItem that contains a group of question items into a ResearchKit form (ORKFormStep).
    /// - Parameters:
    ///   - title: A String that will be displayed at the top of the form when rendered by ResearchKit.
    ///   - valueSets: An array of `ValueSet` items containing sets of answer choices
    /// - Returns: An ORKFormStep object (a ResearchKit form step containing all of the nested questions).
    fileprivate func groupToORKFormStep(title: String, valueSets: [ValueSet]) -> ORKFormStep? {
        guard self.type == .group,
              let id = linkId.value?.string,
              let nestedQuestions = item else {
            return nil
        }
        
        let formStep = ORKFormStep(identifier: id)
        formStep.title = title
        formStep.text = text?.value?.string ?? ""
        var formItems = [ORKFormItem]()

        var containsRequiredSteps = false

        for question in nestedQuestions {
            guard let questionId = question.linkId.value?.string,
                  let questionText = question.text?.value?.string else {
                continue
            }

            if question.type == .display {
                let formItem = ORKFormItem(sectionTitle: questionText, detailText: question.placeholderText, learnMoreItem: nil, showsProgress: false)
                formItems.append(formItem)
            } else if let answerFormat = try? question.toORKAnswerFormat(valueSets: valueSets) {
                let formItem = ORKFormItem(identifier: questionId, text: questionText, answerFormat: answerFormat)
                if let required = question.required?.value?.bool {
                    // if !optional, the `Continue` will stay disabled till the question is answered.
                    formItem.isOptional = !required
                    if required {
                        containsRequiredSteps = true
                    }
                }
                formItem.placeholder = question.placeholderText

                formItems.append(formItem)
            }
        }

        formStep.formItems = formItems
        // if optional, the `Next` button will appear
        formStep.isOptional = !(containsRequiredSteps || required?.value?.bool == true)
        return formStep
    }
    
    /// Converts FHIR `QuestionnaireItem` display type to `ORKInstructionStep`
    /// - Parameters:
    ///   - title: A `String` to display at the top of the view rendered by ResearchKit.
    /// - Returns: A ResearchKit `ORKInstructionStep`.
    fileprivate func displayToORKInstructionStep(title: String) -> ORKInstructionStep? {
        guard self.type == .display,
              let id = linkId.value?.string,
              let text = text?.value?.string else {
            return nil
        }
        
        let instructionStep = ORKInstructionStep(identifier: id)
        instructionStep.title = title
        instructionStep.detailText = text
        return instructionStep
    }

    /// Converts FHIR `QuestionnaireItem` attachment type to `ORKImageCaptureStep`
    /// - Returns: A ResearchKit `ORKImageCaptureStep`
    fileprivate func attachmentToORKImageCaptureStep() -> ORKImageCaptureStep? {
        guard let id = linkId.value?.string else {
            return nil
        }
        return ORKImageCaptureStep(identifier: id)
    }
    
    /// Converts FHIR QuestionnaireItem answer types to the corresponding ResearchKit answer types (ORKAnswerFormat).
    /// - Parameter valueSets: An array of `ValueSet` items containing sets of answer choices
    /// - Returns: An object of type `ORKAnswerFormat` representing the type of answer this question accepts.
    private func toORKAnswerFormat(valueSets: [ValueSet]) throws -> ORKAnswerFormat {
        // swiftlint:disable:previous cyclomatic_complexity function_body_length
        // We have to cover all the switch cases in the following statement driving up the overall complexity.
        switch type.value {
        case .boolean:
            return ORKBooleanAnswerFormat.booleanAnswerFormat()
        case .choice, .openChoice:
            let answerOptions = toORKTextChoice(valueSets: valueSets, openChoice: type.value == .openChoice)
            guard !answerOptions.isEmpty else {
                throw FHIRToResearchKitConversionError.noOptions
            }
            var choiceAnswerStyle = ORKChoiceAnswerStyle.singleChoice
            if itemControl == "check-box" {
                choiceAnswerStyle = .multipleChoice
            }
            return ORKTextChoiceAnswerFormat(style: choiceAnswerStyle, textChoices: answerOptions)
        case .date:
            return ORKDateAnswerFormat(
                style: .date,
                defaultDate: nil,
                minimumDate: minDateValue,
                maximumDate: maxDateValue,
                calendar: nil
            )
        case .dateTime:
            return ORKDateAnswerFormat(
                style: .dateAndTime,
                defaultDate: nil,
                minimumDate: minDateValue,
                maximumDate: maxDateValue,
                calendar: nil
            )
        case .time:
            return ORKTimeOfDayAnswerFormat()
        case .decimal, .quantity:
            let answerFormat = ORKNumericAnswerFormat.decimalAnswerFormat(withUnit: unit)
            answerFormat.maximumFractionDigits = maximumDecimalPlaces
            answerFormat.minimum = minValue
            answerFormat.maximum = maxValue
            return answerFormat
        case .integer:
            if itemControl == "slider" {
                let answerFormat = ORKScaleAnswerFormat(
                    maximumValue: maxValue?.intValue ?? 0,
                    minimumValue: minValue?.intValue ?? 0,
                    defaultValue: minValue?.intValue ?? 0,
                    step: Int(truncating: sliderStepValue ?? 1)
                )
                return answerFormat
            }

            let answerFormat = ORKNumericAnswerFormat.integerAnswerFormat(withUnit: nil)
            answerFormat.minimum = minValue
            answerFormat.maximum = maxValue
            return answerFormat
        case .text, .string:
            let maximumLength = Int(maxLength?.value?.integer ?? 0)
            let answerFormat = ORKTextAnswerFormat(maximumLength: maximumLength)

            answerFormat.multipleLines = type.value == .text
#if os(iOS) || os(visionOS)
            if let keyboardType {
                answerFormat.keyboardType = keyboardType
            }
#endif
#if os(iOS) || os(visionOS) || os(tvOS)
            if let textContentType {
                answerFormat.textContentType = textContentType
            }
            if let autocapitalizationType {
                answerFormat.autocapitalizationType = autocapitalizationType
            }
#endif
            answerFormat.placeholder = self.placeholderText

            // Applies a regular expression for validation, if defined
            if let validationRegularExpression = validationRegularExpression {
                answerFormat.validationRegularExpression = validationRegularExpression
                answerFormat.invalidMessage = validationMessage ?? "Invalid input"
            }
            
            return answerFormat
        default:
            return ORKTextAnswerFormat()
        }
    }
    
    /// Converts FHIR text answer choices to ResearchKit `ORKTextChoice`.
    /// - Parameter - valueSets: An array of `ValueSet` items containing sets of answer choices
    /// - Returns: An array of `ORKTextChoice` objects, each representing a textual answer option.
    private func toORKTextChoice(valueSets: [ValueSet], openChoice: Bool) -> [ORKTextChoice] {
        var choices: [ORKTextChoice] = []
        
        // If the `QuestionnaireItem` has an `answerValueSet` defined which is a reference to a contained `ValueSet`,
        // search the available `ValueSets`and, if a match is found, convert the options to `ORKTextChoice`
        if let answerValueSetURL = answerValueSet?.value?.url.absoluteString,
           answerValueSetURL.starts(with: "#") {
            let valueSet = valueSets.first { valueSet in
                if let valueSetID = valueSet.id?.value?.string {
                    return "#\(valueSetID)" == answerValueSetURL
                }
                return false
            }
            
            guard let answerOptions = valueSet?.compose?.include.first?.concept else {
                return choices
            }
            
            for option in answerOptions {
                guard let display = option.display?.value?.string,
                      let code = option.code.value?.string,
                      let system = valueSet?.compose?.include.first?.system?.value?.url.absoluteString else {
                    continue
                }
                let valueCoding = ValueCoding(code: code, system: system, display: display)
                let choice = ORKTextChoice(text: display, value: valueCoding.rawValue as NSSecureCoding & NSCopying & NSObjectProtocol)
                choices.append(choice)
            }
        } else {
            // If the `QuestionnaireItem` has `answerOptions` defined instead, extract these options
            // and convert them to `ORKTextChoice`
            guard let answerOptions = answerOption else {
                return choices
            }
            
            for option in answerOptions {
                guard case let .coding(coding) = option.value,
                      let display = coding.display?.value?.string,
                      let code = coding.code?.value?.string,
                      let system = coding.system?.value?.url.absoluteString else {
                    continue
                }
                let valueCoding = ValueCoding(code: code, system: system, display: display)
                let choice = ORKTextChoice(text: display, value: valueCoding.rawValue as NSSecureCoding & NSCopying & NSObjectProtocol)
                choices.append(choice)
            }
            
            if openChoice {
                // If the `QuestionnaireItemType` is `open-choice`, allow user to enter in their own free-text answer.
                let otherChoiceText = NSLocalizedString("Other", comment: "")
                let otherChoice = ORKTextChoiceOther.choice(
                    withText: otherChoiceText,
                    detailText: nil,
                    value: otherChoiceText as NSSecureCoding & NSCopying & NSObjectProtocol,
                    exclusive: true,
                    textViewPlaceholderText: ""
                )
                
                choices.append(otherChoice)
            }
        }
        return choices
    }
}
