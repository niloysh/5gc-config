#!/bin/bash

# create a new detached tmux session for UEs
tmux new -s ue -d

UE_COUNT=1

if  [ -z "$1" ]; then
    echo "UE count not supplied, using default value of 1"
else
    echo "Running $1 UEs ..."
    UE_COUNT=$1
fi

# pause 2 sec before switching to new session
sleep 2

# create new windows for UEs
for i in $(seq $UE_COUNT); do
   tmux send -t ue 'tmux new-window -n' "ue$i"  ENTER
done

# run the UE launch commands
for i in $(seq $UE_COUNT); do
   tmux send -t ue 'tmux send -t' "ue$i" ' "./launch_ue.sh ' "$i" '" ENTER' ENTER
done

# if currently in a tmux session, switch to the new session
if [ -n "$TMUX" ]; then  
    tmux switch -t ue
else
    tmux a -t ue  # otherwise attach to the new session
fi


