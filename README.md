# Prometheus Monitoring - BOSH deployment details

Prometheus is an Open source monitoring tool.  A BOSH release was created for it [prometheus-boshrelease](https://github.com/cloudfoundry-community/prometheus-boshrelease).

The BOSH release deploys the following monitoring tools - [Prometheus](<https://prometheus.io/>), [AlertManager](https://github.com/prometheus/alertmanager) and  [Grafana](<https://grafana.com/>).


## Usage

### Setting up local BOSH environment
The instructions for deploying a local BOSH2 director are [here](https://github.com/cloudfoundry/bosh-deployment)

### Basic deployment
The [prometheus boshrelease](https://github.com/cloudfoundry-community/prometheus-boshrelease) provides great documentation as well as the core BOSH deployment manifest and standard operator files.  
This *DTA* repository provides some custom operator files and a concourse pipelines for deploying it to our environments.

#### [deployment-name](operators/deployment-name.yml)
The default deployment name `prometheus` is specified in the main deployment manifest.  This operator file allows you change the name - useful if you deploy more than 1 prometheus service.

#### [dta-platform](operators/dta-platform.yml)
This operator file performs the main customisations for deploying prometheus to cloud.gov.au environments.

#### [dta-platform-nginx-hosts](operators/dta-platform-nginx-hosts.yml)
replace the single nginx host with 3 nginx hosts with instant-https support running in public subnets with EIPs.  the 3 new nginx hosts are for Grafana, Prometheus and Alert-Manager

#### [dta-platform-cf-environments](operators/dta-platform-cf-environments.yml)
run cf-exports and firehose-exporters for the cloud.gov.au environments
