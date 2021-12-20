#!/bin/bash

# create a new detached tmux session for UEs
tmux new -s ue -d

UE_COUNT=2

echo "Running 2 UEs ..."

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


