#! /bin/bash

source utils.sh

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 appName project"
  exit 1
fi

APP=$1
NS=$2

POD=`oc get pod -n $NS -l app=$APP -o jsonpath='{.items[0].metadata.name}'`

echo -e "${MAGENTA}`oc exec -n $NS $POD -c istio-proxy -- \
curl -s http://127.0.0.1:15000/config_dump | \
jq -r .configs[5].dynamic_active_secrets[0].secret | \
jq -r .tls_certificate.certificate_chain.inline_bytes | \
base64 --decode | openssl x509 -text -noout`${WHITE}"
