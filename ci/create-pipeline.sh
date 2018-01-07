#!/bin/bash

set -e
set -x

CREDENTIALS=credentials.yml

if [[ ${TARGET} == "" ]]; then
  TARGET=local
fi

# Use target-specific credentials file if available
if [[ -f credentials-${TARGET}.yml ]]; then
  CREDENTIALS=credentials-${TARGET}.yml
fi

fly validate-pipeline --config pipeline.yml

fly --target ${TARGET} set-pipeline --config pipeline.yml --pipeline prometheus -n -l $CREDENTIALS

fly -t ${TARGET} unpause-pipeline -p prometheus
