# ``ResearchKitOnFHIR``

ResearchKitOnFHIR is a framework that allows you to use FHIR questionnaires with ResearchKit.

<!--
                  
This source file is part of the ResearchKitOnFHIR open source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

## Features

ResearchKitOnFHIR is a framework that allows you to use [FHIR Questionnaires](https://www.hl7.org/fhir/questionnaire.html) with ResearchKit to create healthcare surveys on iOS based on the [HL7 Structured Data Capture Implementation Guide](http://build.fhir.org/ig/HL7/sdc/)

It allows you to:
- Converts [FHIR Questionnaires](https://www.hl7.org/fhir/questionnaire.html) into ResearchKit tasks
- Serializes results into [FHIR QuestionnaireResponses](https://www.hl7.org/FHIR/questionnaireresponse.html)
- Supports survey skip-logic by converting FHIR `enableWhen` conditions into ResearchKit navigation rules
- Supports answer validation during entry
- Supports contained [FHIR ValueSets](https://www.hl7.org/fhir/valueset.html) as answer options

### FHIR<-> ResearchKit Conversion

| FHIR R4 [QuestionnaireItemType](https://www.hl7.org/fhir/valueset-item-type.html) | ResearchKit Type | FHIR Response Type
|------------------------------|-----------------------------|--------------------------|
| [display](https://www.hl7.org/fhir/codesystem-item-type.html#item-type-display) | [ORKInstructionStep](http://researchkit.org/docs/Classes/ORKInstructionStep.html) | *none*
| [group](https://www.hl7.org/fhir/codesystem-item-type.html#item-type-group) | [ORKFormStep](http://researchkit.org/docs/Classes/ORKFormStep.html) | *none*
| [boolean](https://www.hl7.org/fhir/codesystem-item-type.html#item-type-boolean) | [ORKBooleanAnswerFormat](http://researchkit.org/docs/Classes/ORKBooleanAnswerFormat.html) | valueBoolean
| [choice](https://www.hl7.org/fhir/codesystem-item-type.html#item-type-choice) | [ORKTextChoice](http://researchkit.org/docs/Classes/ORKTextChoice.html) | valueCoding  
| [date](https://www.hl7.org/fhir/codesystem-item-type.html#item-type-date) | [ORKDateAnswerFormat](http://researchkit.org/docs/Classes/ORKDateAnswerFormat.html)(style: [ORKDateAnswerStyle.date](http://researchkit.org/docs/Constants/ORKDateAnswerStyle.html) | valueDate 
| [dateTime](https://www.hl7.org/fhir/codesystem-item-type.html#item-type-dateTime) | [ORKDateAnswerFormat](http://researchkit.org/docs/Classes/ORKDateAnswerFormat.html)(style: [ORKDateAnswerStyle.dateAndTime](http://researchkit.org/docs/Constants/ORKDateAnswerStyle.html) | valueDateTime 
| [time](https://www.hl7.org/fhir/codesystem-item-type.html#item-type-time) | [ORKTimeOfDayAnswerFormat](http://researchkit.org/docs/Classes/ORKTimeOfDayAnswerFormat.html) | valueTime 
| [decimal](https://www.hl7.org/fhir/codesystem-item-type.html#item-type-decimal) | [ORKNumericAnswerFormat](http://researchkit.org/docs/Classes/ORKNumericAnswerFormat.html).decimalAnswerFormat | valueDecimal 
| [quantity](https://www.hl7.org/fhir/codesystem-item-type.html#item-type-quantity) | [ORKNumericAnswerFormat](http://researchkit.org/docs/Classes/ORKNumericAnswerFormat.html).decimalAnswerFormat(withUnit: quantityUnit) | valueQuantity 
| [integer](https://www.hl7.org/fhir/codesystem-item-type.html#item-type-integer) | [ORKNumericAnswerFormat](http://researchkit.org/docs/Classes/ORKNumericAnswerFormat.html).integerAnswerFormat | valueInteger 
| [text](https://www.hl7.org/fhir/codesystem-item-type.html#item-type-text) | [ORKTextAnswerFormat](http://researchkit.org/docs/Classes/ORKTextAnswerFormat.html) | valueString 
| [string](https://www.hl7.org/fhir/codesystem-item-type.html#item-type-string) | [ORKTextAnswerFormat](http://researchkit.org/docs/Classes/ORKTextAnswerFormat.html) | valueString 

### Navigation Rules

The following table describes how the FHIR [enableWhen](https://www.hl7.org/fhir/questionnaire-definitions.html#Questionnaire.item.enableWhen) is converted to a ResearchKit [ORKSkipStepNavigationRule](http://researchkit.org/docs/Classes/ORKSkipStepNavigationRule.html) for each supported type and operator. (The conversion is performed by constructing an ORKResultPredicate from the enableWhen expression and negating it.)

| FHIR R4 [QuestionnaireItemType](https://www.hl7.org/fhir/valueset-item-type.html) | Supported [QuestionnaireItemOperators](https://www.hl7.org/fhir/valueset-questionnaire-enable-operator.html) | ResearchKit [ORKResultPredicate](http://researchkit.org/docs/Classes/ORKResultPredicate.html) |
| ---------------------------- | ------------------- | ------------------------------ |
| boolean | =, != | .predicateForBooleanQuestionResult
| integer | =, !=, <=, >= | .predicateForNumericQuestionResult
| decimal | =, !=, <=, >= | .predicateForNumericQuestionResult
| date | >, < | .predicateForDateQuestionResult
| coding | =, != | .predicateForChoiceQuestionResult


## Usage
The `Example` directory contains an Xcode project that demonstrates how to create a ResearchKit task from a FHIR Questionnaire, and extract the results in the form of a FHIR QuestionnaireResponse.

### Converting from FHIR to ResearchKit

#### 1. Instantiate a FHIR Questionnaire from JSON

```swift
let data = <FHIR JSON data>
var questionnaire: Questionnaire?
do {
    questionnaire = try JSONDecoder().decode(Questionnaire.self, from: data)
} catch {
    print("Could not decode the FHIR questionnaire": \(error)")
}
```

#### 2. Create a ResearchKit Navigable Task from the FHIR Questionnaire

```swift
var task: ORKNavigableOrderedTask?
do {
    task = try ORKNavigableOrderedTask(questionnaire: questionnaire)
} catch {
    print("Error creating task: \(error)")
}
```

Now you can present the task as described in the [ResearchKit documentation](https://github.com/StanfordBDHG/researchkit#4-present-the-task).

### Converting ResearchKit Task Results to FHIR QuestionnaireResponse

In your class that implements the `ORKTaskViewControllerDelegateProtocol`, you can extract a FHIR [QuestionnaireResponse](https://www.hl7.org/FHIR/questionnaireresponse.html) from the task's results as shown below.

```swift
func taskViewController(
    _ taskViewController: ORKTaskViewController, 
    didFinishWith reason: ORKTaskViewControllerFinishReason, 
    error: Error?
) {
    switch reason {
    case .completed:
        let fhirResponse = taskViewController.result.fhirResponse
        // ...
    }
}
```
