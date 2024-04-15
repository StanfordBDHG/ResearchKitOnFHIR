### FHIRPath Grammar
TODO: make this DOCC?

_All files in this directory won't be part of the Swift target._

This directory contains the FHIRPath grammar from
[HL7/FHIRPath](https://github.com/HL7/FHIRPath/blob/767f55a6f572419679cc37dfe9477e5465f86014/spec/2019May/fhirpath.g4).

We use [ANTLR4](https://github.com/antlr/antlr4) to generate a lexer and parser in Swift from the grammar.
The generated files will be placed in the `Generated` directory.

To regenerate the source code files simply run the following command from the root of the project:
```shell
./Sources/FHIRPathParser/ANTLUtils/generate.sh
```