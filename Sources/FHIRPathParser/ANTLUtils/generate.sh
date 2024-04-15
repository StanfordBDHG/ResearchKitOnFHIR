#!/bin/sh

# Make sure we are in the directory the script is located in.
cd "$(dirname "$0")" || {
  echo: "Error: failed to navigate to $(dirname "$0")"
  exit 1
}

if ! command -v antlr4 > /dev/null
then
    echo "Error: antlr4 is not installed. Please install antlr4."
    exit 1
fi

# Generate with visitor and no listeners
antlr4 -Dlanguage=Swift -visitor -no-listener -message-format gnu -o Output FHIRPath.g4


mv Output/*.swift ../Generated
rm -rf Output

echo "Swift files generated successfully."
