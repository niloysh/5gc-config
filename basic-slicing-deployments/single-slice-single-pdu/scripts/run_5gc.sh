#!/usr/bin/env bash

# This script runs all the free5gc binaries expect the UPF
# On termination, it clears the NF entries in MongoDB

PID_LIST=()
cd ~/free5gc

NF_LIST="nrf amf smf udr pcf udm nssf ausf"
CONF_DIR="$(dirname $(dirname $(realpath $0)) )/config"

export GIN_MODE=release

for NF in ${NF_LIST}; do
    ./bin/${NF} -${NF}cfg "${CONF_DIR}/${NF}cfg.yaml" &
    PID_LIST+=($!)
    sleep 0.1
done

function terminate()
{
    sudo kill -SIGTERM ${PID_LIST[${#PID_LIST[@]}-2]} ${PID_LIST[${#PID_LIST[@]}-1]}
    sleep 2

    # clear mongodb after run
    cd ${HOME}/5gc-config/single_upf/scripts
    mongo < clear_nfinfo.js
}

trap terminate SIGINT
wait ${PID_LIST}
