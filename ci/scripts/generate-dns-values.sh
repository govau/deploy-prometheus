#!/bin/bash

set -e

test $DNS_VAR_FILE

PROMETHEUS_EXTERNAL_HOSTNAME=$(dig +short public.prometheus.monitoring.cld.internal ptr)
PROMETHEUS_EXTERNAL_HOSTNAME=${PROMETHEUS_EXTERNAL_HOSTNAME:0:-1} # Drop trailing period
PROMETHEUS_EXTERNAL_IP=$(dig +short ${PROMETHEUS_EXTERNAL_HOSTNAME})

ALERTMANAGER_EXTERNAL_HOSTNAME=$(dig +short public.alertmanager.monitoring.cld.internal ptr)
ALERTMANAGER_EXTERNAL_HOSTNAME=${ALERTMANAGER_EXTERNAL_HOSTNAME:0:-1} # Drop trailing period
ALERTMANAGER_EXTERNAL_IP=$(dig +short ${ALERTMANAGER_EXTERNAL_HOSTNAME})

GRAFANA_EXTERNAL_HOSTNAME=$(dig +short public.grafana.monitoring.cld.internal ptr)
GRAFANA_EXTERNAL_HOSTNAME=${GRAFANA_EXTERNAL_HOSTNAME:0:-1} # Drop trailing period
GRAFANA_EXTERNAL_IP=$(dig +short ${GRAFANA_EXTERNAL_HOSTNAME})


cat > $DNS_VAR_FILE <<END_OF_OPS
---
prometheus_external_ip: $PROMETHEUS_EXTERNAL_IP
prometheus_external_hostname: $PROMETHEUS_EXTERNAL_HOSTNAME

alertmanager_external_ip: $ALERTMANAGER_EXTERNAL_IP
alertmanager_external_hostname: $ALERTMANAGER_EXTERNAL_HOSTNAME

grafana_external_ip: $GRAFANA_EXTERNAL_IP
grafana_external_hostname: $GRAFANA_EXTERNAL_HOSTNAME

END_OF_OPS

cat $DNS_VAR_FILE
