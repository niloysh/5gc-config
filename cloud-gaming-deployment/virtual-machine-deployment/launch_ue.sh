#!/bin/bash

# check first positional argument for UE number
if [ -z "$1" ]; then
    echo "Please input UE number as first arg."
    exit 1
fi

echo "Starting UE $1 ..."
CONF_DIR="${HOME}/5gc-config/gaming_vm"

cd ${HOME}/UERANSIM-3.1.7
sudo ./build/nr-ue -c "${CONF_DIR}/ue$1.yaml" &
PID=$!

trap "exit" INT TERM ERR
trap "kill 0" EXIT
wait $PID
