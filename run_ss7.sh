#!/bin/bash

#elmir.karimullin@gmail.com
#script used to start ss7 docker container manually

#SCRIPT USAGE:
#to run ss7 in production use:
# run_ss7.sh PROD
#to run ss7 in dev use:
# run_ss7.sh DEV

#NOTES:
#
#1. not used --rm option in docker run,so when DOCKER STOP SS7 used to stop container
#then container not deleted, should delete container by DOCKER RM SS7 before run it again by this script
#2. if you delete container then you couldn't use DOCKER LOGS SS7 to fetch container logs

#when use ELK
#docker run -it --log-driver gelf --log-opt gelf-address=tcp://localhost:5000 -e DIALOGIC_STAGE=DEV --rm --name=dialogic --ipc="host" --network="host" dialogic:0.0.0 bash


if [ -n "$1" ]
then
    if [ $1 == 'DEV' ] || [ $1 == 'PROD' ] 
    then
        echo "DIALOGIC_STAGE=$1"
    else
        echo "Script usage:"
        echo -e "\e[32m./run_ss7.sh DEV\e[0m to run ss7 in dev environment"
        echo -e "\e[32m./run_ss7.sh PROD\e[0m to run ss7 in production environment"
        exit
    fi
else
    echo "Script usage:"
    echo -e "\e[32m./run_ss7.sh DEV\e[0m to run ss7 in dev environment"
    echo -e "\e[32m./run_ss7.sh PROD\e[0m to run ss7 in production environment"
    exit
fi

#check last column of docker ps cmd result
OUT=$(docker ps | awk '{print $NF}' | grep ss7)

if [ $PIPESTATUS -eq 0 ]
then
    echo -e "\e[31m!!!Warning!!!Container ss7 exist, use \e[32mdocker ps\e[31m to check if ss7 running!\e[0m"
    echo -e "\e[31m!!!Warning!!!If running, then use \e[32mdocker stop ss7\e[31m and try again!\e[0m"
    echo -e "\e[31m!!!Warning!!!script exit now...\e[0m"
    exit
fi

#check existance of environment varibles
if [ -n "$SMSR_TCAP_IDLGS_NUM" ]; then
  echo 'SMSR_TCAP_IDLGS_NUM = $SMSR_TCAP_IDLGS_NUM'
else
    echo -e "\e[31m!!!Warning!!!env variable SMSR_TCAP_IDLGS_NUM not set!!!\e[0m"
    echo -e "\e[31m!!!Warning!!!Set SMSR_TCAP_IDLGS_NUM with \e[32mexport SMSR_TCAP_IDLGS_NUM=VALUE\e[31m and try again!\e[0m"
    echo -e "\e[31m!!!Warning!!!script exit now...\e[0m"
    exit
fi

if [ -n "$SMSR_TCAP_ODLGS_NUM" ]; then
    echo 'SMSR_TCAP_ODLGS_NUM = $SMSR_TCAP_ODLGS_NUM'
else
    echo -e "\e[31m!!!Warning!!!env variable SMSR_TCAP_ODLGS_NUM not set!!!\e[0m"
    echo -e "\e[31m!!!Warning!!!Set SMSR_TCAP_ODLGS_NUM with \e[32mexport SMSR_TCAP_ODLGS_NUM=VALUE\e[31m and try again!\e[0m"
    echo -e "\e[31m!!!Warning!!!script exit now...\e[0m"
    exit
fi

#docker run
docker run -dit --log-driver=json-file --log-opt env=DIALOGIC_STAGE --log-opt max-size=10m --log-opt max-file=15 -e DIALOGIC_STAGE=$1 -e SMSR_TCAP_ODLGS_NUM -e SMSR_TCAP_IDLGS_NUM -e CONTAINER=ss7 --name=ss7 --ipc="host" --network="host" ss7:0.0.0
