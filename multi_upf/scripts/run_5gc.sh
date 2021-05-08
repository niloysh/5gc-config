#!/usr/bin/env bash

PID_LIST=()
cd ~/free5gc

NF_LIST="nrf amf smf udr pcf udm nssf ausf"
CONF_DIR="${HOME}/5gc-config/multi_upf/config"

export GIN_MODE=release

for NF in ${NF_LIST}; do
    ./bin/${NF} -${NF}cfg "${CONF_DIR}/${NF}cfg.yaml" &
    PID_LIST+=($!)
    sleep 0.1
done

sudo ./bin/n3iwf &
SUDO_N3IWF_PID=$!
sleep 1
N3IWF_PID=$(pgrep -P $SUDO_N3IWF_PID)
PID_LIST+=($SUDO_N3IWF_PID $N3IWF_PID)

function terminate()
{
    sudo kill -SIGTERM ${PID_LIST[${#PID_LIST[@]}-2]} ${PID_LIST[${#PID_LIST[@]}-1]}
    sleep 2
}

trap terminate SIGINT
wait ${PID_LIST}
