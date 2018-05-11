#!/bin/bash

set -e

test $TLS_CERTS_VAR_FILE

PROMETHEUS_EXTERNAL_HOSTNAME=$(dig +short public.prometheus.monitoring.cld.internal ptr)
PROMETHEUS_EXTERNAL_HOSTNAME=${PROMETHEUS_EXTERNAL_HOSTNAME:0:-1} # Drop trailing period
PROMETHEUS_CERT="$(cat ./cert-prometheus.s3/${PROMETHEUS_EXTERNAL_HOSTNAME}.crt)"

ALERTMANAGER_EXTERNAL_HOSTNAME=$(dig +short public.alertmanager.monitoring.cld.internal ptr)
ALERTMANAGER_EXTERNAL_HOSTNAME=${ALERTMANAGER_EXTERNAL_HOSTNAME:0:-1} # Drop trailing period
ALERTMANAGER_CERT="$(cat ./cert-alertmanager.s3/${ALERTMANAGER_EXTERNAL_HOSTNAME}.crt)"

GRAFANA_EXTERNAL_HOSTNAME=$(dig +short public.grafana.monitoring.cld.internal ptr)
GRAFANA_EXTERNAL_HOSTNAME=${GRAFANA_EXTERNAL_HOSTNAME:0:-1} # Drop trailing period
GRAFANA_CERT="$(cat ./cert-grafana.s3/${GRAFANA_EXTERNAL_HOSTNAME}.crt)"

prometheus_tls_cert
cat > $TLS_CERTS_VAR_FILE <<END_OF_OPS
---
alertmanager_tls_cert: '${ALERTMANAGER_CERT}'
grafana_tls_cert: '${GRAFANA_CERT}'
prometheus_tls_cert: '${PROMETHEUS_CERT}'
END_OF_OPS
