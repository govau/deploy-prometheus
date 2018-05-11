#!/bin/bash

set -e

test $TLS_CERTS_VAR_FILE

PROMETHEUS_EXTERNAL_HOSTNAME=$(dig +short public.prometheus.monitoring.cld.internal ptr)
PROMETHEUS_EXTERNAL_HOSTNAME=${PROMETHEUS_EXTERNAL_HOSTNAME:0:-1} # Drop trailing period

ALERTMANAGER_EXTERNAL_HOSTNAME=$(dig +short public.alertmanager.monitoring.cld.internal ptr)
ALERTMANAGER_EXTERNAL_HOSTNAME=${ALERTMANAGER_EXTERNAL_HOSTNAME:0:-1} # Drop trailing period

GRAFANA_EXTERNAL_HOSTNAME=$(dig +short public.grafana.monitoring.cld.internal ptr)
GRAFANA_EXTERNAL_HOSTNAME=${GRAFANA_EXTERNAL_HOSTNAME:0:-1} # Drop trailing period

printf -- '---' > $TLS_CERTS_VAR_FILE

printf -- '\nalertmanager_tls_cert: |\n' >> $TLS_CERTS_VAR_FILE
cat ./cert-alertmanager.s3/${ALERTMANAGER_EXTERNAL_HOSTNAME}.crt | sed 's/^/  /' >> $TLS_CERTS_VAR_FILE

printf -- '\ngrafana_tls_cert: |\n' >> $TLS_CERTS_VAR_FILE
cat ./cert-grafana.s3/${GRAFANA_EXTERNAL_HOSTNAME}.crt | sed 's/^/  /' >> $TLS_CERTS_VAR_FILE

printf -- '\nprometheus_tls_cert: |\n' >> $TLS_CERTS_VAR_FILE
cat ./cert-prometheus.s3/${PROMETHEUS_EXTERNAL_HOSTNAME}.crt | sed 's/^/  /' >> $TLS_CERTS_VAR_FILE
