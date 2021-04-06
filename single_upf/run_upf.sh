#!/usr/bin/env bash

PID_LIST=()

cd NFs/upf/build
sudo -E ./bin/free5gc-upfd &
PID_LIST+=($!)

function terminate()
{
    sudo kill -SIGTERM ${PID_LIST[${#PID_LIST[@]}-2]} ${PID_LIST[${#PID_LIST[@]}-1]}
    sleep 2
}

trap terminate SIGINT
wait ${PID_LIST}
