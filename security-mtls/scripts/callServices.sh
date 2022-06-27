#! /bin/bash

source utils.sh

SERVICES=()
SERVICES+=(`oc get svc -n sm-mtls1 -l app=echo -o jsonpath='{.items[0].spec.clusterIP}'`)
SERVICES+=(`oc get svc -n sm-mtls2 -l app=echo-hash -o jsonpath='{.items[0].spec.clusterIP}'`)
SERVICES+=(`oc get svc -n sm-mtls2 -l app=echo-asterisk -o jsonpath='{.items[0].spec.clusterIP}'`)
SERVICES+=(`oc get svc -n nosc-app -l app=echo-hyphen -o jsonpath='{.items[0].spec.clusterIP}'`)

SVCNAME=("echo" "echo-hash" "echo-asterisk" "echo-hyphen")

CONTAINEROPTION=("-c echo" "-c echo-hash" "-c echo-asterisk" "")

PODS=()
PODS+=(`oc get pod -n sm-mtls1 -l app=echo -l version=v1 -o jsonpath='{.items[*].metadata.name}'`)
PODS+=(`oc get pod -n sm-mtls2 -l app=echo-hash -o jsonpath='{.items[*].metadata.name}'`)
PODS+=(`oc get pod -n sm-mtls2 -l app=echo-asterisk -o jsonpath='{.items[0].metadata.name}'`)
PODS+=(`oc get pod -n nosc-app -l app=echo-hyphen -o jsonpath='{.items[0].metadata.name}'`)

NS=("sm-mtls1" "sm-mtls2" "sm-mtls2" "nosc-app")

# disabled debug info
echo
: <<'END'
echo "services at:"
for value in "${SERVICES[@]}"
do
     echo $value
done
echo

echo "service name:"
for value in "${SVCNAME[@]}"
do
     echo $value
done
echo

echo "conatiner option:"
for value in "${CONTAINEROPTION[@]}"
do
     echo $value
done
echo

echo "pods:"
for value in "${PODS[@]}"
do
     echo $value
done
echo
END

hitEchoService()
{
	PODNAME=$1
	#echo "PODNAME=$1"
	PROJECT=$2
	#echo "PROJECT=$2"
	SERVICE=$3
	#echo "SERVICE=$3"
	DESC=$4
	#echo "DESC=$4"
	COPT=$5
	#echo "COPT=$5"

oc exec -n $PROJECT $PODNAME  $COPT -i  \
-- /bin/sh -s <<EOF
#! /bin/sh

  echo -n "Hello echo service at $DESC!" | nc $SERVICE 2000

EOF
}

echo "*****************************************************************************"
for i in {0..3};
do

  echo -e "*** Accessing service from pod: ${YELLOW} ${PODS[$i]} ${WHITE} in project: ${YELLOW} ${NS[$i]} ${WHITE}"
  for value in {0..3}
  do
    echo "-----------------------------------------------------------"
    echo -e "* Calling service ${GREEN} ${SVCNAME[$value]} (${SERVICES[$value]})${WHITE} in project: ${GREEN}${NS[$value]}${WHITE}"
    echo "*   with message: \"Hello echo service at ${SVCNAME[$value]}!\""
    echo -e ${CYAN}"==>"${MAGENTA}$(hitEchoService ${PODS[$i]} ${NS[$i]} ${SERVICES[$value]} ${SVCNAME[$value]} "${CONTAINEROPTION[$i]}") ${WHITE}

  done

  echo "*****************************************************************************"
  pause
done

