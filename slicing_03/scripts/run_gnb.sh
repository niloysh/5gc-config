#!/bin/bash
echo "Starting gNB ..."
CONF_DIR="${HOME}/5gc-config/slicing_03/config"

if [ -z "$1" ]; then
    echo "Error! Please specify gNB 1 or 2."
    exit 1
fi

cd ${HOME}/UERANSIM
./build/nr-gnb -c "${CONF_DIR}/free5gc-gnb$1.yaml" &
PID=$!

trap "exit" INT TERM ERR
trap "kill 0" EXIT
wait $PID
