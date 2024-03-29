#!/usr/bin/env bash

# Fetches certs and puts them into credhub

set -euo pipefail

credhub set -n /concourse/main/prometheus/bosh_target -t value -v director.bosh.cld.internal
credhub set -n /concourse/main/prometheus/bosh_client -t value -v admin
credhub set -n /concourse/main/prometheus/bosh_client_secret -t value -v <(ssh bosh-jumpbox.m.cld.gov.au bosh int bosh-bootstrap/state/creds.yml --path /admin_password)
credhub set -n /concourse/main/prometheus/b_cld_bosh_ca_cert -t certificate -c <(ssh bosh-jumpbox.b.cld.gov.au bosh int bosh-bootstrap/state/creds.yml --path /default_ca/ca)
credhub set -n /concourse/main/prometheus/y_cld_bosh_ca_cert -t certificate -c <(ssh bosh-jumpbox.y.cld.gov.au bosh int bosh-bootstrap/state/creds.yml --path /default_ca/ca)
credhub set -n /concourse/main/prometheus/d_cld_bosh_ca_cert -t certificate -c <(ssh bosh-jumpbox.d.cld.gov.au bosh int bosh-bootstrap/state/creds.yml --path /default_ca/ca)
