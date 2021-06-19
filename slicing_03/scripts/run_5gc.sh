#!/usr/bin/env bash

PID_LIST=()
cd ~/free5gc

CONF_DIR="${HOME}/5gc-config/slicing_03/config"
export GIN_MODE=release

NF_LIST_1="nrf amf"
for NF in ${NF_LIST_1}; do
    ./bin/${NF} -${NF}cfg "${CONF_DIR}/${NF}cfg.yaml" &
    PID_LIST+=($!)
    sleep 0.1
done

./bin/smf -smfcfg "${CONF_DIR}/smf1cfg.yaml" &
PID_LIST+=($!)
sleep 1

./bin/smf -smfcfg "${CONF_DIR}/smf2cfg.yaml" &
PID_LIST+=($!)
sleep 1

NF_LIST_2="udr pcf udm nssf ausf"
for NF in ${NF_LIST_2}; do
    ./bin/${NF} -${NF}cfg "${CONF_DIR}/${NF}cfg.yaml" &
    PID_LIST+=($!)
    sleep 0.1
done

function terminate()
{
    sudo kill -SIGTERM ${PID_LIST[${#PID_LIST[@]}-2]} ${PID_LIST[${#PID_LIST[@]}-1]}
    sleep 2
    # clear mongodb
    cd ${HOME}/5gc-config/slicing_03/scripts
    ./clear_nfinfo.sh
}

trap terminate SIGINT
wait ${PID_LIST}
