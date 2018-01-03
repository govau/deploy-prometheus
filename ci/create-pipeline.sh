#!/bin/bash

set -e
set -x

CREDENTIALS=credentials.yml

if [[ ${TARGET} == "" ]]; then
  TARGET=local
  CREDENTIALS=credentials-local.yml
fi

fly validate-pipeline --config pipeline.yml

fly --target ${TARGET} set-pipeline --config pipeline.yml --pipeline prometheus -n -l $CREDENTIALS

fly -t ${TARGET} check-resource --resource prometheus/deploy-prometheus.git

fly -t ${TARGET} unpause-pipeline -p prometheus
