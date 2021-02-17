#/bin/bash

echo "deployment with api and worker nodes for Nuxeo"

./repositories/deploy-nuxeo-repository-secret.sh final2

./deploy-script.sh final2

./nuxeo-web-ui/build.sh final2

./nuxeo-web-ui/deploy.sh final2


