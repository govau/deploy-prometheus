#!/bin/bash

set -e -x

# Validate our inputs
if [ -z "$INPUT_FILE" ]; then
  echo "must specify \$INPUT_FILE" >&2
  exit 1
fi
if [ -z "$OUTPUT_DIR" ]; then
  echo "must specify \$OUTPUT_DIR" >&2
  exit 1
fi

# Extract the input file into the output dir
# We strip the container dir from the source.tar.gz from github
tar xvfz "${INPUT_FILE}" --directory "${OUTPUT_DIR}" --strip 1
