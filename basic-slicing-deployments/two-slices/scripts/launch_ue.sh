#!/bin/bash

# check first positional argument for UE number
if [ -z "$1" ]; then
    echo "Please input UE number as first arg."
    exit 1
fi

echo "Starting UE $1 ..."
CONF_DIR="$(dirname $(dirname $(realpath $0)) )/config"

cd ${HOME}/UERANSIM
sudo ./build/nr-ue -c "${CONF_DIR}/free5gc-ue$1.yaml" &
PID=$!

trap "exit" INT TERM ERR
trap "kill 0" EXIT
wait $PID
