#!/usr/bin/env bash

PID_LIST=()

CONF_DIR="$(dirname $(dirname $(realpath $0)) )/config"

cd ~/free5gc/NFs/upf/build
sudo -E ./bin/free5gc-upfd -f $CONF_DIR/upfcfg.yaml &
PID_LIST+=($!)

function terminate()
{
    sudo kill -SIGTERM ${PID_LIST[${#PID_LIST[@]}-2]} ${PID_LIST[${#PID_LIST[@]}-1]}
    sleep 2
}

trap terminate SIGINT
wait ${PID_LIST}
