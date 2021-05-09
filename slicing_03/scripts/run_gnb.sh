#!/bin/bash
echo "Starting gNB ..."
CONF_DIR="${HOME}/5gc-config/slicing_02/config"

cd ${HOME}/UERANSIM
./build/nr-gnb -c "${CONF_DIR}/free5gc-gnb.yaml" &
PID=$!

trap "exit" INT TERM ERR
trap "kill 0" EXIT
wait $PID
