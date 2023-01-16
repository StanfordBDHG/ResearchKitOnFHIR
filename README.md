<!--
                  
This source file is part of the ResearchKitOnFHIR open source project

SPDX-FileCopyrightText: 2022 Stanford Biodesign for Digital Health and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

# ResearchKitOnFHIR

[![Build and Test](https://github.com/StanfordBDHG/ResearchKitOnFHIR/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/StanfordBDHG/ResearchKitOnFHIR/actions/workflows/build-and-test.yml)
[![codecov](https://codecov.io/gh/StanfordBDHG/ResearchKitOnFHIR/branch/main/graph/badge.svg?token=A9IUX2PFCL)](https://codecov.io/gh/StanfordBDHG/ResearchKitOnFHIR)
[![DOI](https://zenodo.org/badge/530673273.svg)](https://zenodo.org/badge/latestdoi/530673273)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FStanfordBDHG%2FResearchKitOnFHIR%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/StanfordBDHG/ResearchKitOnFHIR)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FStanfordBDHG%2FResearchKitOnFHIR%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/StanfordBDHG/ResearchKitOnFHIR)

ResearchKitOnFHIR is a framework that allows you to use [FHIR Questionnaires](https://www.hl7.org/fhir/questionnaire.html) with ResearchKit to create healthcare surveys on iOS based on the [HL7 Structured Data Capture Implementation Guide](http://build.fhir.org/ig/HL7/sdc/)

For more information, please refer to the [API documentation](https://swiftpackageindex.com/StanfordBDHG/ResearchKitOnFHIR/documentation).


## Features

- Converts [FHIR Questionnaires](https://www.hl7.org/fhir/questionnaire.html) into ResearchKit tasks
- Serializes results into [FHIR QuestionnaireResponses](https://www.hl7.org/FHIR/questionnaireresponse.html)
- Supports survey skip-logic by converting FHIR `enableWhen` conditions into ResearchKit navigation rules
- Supports answer validation during entry
- Supports contained [FHIR ValueSets](https://www.hl7.org/fhir/valueset.html) as answer options


### FHIR <-> ResearchKit Conversion

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

Multiple enableWhen expressions are supported, using the [enableBehavior](https://www.hl7.org/fhir/questionnaire-definitions.html#Questionnaire.item.enableBehavior) element to determine if any or all of the expressions should be applied. If enableBehavior is not defined, all expressions will be applied.

| FHIR R4 [QuestionnaireItemType](https://www.hl7.org/fhir/valueset-item-type.html) | Supported [QuestionnaireItemOperators](https://www.hl7.org/fhir/valueset-questionnaire-enable-operator.html) | ResearchKit [ORKResultPredicate](http://researchkit.org/docs/Classes/ORKResultPredicate.html) |
| ---------------------------- | ------------------- | ------------------------------ |
| boolean | =, != | .predicateForBooleanQuestionResult
| integer | =, !=, <=, >= | .predicateForNumericQuestionResult
| decimal | =, !=, <=, >= | .predicateForNumericQuestionResult
| date | >, < | .predicateForDateQuestionResult
| coding | =, != | .predicateForChoiceQuestionResult


## Installation

ResearchKitOnFHIR can be installed into your Xcode project using [Swift Package Manager](https://github.com/apple/swift-package-manager).

1. In Xcode 14 and newer (requires Swift 5.7), go to “File” » “Add Packages...”
2. Enter the URL to this GitHub repository, then select the `ResearchKitOnFhir` package to install.


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


## License

This project is licensed under the MIT License. See [Licenses](https://github.com/StanfordBDHG/ResearchKitOnFHIR/tree/main/LICENSES) for more information.


## Contributors

This project is developed as part of the Stanford Biodesign for Digital Health projects at Stanford.
See [CONTRIBUTORS.md](https://github.com/StanfordBDHG/ResearchKitOnFHIR/tree/main/CONTRIBUTORS.md) for a full list of all ResearchKitOnFHIR contributors.


## Notices

ResearchKit is a registered trademark of Apple, Inc.
FHIR is a registered trademark of Health Level Seven International.

![Stanford Byers Center for Biodesign Logo](https://raw.githubusercontent.com/StanfordBDHG/.github/main/assets/biodesign-footer-light.png#gh-light-mode-only)
![Stanford Byers Center for Biodesign Logo](https://raw.githubusercontent.com/StanfordBDHG/.github/main/assets/biodesign-footer-dark.png#gh-dark-mode-only)
