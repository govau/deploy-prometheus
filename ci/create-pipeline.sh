#!/bin/bash

set -euxo pipefail

if [[ ${TARGET} == "" ]]; then
  TARGET=local
fi

fly validate-pipeline --config pipeline.yml

GEN_CREDENTIALS="$(./gen-credentials.sh)"

fly -t ${TARGET} set-pipeline --config pipeline.yml --pipeline prometheus \
  -l credentials.yml \
  -l <(echo "$GEN_CREDENTIALS")

fly -t ${TARGET} unpause-pipeline -p prometheus
