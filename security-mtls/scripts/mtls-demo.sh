#! /bin/bash +x

source utils.sh

# -----------------------------------------------------------
# Main program
# -----------------------------------------------------------
MANIFESTS=../manifests
EXECUTE=true
if [ ".$1" ==  ".SKIP-SETUP" ]; then
  EXECUTE=false
elif [ "$#" -gt  0 ]; then
  echo "Usage: $0 [SKIP-SETUP]"
  exit 1
fi

cat << EOF
# ***********************************************************
# This is the beginning of the Service Mesh Security Demo
# ***********************************************************
# Create projects, add them to SMMR and deploy services
# * project: sm-mtls1 - services: echo
# * project: sm-mtls2 - service: echo-hash and echo-asterisk
# * project: nosc-app - service: echo-hyphen
# * Create a service account for each service and associate
#   it with the respective deployment
# ***********************************************************
# Sending a text message "Hello how are you?" to service:
# * echo          - receives "Hello how are you?"
# * echo-hash     - receives "Hello#how#are#you?"
# * echo-asterisk - receives "Hello*how*are*you?"
# * echo-hyphen   - receives "Hello-how-are-you?"
# ***********************************************************

EOF

if $EXECUTE ; then
pause

showYaml $MANIFESTS/smmr-default.yaml

pause
newline
echo "Service identity and automatic side-car injection in deployment"

pause

showYaml $MANIFESTS/mtls1Deployment.yaml

pause
newlinw

showExec oc new-project sm-mtls1
showExec oc new-project sm-mtls2
showExec oc new-project nosc-app
showExec oc replace -f $MANIFESTS/smmr-default.yaml
showExec oc create -f $MANIFESTS/mtls1Deployment.yaml -n sm-mtls1
showExec oc create -f $MANIFESTS/mtls2Deployment.yaml -n sm-mtls2
showExec oc create -f $MANIFESTS/noscDeployment.yaml -n nosc-app


pause
echo "Show certificate of echo in sm-mtls1"
newline
pause

./showCert.sh echo sm-mtls1
else
  echo "Skipping project setup and deployment"
fi

newline
cat << EOF
# ***********************************************************
# Make sure PeerAuthentication is set to PERMISSIVE 
# for the Service Mesh control pane
# ***********************************************************


EOF
pause

showYaml $MANIFESTS/permissivePolicy.yaml

pause

showExec oc replace -f $MANIFESTS/permissivePolicy.yaml -n istio-system

pause
newline
cat << EOF
# ***********************************************************
# Calling every service from within each service container
#
# Expected result: 
# * SUCCESS for all calls
# ***********************************************************

EOF
pause

./callServices.sh

newline
cat << EOF
# ***********************************************************
# Set AuthorizationPolicy to disallow:
#
# echo-hash in project: sm-mtls2 accessing service
#   echo in project: sm-mtls1
# ***********************************************************

EOF
pause

showYaml $MANIFESTS/deny-echo-hash.yaml

pause
showExec oc create -f $MANIFESTS/deny-echo-hash.yaml -n sm-mtls1

pause
newline
cat << EOF
# ***********************************************************
# Calling every service from within each service container
#
# Expected result: SUCCESS for all calls except
# * echo-hash in project: sm-mtls2 cannot access service
#   echo in project: sm-mtls1
# ***********************************************************

EOF
pause

./callServices.sh

newline
cat << EOF
# ***********************************************************
# Set AuthorizationPolicy to disallow:
#
# All containers in project: sm-mtls2 accessing service
#   echo in project: sm-mtls1
# ***********************************************************

EOF
pause

showYaml $MANIFESTS/deny-sm-mtls2.yaml

pause
showExec oc create -f $MANIFESTS/deny-sm-mtls2.yaml -n sm-mtls1

pause
newline
cat << EOF
# ***********************************************************
# Calling every service from within each service container
#
# Expected result: SUCCESS for all calls except
# * All containers in project: sm-mtls2 cannot access service
#   echo in project: sm-mtls1
# ***********************************************************

EOF
pause

./callServices.sh

newline
cat << EOF
# ***********************************************************
# Set PeerAuthentication to STRICT for project sm-mtls2
# to disallow:
#
# echo-hyphen in project: nosc-app accessing services
#   echo-hash and echo-asterisk in project: sm-mtls2
# ***********************************************************

EOF
pause

showYaml $MANIFESTS/strictPolicy.yaml

pause
showExec oc create -f $MANIFESTS/strictPolicy.yaml -n sm-mtls2

pause
newline
cat << EOF
# ***********************************************************
# Calling every service from within each service container
#
# Expected result: SUCCESS for all calls except
# * All containers in project: sm-mtls2 cannot access service
#   echo in project: sm-mtls1 (set up previously)
# * echo-hyphen in project nosc-app cannot access services
#   in sm-mtls2
# ***********************************************************

EOF
pause

./callServices.sh

newline
cat << EOF
# ***********************************************************
# Set DestinationRule to force services in a project sm-mtls2
# always to orignate requests using strict mtls disallowing:
#
# echo-hash and echo-asterisk in project sm-mtls2 accessing 
# echo-hyphen in project nosc-app
# ***********************************************************

EOF
pause

showYaml $MANIFESTS/dr-mtls.yaml

pause
showExec oc create -f $MANIFESTS/dr-mtls.yaml -n sm-mtls2

pause
newline
cat << EOF
# ***********************************************************
# Calling every service from within each service container
#
# Expected result:
# * All containers in project: sm-mtls2 cannot access service
#   echo in project: sm-mtls1 (set up previously)
# * echo-hyphen in project nosc-app cannot access services
#   in sm-mtls2 (set up previously)
# * services in project sm-mtls2 cannot access echo-hyphen
#   in project nosc-app
# ***********************************************************

EOF
pause

./callServices.sh

newline
cat << EOF
# ***********************************************************
# we are done, removing all DestinationRules, 
# PeerAuthentication and AuthorizationPolicy policies
# ***********************************************************

EOF
pause

showExec oc delete -f $MANIFESTS/dr-mtls.yaml -n sm-mtls2
showExec oc delete -f $MANIFESTS/strictPolicy.yaml -n sm-mtls2
showExec oc delete -f $MANIFESTS/deny-sm-mtls2.yaml -n sm-mtls1
showExec oc delete -f $MANIFESTS/deny-echo-hash.yaml -n sm-mtls1

pause
newline
cat << EOF
# ***********************************************************
# To confirm that all DestinationRules, PeerAuthentication 
# and AuthorizationPolicy policies have been removed, let's
# call every service from within each service container
#
# Expected result: 
# * SUCCESS for all calls
# ***********************************************************

EOF
pause

./callServices.sh

newline
cat << EOF
# ***********************************************************
# This is the end of the Service Mesh Security Demo
# ***********************************************************
EOF



