#!/bin/bash
# This script is used to start the KubeAPIServer

source ./env_vars.sh

$KUBE_APISERVER  \
--advertise-address=${IP} \
--allow-privileged=true \
--authorization-mode=AlwaysAllow \
--client-ca-file=${CA} \
--enable-bootstrap-token-auth=true \
--etcd-servers=https://${IP}:2379 \
--service-account-issuer=${SA_ISSUER} \
--service-account-key-file=${ETCD_SERVER_CERT} \
--service-account-signing-key-file=${ETCD_SERVER_KEY} \
--disable-admission-plugins=${DEFAULT_ADMISSION_PLUGINS} \
--etcd-cafile=${ETCD_CA} \
--etcd-certfile=${ETCD_SERVER_CERT}  \
--etcd-keyfile=${ETCD_SERVER_KEY} \
--default-watch-cache-size=0 \
--etcd-prefix=kubernetes.io \
--tls-cert-file=${ETCD_SERVER_CERT} \
--tls-private-key-file=${ETCD_SERVER_KEY}
