#! /bin/bash

oc  get clusterrolebindings 2>$- | grep "cluster-admin" > /dev/null 2>&1
if [ $? == 0 ] ; then
  echo "*****************************************************"
  echo "Please login to OpenShift using an account with normal pirvileges and rerun command."
  echo "*****************************************************"
  exit 1;
fi

DIR=../manifests

echo "*******************executing commands**********************************"
oc new-project istio-system
oc create -f $DIR/basic.yaml -n istio-system
oc create -f $DIR/smmr.yaml -n istio-system

