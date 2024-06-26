#!/usr/bin/env bash
set -e
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 dev|prod appversion"
    exit 1
fi
#envName=$1
envName=dev # TODO hard coded because it's hardcoded in
appVersion=$2

gcpProject=gcpproject
appName=nodejs-gke
namespace=${appName}-${envName}

echo "*** creating namespace if needed: ${namespace}"
# Create namespace and secret if not existing already
kubectl create ns ${namespace} >& /dev/null && true

echo "*** creating/recreating secrets"
secretsFile=secrets/${envName}.env
sh create-secrets-yaml.sh ${secretsFile} next-trading-secrets secrets/secrets.yaml
kubectl -n ${namespace} apply -f secrets/secrets.yaml

# Build and push images
appImageTag="eu.gcr.io/${gcpProject}/${appName}-${envName}-app:${appVersion}"
echo "image: $appImageTag"
gcloud auth configure-docker
docker build --platform linux/amd64 -t ${appImageTag} --file Dockerfile .
echo "*** Pushing app image"
docker push ${appImageTag}

# In case you want VERSION as an env variable in the app:
# - Add argument to docker build: --build-arg VERSION=${appVersion}
# - Add to Dockerfile:
#     ARG VERSION=dev
#     ENV VERSION ${VERSION}

# Deploy into k8s cluster
echo "*** kubectl apply"
# substitute environment and version in k8s.yaml, right now hardcoded
kubectl apply -f k8s.yaml
