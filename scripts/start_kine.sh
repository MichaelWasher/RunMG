#!/bin/bash
# This script is used to start the Kine Server

source ./env_vars.sh

# Start Kine
${KINE_BIN}  \
--endpoint mustgather --debug \
--server-cert-file=${PKI}/server.crt \
--server-key-file=${PKI}/server.key \
--ca-file=${PKI}/ca.crt
