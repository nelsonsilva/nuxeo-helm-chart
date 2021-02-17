#!/usr/bin/env bash

# change pwd
pushd `dirname $0`

tenant=$1
image=nuxeo-web-ui-$tenant
hostname=$tenant.multitenant.nuxeo.com

nuxeo_status() {
  status=$(curl -fs https://$hostname/nuxeo/runningstatus)
  if [[ $? -ne 0 ]]; then
    return 1
  fi
  echo ${status}
  return 0
}

until nuxeo_status; do
  >&2 echo "Waiting for Nuxeo to be up ..."
  sleep 5
done

echo "Building Web UI image $image for tenant $tenant"

pod=$(kubectl get pod -n $tenant -l=tier=frontend -o jsonpath="{.items[0].metadata.name}")

rm -rf target
mkdir target

kubectl cp $tenant/$pod:/opt/nuxeo/server/nxserver/nuxeo.war/ui target/ui
cp index.html target/ui
rm target/ui/*.jsp

echo "Retrieving Web UI configuration"
#read -p "Username (Administrator): " username
#read -p "Password (Administrator): " password

curl -u ${username:=Administrator}:${password:=Administrator} https://$hostname/nuxeo/ui/config.jsp --output target/ui/config.js

docker build  -t $image . 

imageid=$(docker images -q $image)

docker tag $imageid gcr.io/jx-preprod/$image
docker push gcr.io/jx-preprod/$image
