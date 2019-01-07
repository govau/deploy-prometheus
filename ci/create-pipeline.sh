#!/bin/bash

set -euxo pipefail

if [[ ${TARGET} == "" ]]; then
  TARGET=local
fi

fly validate-pipeline --config pipeline.yml
./gen-credentials.sh

fly -t ${TARGET} set-pipeline --config pipeline.yml --pipeline prometheus
fly -t ${TARGET} unpause-pipeline -p prometheus
