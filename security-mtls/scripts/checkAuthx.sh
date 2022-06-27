#! /bin/bash

if [ "$#" -eq  0 ]; then
  echo "Usage: $0 project1 [project2 project3 ...]"
  exit 1
fi

echo "##########################################################################"
for NS in "$@"
do
	echo "------------------- $NS PeerAuthentication --------------------------"
	oc get PeerAuthentication -n $NS
	echo
	echo "------------------- $NS AuthorizationPolicy -------------------------"
	oc get AuthorizationPolicy -n $NS
	echo
	echo "------------------- $NS DestinationRule -----------------------------"
	oc get DestinationRule -n $NS
	echo
	echo "------------------- $NS ServiceAccount ------------------------------"
	oc get ServiceAccount -n $NS
	echo
	echo "##########################################################################"
done
