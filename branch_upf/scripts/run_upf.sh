#!/usr/bin/env bash

PID_LIST=()

cd ~/free5gc/NFs/upf/build
sudo -E ./bin/free5gc-upfd -f ~/5gc-config/branch_upf/config/upfcfg.yaml &
PID_LIST+=($!)

function terminate()
{
    sudo kill -SIGTERM ${PID_LIST[${#PID_LIST[@]}-2]} ${PID_LIST[${#PID_LIST[@]}-1]}
    sleep 2
}

trap terminate SIGINT
wait ${PID_LIST}
