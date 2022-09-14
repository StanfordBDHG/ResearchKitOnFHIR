<!--
                  
This source file is part of the ResearchKitOnFHIR open source project

SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

![CardinalKit Logo](https://raw.githubusercontent.com/CardinalKit/.github/main/assets/ck-header-light.png#gh-light-mode-only)
![CardinalKit Logo](https://raw.githubusercontent.com/CardinalKit/.github/main/assets/ck-header-dark.png#gh-dark-mode-only)

# ResearchKitOnFHIR

[![Build](https://github.com/CardinalKit/ResearchKitOnFHIR/actions/workflows/build.yml/badge.svg)](https://github.com/CardinalKit/ResearchKitOnFHIR/actions/workflows/build.yml)
[![codecov](https://codecov.io/gh/CardinalKit/ResearchKitOnFHIR/branch/main/graph/badge.svg?token=A9IUX2PFCL)](https://codecov.io/gh/CardinalKit/ResearchKitOnFHIR)

ResearchKitOnFHIR is a framework that allows you to use [FHIR Questionnaires](https://www.hl7.org/fhir/questionnaire.html) with ResearchKit to create healthcare surveys on iOS based on the [HL7 Structured Data Capture Implementation Guide](http://build.fhir.org/ig/HL7/sdc/)

## Features
- Converts [FHIR Questionnaires](https://www.hl7.org/fhir/questionnaire.html) into ResearchKit tasks
- Serializes results into [FHIR QuestionnaireResponses](https://www.hl7.org/FHIR/questionnaireresponse.html)
- Supports survey skip-logic by converting FHIR `enableWhen` conditions into ResearchKit navigation rules
- Supports answer validation during entry
- Supports contained [FHIR ValueSets](https://www.hl7.org/fhir/valueset.html) as answer options

## Installation
ResearchKitOnFHIR can be installed into your Xcode project using [Swift Package Manager](https://github.com/apple/swift-package-manager).

1. In Xcode 14 and newer (requires Swift 5.7), go to “File” » “Add Packages...”
2. Enter the URL to this GitHub repository, then select the `ResearchKitOnFhir` package to install.

## Usage
The `Example` directory contains an Xcode project that demonstrates how to create a ResearchKit task from a FHIR Questionnaire, and extract the results in the form of a FHIR QuestionnaireResponse.

## License
This project is licensed under the MIT License. See [Licenses](https://github.com/CardinalKit/ResearchKitOnFHIR/tree/main/LICENSES) for more information.

## Contributors
This project is developed as part of the CardinalKit project at Stanford.
See [CONTRIBUTORS.md](https://github.com/CardinalKit/ResearchKitOnFHIR/tree/main/CONTRIBUTORS.md) for a full list of all ResearchKitOnFHIR contributors.

## Notices
ResearchKit is a registered trademark of Apple, Inc.
FHIR is a registered trademark of Health Level Seven International.

![Stanford Byers Center for Biodesign Logo](https://raw.githubusercontent.com/CardinalKit/.github/main/assets/ck-footer-light.png#gh-light-mode-only)
![Stanford Byers Center for Biodesign Logo](https://raw.githubusercontent.com/CardinalKit/.github/main/assets/ck-footer-dark.png#gh-dark-mode-only)
