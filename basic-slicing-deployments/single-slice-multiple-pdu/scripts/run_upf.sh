#!/usr/bin/env bash
# script to run free5gc UPF function

CONF_DIR="$(dirname $(dirname $(realpath $0)) )/config"

PID_LIST=()
cd ~/free5gc/NFs/upf/build

if [ -z "$1" ]; then
    echo "No UPF specified. Exiting ..."
    exit 1
else
    echo "Using configuration for UPF $1"
    sudo -E ./bin/free5gc-upfd -f $CONF_DIR/upfcfg$1.yaml &
fi

PID_LIST+=($!)

function terminate()
{
    sudo kill -SIGTERM ${PID_LIST[${#PID_LIST[@]}-2]} ${PID_LIST[${#PID_LIST[@]}-1]}
    sleep 2
}

trap terminate SIGINT
wait ${PID_LIST}
