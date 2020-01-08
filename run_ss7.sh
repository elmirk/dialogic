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

#check last column of docker ps cmd result
OUT=$(docker ps | awk '{print $NF}' | grep ss7)

if [ $PIPESTATUS -eq 0 ]
then
    echo -e "\e[31m!!!Warning!!!Container ss7 exist, use \e[32mdocker ps\e[31m to check if ss7 running!\e[0m"
    echo -e "\e[31m!!!Warning!!!If running, then use \e[32mdocker stop ss7\e[31m and try again!\e[0m"
    echo -e "\e[31m!!!Warning!!!script exit now...\e[0m"
    exit
fi

gunzip -c /opt/images/ss7-img.tar.gz | docker load
docker create -it --mac-address 0c:c4:7a:d8:a5:42 --network vlan_349 --ipc host --log-driver=json-file --log-opt env=DIALOGIC_STAGE --log-opt max-size=10m --log-opt max-file=15 -e CONTAINER=ss7 --name ss7 ss7:latest
docker network connect vlan_338 ss7
docker start ss7

#docker run -dit --log-driver=json-file --log-opt env=DIALOGIC_STAGE --log-opt max-size=10m --log-opt max-file=15 -e DIALOGIC_STAGE=$1 -e SMSR_TCAP_ODLGS_NUM -e SMSR_TCAP_IDLGS_NUM -e CONTAINER=ss7 --name=ss7 --ipc="host" --network="host" ss7:test

