#!/bin/bash

set -e
set -x

TARGET=${TARGET:-local}

fly validate-pipeline --config pipeline.yml

fly --target ${TARGET} set-pipeline --config pipeline.yml --pipeline prometheus -n -l credentials.yml

fly -t ${TARGET} unpause-pipeline -p prometheus