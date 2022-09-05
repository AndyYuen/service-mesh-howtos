#! /bin/bash

oc  get clusterrolebindings 2>$- | grep "cluster-admin" > /dev/null 2>&1
if [ $? == 1 ] ; then
  echo "*****************************************************"
  echo "Please login to OpenShift using an account with cluster-admin privileges and rerun command."
  echo "*****************************************************"
  exit 1;
fi

DIR=../manifests

echo "*******************executing commands**********************************"
oc delete -f $DIR/service-mesh.yaml -n openshift-operators
oc delete -f $DIR/kiali.yaml -n openshift-operators
oc delete -f $DIR/tracing.yaml -n openshift-operators
oc delete -f $DIR/elasticsearch.yaml -n openshift-operators-redhat


