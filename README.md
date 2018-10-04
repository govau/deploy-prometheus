# Prometheus Monitoring - BOSH deployment details

Prometheus is an Open source monitoring tool.  A BOSH release was created for it [prometheus-boshrelease](https://github.com/cloudfoundry-community/prometheus-boshrelease).

The BOSH release deploys the following monitoring tools - [Prometheus](<https://prometheus.io/>), [AlertManager](https://github.com/prometheus/alertmanager) and  [Grafana](<https://grafana.com/>).

## Usage

### Setting up local BOSH environment
The instructions for deploying a local BOSH2 director are [here](https://github.com/cloudfoundry/bosh-deployment)

### Basic deployment
The [prometheus boshrelease](https://github.com/cloudfoundry-community/prometheus-boshrelease) provides great documentation as well as the core BOSH deployment manifest and standard operator files.  
This *DTA* repository provides some custom operator files and a concourse pipelines for deploying it to our environments.

## DTA operators

#### [bosh-dns-addon](operators/bosh-dns-addon.yml)
- Configuration for BOSH-dns. We assume it has been added as an add-on in the bosh runtime-config. We use this for getting Prometheus federation working.

#### [deployment-name](operators/deployment-name.yml)
- The default deployment name `prometheus` is specified in the main deployment manifest.  This operator file allows you change the name - useful if you deploy more than 1 prometheus service.

#### [dta-platform-add-public-webhosts](operators/dta-platform-add-public-webhosts.yml)
- Add 3 webserver instances to public subnets with EIPs.  the 3 new nginx hosts are for Grafana, Prometheus and AlertManager

#### [dta-aws-cloud-config](operators/dta-aws-cloud-config.yml)
- This operator file performs the main customisations for deploying prometheus to AWS cloud.gov.au environments.

#### [increase-prometheus-global-scrape-timeout](operators/increase-prometheus-global-scrape-timeout.yml)
- increase the scrape timeout from 10s to 20s.

#### [monitor-certwatch](operators/monitor-certwatch.yml)
- scrape the metrics from the certwatcher deployed on cloud.gov.au

#### [monitor-cloudfoundry](operators/monitor-cloudfoundry.yml)
- add cloudfoundry alerts to `prometheus2` instance.
- add cloudfoundry dashboards to `grafana` instance.

#### [monitor-probe](operators/monitor-probe.yml)
- black-box monitoring of urls

#### [prometheus-federation](operators/prometheus-federation.yml)
- ensure linking works even if we have multiple prometheus instances (eg federation setup)
- monitor the federated prometheus instances

#### [prometheus-prod](operators/prometheus-prod.yml)
- run cf-exporter at prod environment
- run firehose-exporter at prod environment
- run bosh-exporter at prod environment

#### [prometheus-sandpit](operators/prometheus-sandpit.yml)
- run cf-exporter at sandpit environment
- run firehose-exporter at sandpit environment
- run bosh-exporter at sandpit environment

#### [prometheus-staging](operators/prometheus-staging.yml)
- run cf-exporter at staging environment
- run firehose-exporter at staging environment
- run bosh-exporter at staging environment

#### [remove-nginx-instance](operators/remove-nginx-instance.yml)
- Remove the nginx instance that comes with default prometheus bosh release.  we remove this in prod as we have 3 new webservers for Grafana, Prometheus and AlertManager


#### [use-uaa-with-bosh](operators/use-uaa-with-bosh.yml)
- our BOSH instances are deployed with UAA.
