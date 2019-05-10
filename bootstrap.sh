#!/bin/bash

#boostrap system.txt file
#1. modify NUM_MSGS and NUM_LMSGS
#2. add last lines with process forking under license control

#author: Elmir Karimullin, elmir.karimullin@gmail.com

############# HISTORY ##################################
# 26/03/2019 ---- Elmir Karimullin ----Initial version #
########################################################



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


#if ENV not set use DEV as default one
[[ -z "${DIALOGIC_STAGE}" ]] && MyVar='DEV' || MyVar="${DIALOGIC_STAGE}"

if [ $MyVar == 'DEV' ]
then
echo "DIALOGIC_STAGE=DEV"
echo "Will use trial license and minimal number of IPC messages"
Lic="FORK_PROCESS ./HSTBIN/m3ua -t -d\n\
FORK_PROCESS ./HSTBIN/sccp -t -d\n\
FORK_PROCESS ./HSTBIN/tcap -t -d\n\
FORK_PROCESS ./HSTBIN/map -t -d"
#value range for NUM_MSGS (100 ... 65000)
sed -i "s/^NUM_MSGS.*/NUM_MSGS 100/" ./system.txt
#value range for NUM_MSGS (100 ... 65000)
sed -i "s/^NUM_LMSGS.*/NUM_LMSGS 100/" ./system.txt
elif [ $MyVar == 'PROD' ]
then
echo "DIALOGIC_STAGE=PROD"
echo "Will use commercial license"
Lic="FORK_PROCESS ./HSTBIN/m3ua -Lp/opt/DSI -d\n\
FORK_PROCESS ./HSTBIN/sccp -Lp/opt/DSI -d\n\
FORK_PROCESS ./HSTBIN/tcap -Lp/opt/DSI -d\n\
FORK_PROCESS ./HSTBIN/map  -Lp/opt/DSI -d"

else
echo "DIALOGIC_STAGE=WRONG"
echo "Will use trial license"
Lic="FORK_PROCESS ./HSTBIN/m3ua -t -d\n\
FORK_PROCESS ./HSTBIN/sccp -t -d\n\
FORK_PROCESS ./HSTBIN/tcap -t -d\n\
FORK_PROCESS ./HSTBIN/map -t -d"

fi

echo -e $Lic >> system.txt
echo -e "finished ok"

#./start_gctload.sh
./gctload -d &
wait
#pid="$!"
