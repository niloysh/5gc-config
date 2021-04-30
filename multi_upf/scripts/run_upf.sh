#!/usr/bin/env bash
# script to run free5gc UPF function

PID_LIST=()
cd ~/free5gc/NFs/upf/build

if [ -z "$1" ]; then
    echo "No UPF specified. Using default configuration."
    sudo -E ./bin/free5gc-upfd -f "${HOME}/5gc-config/multi_upf/config/upfcfg.yaml" &
else
    echo "Using configuration for UPF $1"
    sudo -E ./bin/free5gc-upfd -f "${HOME}/5gc-config/multi_upf/config/upfcfg$1.yaml" &
fi

PID_LIST+=($!)

function terminate()
{
    sudo kill -SIGTERM ${PID_LIST[${#PID_LIST[@]}-2]} ${PID_LIST[${#PID_LIST[@]}-1]}
    sleep 2
}

trap terminate SIGINT
wait ${PID_LIST}
