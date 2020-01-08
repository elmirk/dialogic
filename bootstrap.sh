#!/bin/bash
set -e
#boostrap system.txt file
#1. modify NUM_MSGS and NUM_LMSGS
#2. add last lines with process forking under license control


############# HISTORY ###################################################################
# 26/03/2019 ---- Elmir Karimullin ---- Initial version
# 11/05/2019 ---- Elmir Karimullin ---- Added trap for SIGTERM, removed start_gctload.sh
#########################################################################################



# SIGTERM-handler
term_handler() {
#  if [ $pid -ne 0 ]; then
#    kill -SIGTERM "$pid"
#    wait "$pid"
    #  fi
    echo 'ss7 container receive SIGTERM...'
    ./gctload -x
    exit 143; # 128 + 15 -- SIGTERM
}


trap 'term_handler' SIGTERM

./gctload -d &
wait

#pid="$!"
