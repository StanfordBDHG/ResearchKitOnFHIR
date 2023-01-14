# ``FHIRQuestionnaires``

FHIRQuestionnaires is a framework that includes several pre-packaged FHIR questionnaires.

<!--
                  
This source file is part of the ResearchKitOnFHIR open source project

SPDX-FileCopyrightText: 2022 Stanford Biodesign for Digital Health and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

## Clinical Research Questionnaires

A collection of clinical research `Questionnaire`s provided by the FHIRQuestionnaires target
```swift
Questionnaire.researchQuestionnaires
```

**PHQ-9**

The PHQ-9 validated clinical questionnaire:
```swift
Questionnaire.phq9
```

**Generalized Anxiety Disorder-7**

Generalized Anxiety Disorder-7:
```swift
Questionnaire.gad7
```

**International Prostatism Symptom Score (IPSS)**

International Prostatism Symptom Score (IPSS):
```swift
Questionnaire.ipss
```

**Glasgow Coma Scale**

The Glasgow Coma Scale
```swift
Questionnaire.gcs
```


## Example FHIR Questionnaires

A collection of example `Questionnaire`s provided by the FHIRQuestionnaires target to demonstrate functionality:
```swift
Questionnaire.exampleQuestionnaires
```

**Skip Logic Example**

A FHIR questionnaire demonstrating enableWhen conditions that are converted to ResearchKit skip logic:
```swift
Questionnaire.skipLogicExample
```

**Skip Logic Example**

A FHIR questionnaire demonstrating enableWhen conditions that are converted to ResearchKit skip logic:
```swift
Questionnaire.skipLogicExample
```

**Multiple Enable When**

A FHIR questionnaire demonstrating multiple enableWhen conditions in an AND / OR configuration:
```swift
Questionnaire.multipleEnableWhen
```

**Text Validation Example**

A FHIR questionnaire demonstrating the use of a regular expression to validate an email address:
```swift
Questionnaire.textValidationExample
```

**Contained Value Set Example**

A FHIR questionnaire demonstrating the use of a contained ValueSet:
```swift
Questionnaire.containedValueSetExample
```
