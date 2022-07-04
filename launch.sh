#!/bin/bash

# Switch to workdir
cd "${STEAMAPPDIR}"

xvfbpid=""
ckpid=""

function kill_corekeeperserver {
        if [[ ! -z "$ckpid" ]]; then
                kill $ckpid
        fi
        sleep 1
        if [[ ! -z "$xvfbpid" ]]; then
                kill $xvfbpid
        fi
}

trap kill_corekeeperserver EXIT

set -m

rm -f /tmp/.X99-lock

Xvfb :99 -screen 0 1x1x24 -nolisten tcp -nolisten unix &
xvfbpid=$!

rm -f GameID.txt

chmod +x ./CoreKeeperServer

DISPLAY=:99 LD_LIBRARY_PATH="$LD_LIBRARY_PATH:../Steamworks SDK Redist/linux64/" ./CoreKeeperServer -batchmode -logfile -world "${WORLD_INDEX}" -worldname "${WORLD_NAME}" -worldseed "${WORLD_SEED}" -gameid "${GAME_ID}" -ip "${IP}" -port "${PORT}" -datapath "${STEAMAPPDATA}" -maxplayers "${MAX_PLAYERS}" -logfile CoreKeeperServerLog.txt &

ckpid=$!

echo "Started server process with pid $ckpid"

while [ ! -f GameID.txt ]; do
        sleep 0.1
done

echo "Your Game ID is: $(cat GameID.txt)" >> CoreKeeperServerLog.txt
echo "Your Game ID is: $(cat GameID.txt)"

wait $ckpid
ckpid=""