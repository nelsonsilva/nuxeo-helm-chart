#!/usr/bin/env bash

# change pwd
pushd `dirname $0`

tenant=$1
export DOCKER_REGISTRY=gcr.io/jx-preprod
export DOCKER_IMAGE=nuxeo-web-ui-$tenant
export VERSION=latest
export HOSTNAME=$tenant.multitenant.nuxeo.com

echo "Deploying Web UI for tenant $tenant"

# preprocess values.yaml to replace some env variables

envsubst < values.tosubst.yaml > target/$tenant-values.yaml

helm3 upgrade nuxeo-web-ui . -i -n $tenant -f target/$tenant-values.yaml


