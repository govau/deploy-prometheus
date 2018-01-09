#!/bin/bash

set -e
set -v

: "${JUMPBOX:?Need to set JUMPBOX e.g. bosh-jumpbox.d.foo}"
: "${JUMPBOX_SSH_KEY:?Need to set JUMPBOX_SSH_KEY}"

PATH_TO_KEY=${PWD}/jumpbox.pem

# Create the private key for the jumpbox
echo "${JUMPBOX_SSH_KEY}">${PATH_TO_KEY}
chmod 600 ${PATH_TO_KEY}

SSH="ssh -i ${PATH_TO_KEY} ec2-user@${JUMPBOX}"

# preload the jumpbox host key
mkdir ~/.ssh
KNOWN_HOSTS=~/.ssh/known_hosts
ssh-keyscan -H ${JUMPBOX} > ${KNOWN_HOSTS}

test $DNS_VAR_FILE

PROMETHEUS_EXTERNAL_HOSTNAME=$($SSH dig +short public.prometheus.monitoring.cld.internal ptr)
PROMETHEUS_EXTERNAL_HOSTNAME=${PROMETHEUS_EXTERNAL_HOSTNAME:0:-1} # Drop trailing period
PROMETHEUS_EXTERNAL_IP=$($SSH dig +short ${PROMETHEUS_EXTERNAL_HOSTNAME})

ALERTMANAGER_EXTERNAL_HOSTNAME=$($SSH dig +short public.alertmanager.monitoring.cld.internal ptr)
ALERTMANAGER_EXTERNAL_HOSTNAME=${ALERTMANAGER_EXTERNAL_HOSTNAME:0:-1} # Drop trailing period
ALERTMANAGER_EXTERNAL_IP=$($SSH dig +short ${ALERTMANAGER_EXTERNAL_HOSTNAME})

GRAFANA_EXTERNAL_HOSTNAME=$($SSH dig +short public.grafana.monitoring.cld.internal ptr)
GRAFANA_EXTERNAL_HOSTNAME=${GRAFANA_EXTERNAL_HOSTNAME:0:-1} # Drop trailing period
GRAFANA_EXTERNAL_IP=$($SSH dig +short ${GRAFANA_EXTERNAL_HOSTNAME})

ENV_NAME=$($SSH sdget env.cld.internal name)

# bosh_exporter 3.0.0 properly validates the director tls cert, but it currently
# only contains the ip address in the cert SAN. So we have to connect using
# its IP address until we can fix the director tls cert to include the domain
# FIXME change back to director.bosh.cld.internal
BOSH_TARGET=$($SSH dig +short director.bosh.cld.internal)

cat > $DNS_VAR_FILE <<END_OF_OPS
---
prometheus_external_ip: $PROMETHEUS_EXTERNAL_IP
prometheus_external_hostname: $PROMETHEUS_EXTERNAL_HOSTNAME

alertmanager_external_ip: $ALERTMANAGER_EXTERNAL_IP
alertmanager_external_hostname: $ALERTMANAGER_EXTERNAL_HOSTNAME

grafana_external_ip: $GRAFANA_EXTERNAL_IP
grafana_external_hostname: $GRAFANA_EXTERNAL_HOSTNAME

${ENV_NAME}_bosh_target: $BOSH_TARGET

END_OF_OPS

cat $DNS_VAR_FILE
