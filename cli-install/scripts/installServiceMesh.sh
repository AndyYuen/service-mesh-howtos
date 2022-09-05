#! /bin/bash

SECS=10

waitTillInstalled() {
  waiting=1
  count=0
  while [ $waiting == 1 ]
  do
    sleep $SECS
    count=`expr $count + $SECS`
    echo "Still waiting after $count seconds."
    RESULT=`oc describe sub $1 -n $2 | yq '.Status.Conditions.Reason == "Installing"'`
    #oc describe sub $1 -n $2 > "$1-$count.txt"
    if [ $RESULT == "false" ]; then 
      waiting=0
    fi
  done
  sleep $SECS
}

oc  get clusterrolebindings 2>$- | grep "cluster-admin" > /dev/null 2>&1
if [ $? == 1 ] ; then
  echo "*****************************************************"
  echo "Please login to OpenShift using an account with cluster-admin privileges and rerun command."
  echo "*****************************************************"
  exit 1;
fi

DIR=../manifests

echo "*******************executing commands**********************************"
oc create -f $DIR/elasticsearch.yaml
#waitTillInstalled elasticsearch-operator openshift-operators-redhat
waitTillInstalled elasticsearch-operator openshift-operators

oc create -f $DIR/tracing.yaml
waitTillInstalled jaeger-product openshift-operators

oc create -f $DIR/kiali.yaml
waitTillInstalled kiali-ossm openshift-operators

oc create -f $DIR/service-mesh.yaml
waitTillInstalled servicemeshoperator openshift-operators



