#!/bin/bash

set -e
set -x

CREDENTIALS=credentials.yml

if [[ ${TARGET} == "" ]]; then
  TARGET=local
  # Use target-specific credentials file if available
  if [[ -f credentials-local.yml ]]; then
    CREDENTIALS=credentials-local.yml
  fi
fi

fly validate-pipeline --config pipeline.yml

fly --target ${TARGET} set-pipeline --config pipeline.yml --pipeline prometheus -n \
  -l $CREDENTIALS \
  -l credentials-root-cld.yml \
  -l credentials-b-cld.yml \
  -l credentials-d-cld.yml \
  -l credentials-g-cld.yml \
  -l credentials-y-cld.yml

fly -t ${TARGET} check-resource --resource prometheus/deploy-prometheus.git

fly -t ${TARGET} unpause-pipeline -p prometheus
