#!/usr/bin/env bash

# Fetches certs and puts them into credhub

set -euo pipefail

credhub set -n /concourse/apps/prometheus/bosh_ca_cert -t certificate -c <(ssh bosh-jumpbox.m.cld.gov.au bosh int bosh-bootstrap/state/creds.yml --path /default_ca/ca)
credhub set -n /concourse/apps/prometheus/b_cld_bosh_ca_cert -t certificate -c <(ssh bosh-jumpbox.b.cld.gov.au bosh int bosh-bootstrap/state/creds.yml --path /default_ca/ca)
credhub set -n /concourse/apps/prometheus/y_cld_bosh_ca_cert -t certificate -c <(ssh bosh-jumpbox.y.cld.gov.au bosh int bosh-bootstrap/state/creds.yml --path /default_ca/ca)
credhub set -n /concourse/apps/prometheus/d_cld_bosh_ca_cert -t certificate -c <(ssh bosh-jumpbox.d.cld.gov.au bosh int bosh-bootstrap/state/creds.yml --path /default_ca/ca)
