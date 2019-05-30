#!/bin/bash

#elmir.karimullin@gmail.com


#docker run for dialogic stack
docker run -dit --log-driver=json-file --log-opt env=DIALOGIC_STAGE --log-opt max-size=10m --log-opt max-file=15 -e DIALOGIC_STAGE -e SMSR_TCAP_ODLGS_NUM -e SMSR_TCAP_IDLGS_NUM --name=ss7 --ipc="host" --network="host" ss7:0.0.0

sleep 2

#docker run for enode
docker run -dit --log-driver=json-file --log-opt max-size=10m --log-opt max-file=15 -e SMSR_TCAP_ODLGS_NUM -e SMSR_TCAP_IDLGS_NUM --name=enode --network="host" enode:0.0.0

sleep 2

#run cnode container on main prod server castor
docker run -dit --log-driver=json-file --log-opt max-size=10m --log-opt max-file=15 --name=cnode --ipc="host" --network="host" cnode:0.0.0

