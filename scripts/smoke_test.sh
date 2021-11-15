#!/bin/bash
# This script can be used as a basic sanity-check for any changes that are being made to the Kine project

source ./env_vars.sh

# Configure ETCDCTL
export ETCDCTL_API=3
ETCDCTL="etcdctl --cacert=${ETCD_CA} --cert=${ETCD_SERVER_CERT} --key=${ETCD_SERVER_KEY}"
ENDPOINT="https://127.0.0.1:2379"

# NOTE: Cannot perform zthis check with objects that are commonly not present like: persistentvolumes persistentvolumeclaims replicationcontrollers
CHECK_OBJECTS=(customresourcedefinitions pods secrets services/specs services/endpoints endpointslices events nodes configmaps namespaces)
for OBJ in ${CHECK_OBJECTS[@]}; do
  for SLASH in "" "/"; do

    LINE_COUNT=$($ETCDCTL get --endpoints $ENDPOINT /kubernetes.io/${OBJ}${SLASH} --prefix | wc -l)
    if (($LINE_COUNT > 10)); then
      echo -n "Test passed for ${OBJ}"
    else
      echo -n "Test has failed for ${OBJ}"
    fi
    if [ "${SLASH}" = "" ]; then
      echo ""
    else
      echo " with slash"
    fi
  done
done



# CHECK_OBJECTS=(customresourcedefinitions pods secrets services/specs services/endpoints endpointslices events nodes configmaps namespaces)
# for OBJ in ${CHECK_OBJECTS[@]}; do
#   $ETCDCTL get --endpoints $ENDPOINT /kubernetes.io/${OBJ}/ | jq 
#   if (($LINE_COUNT > 10)); then
#     echo -n "Test passed for ${OBJ}"
#   else
#     echo -n "Test has failed for ${OBJ}"
#   fi
# done