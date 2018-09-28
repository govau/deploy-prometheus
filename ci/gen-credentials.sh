#!/usr/bin/env bash

# Fetches some credentials from each environment needed by `fly set-pipeline`
# and dumps them to stdout

set -euo pipefail

# Fetch the bosh ca cert from each jumpbox.
# We use sed to indent each line so it is written to stdout as valid yml.
B_CLD_BOSH_CA_CERT="$(ssh bosh-jumpbox.b.cld.gov.au bosh int bosh-bootstrap/state/creds.yml --path /default_ca/ca | sed 's/^/  /')"
D_CLD_BOSH_CA_CERT="$(ssh bosh-jumpbox.d.cld.gov.au bosh int bosh-bootstrap/state/creds.yml --path /default_ca/ca | sed 's/^/  /')"
M_CLD_BOSH_CA_CERT="$(ssh bosh-jumpbox.m.cld.gov.au bosh int bosh-bootstrap/state/creds.yml --path /default_ca/ca | sed 's/^/  /')"
Y_CLD_BOSH_CA_CERT="$(ssh bosh-jumpbox.y.cld.gov.au bosh int bosh-bootstrap/state/creds.yml --path /default_ca/ca | sed 's/^/  /')"

cat <<EOF
bosh_ca_cert: |
${M_CLD_BOSH_CA_CERT}

b_cld_bosh_ca_cert: |
${B_CLD_BOSH_CA_CERT}

d_cld_bosh_ca_cert: |
${D_CLD_BOSH_CA_CERT}

y_cld_bosh_ca_cert: |
${Y_CLD_BOSH_CA_CERT}

EOF
