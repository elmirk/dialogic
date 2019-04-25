#!/bin/bash

#in prod use detached mode and should set entrypoint in dockerfile
#docker run -it --log-driver=json-file --log-opt env=DIALOGIC_STAGE --log-opt max-size=10m --log-opt max-file=15 -e DIALOGIC_STAGE=DEV --rm --name=ss7 --ipc="host" --network="host" -v /etc/localtime:/etc/localtime:ro ss7:0.0.0 bash

#when use ELK
#docker run -it --log-driver gelf --log-opt gelf-address=tcp://localhost:5000 -e DIALOGIC_STAGE=DEV --rm --name=dialogic --ipc="host" --network="host" dialogic:0.0.0 bash


#in prod use detached mode and should set entrypoint in dockerfile
docker run -it --log-driver=json-file --log-opt env=DIALOGIC_STAGE --log-opt max-size=10m --log-opt max-file=15 -e DIALOGIC_STAGE=PROD --rm --name=ss7 --ipc="host" --network="host" ss7:0.0.0 bash
