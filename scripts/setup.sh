#!/bin/bash
# This script can be used to setup the required resources and binaries for running testing

source ./env_vars.sh

# Setup KubeAPI
if [[ -f $KUBE_APISERVER ]] ; then
  echo "Using the kube-apiserver located at $KUBE_APISERVER"
else
  echo "Unable to locate a kube-apiserver within the resource directory. Downloading the Linux build."
  echo "If this is running on a Mac, a compatable kube-apiserver binary must be placed into the $RESOURCE_DIR directory to continue"
  wget https://dl.k8s.io/v1.22.4/bin/linux/amd64/kube-apiserver -O "${KUBE_APISERVER}"
  chmod +x "${KUBE_APISERVER}"
fi

# Build and Configure Kine
if [[ -f $KINE_BIN ]] ; then
  echo "Using the Kine binary located at $KINE_BIN"
else
  if [[ `find ${KINE_DIR} -type d | wc -l` < 2  ]] ; then 
    git submodule init
    git submodule update
  fi
 
  echo "Building Kine from the source located in the Git Submodule ( ${KINE_DIR} )"
  ${KINE_DIR}/scripts/build
  cp ${KINE_DIR}/bin/kine ${KINE_BIN}
fi


# Configure Certificates
cd ${PKI}
# Create CAcert to be shared for all communication
openssl req -nodes -x509 -newkey rsa:2048  -config san.cnf  -keyout ca.key -out ca.crt -subj "/C=AU/ST=QLD/L=Brisbane/O=RedHat/OU=root/CN=root/emailAddress=sample@sample.com"

# Generate CSR and Sign
openssl req -nodes -newkey rsa:2048  -config san.cnf  -keyout server.key -out server.csr -subj "/C=AU/ST=QLD/L=Brisbane/O=RedHat/OU=root/CN=localhost/emailAddress=sample@sample.com"

openssl x509 -req  -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -extfile ./san.cnf -extensions v3_req

# Create KubeConfig
export KUBECONFIG="${PKI}/kubeconfig"
export CA_DATA=`cat ca.crt | base64`
export KUBECONFIG_CERT_DATA=`cat server.crt | base64`
export KUBECONFIG_KEY_DATA=`cat server.key  | base64`

cat kubconfig_template | envsubst > kubeconfig
cd -

# Setup Must-Gather
if [[ `find ${ROOT_DIR}/must-gather -type d | wc -l` < 2  ]] ; then 
  echo "#######################"
  echo "Please ensure that the must-gather folder is replaced with a valid must-gather collected from an OpenShift cluster."
  echo "#######################"
fi
echo "##############################################"
echo "To start using the cluster"
echo "----------------------------------------------"
echo "1) Set the KUBECONFIG environment variable to point at the kubeconfig file located at ${KUBECONFIG}"
echo "2) Collect a Must-Gather in the must-gather folder; 'oc adm must-gather --dest-dir=must-gather'"
echo "3) Start the Kine Server with the start_kine.sh script"
echo "4) Start the KubeAPI Server with the start_apiserver.sh script"
echo "5) List Pods with 'oc get pods'"