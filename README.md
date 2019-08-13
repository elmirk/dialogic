version 0.0 - prod ready

## The main purpose

This module is responsible to connect the **M**obile **S**witching **C**ontroller (**MSC**) and the server with uploaded "SMS Router" software over the following protocols:
- SCTP
- M3UA
- SCCP
- TCAP
- MAP

In other words, there is the signalling part of the connection in the "SMS Router" project.

The documentation about each of the protocols can be downloaded via the [following link](https://www.dialogic.com/signaling-and-ss7-components/download/dsi-interface-protocol-stacks).

## Dependencies 

This module is dependent on software by Dialogic company (https://www.dialogic.com/).

The necessary binary files can be downloaded via the [following link](https://www.dialogic.com/signaling-and-ss7-components/download/dsi-interface-protocol-stacks).

> **N.B.**:
> The downloaded archive can be unpacked with use of the [tar](https://pingvinus.ru/answers/844) utility. 

All of the protocols are protected by license files.

### How to define the license file?

The path to the license file should be defined in **system.txt** file.

The addition of the corresponding lines is done in **bootstrap.sh** file in this project.

### How to configure the signalling connection?

The **D**estination **P**oint **C**ode (**DPC**) of the "SMS Router" and the **O**riginating **P**oint **C**ode (**OPC**) of the MSC should be defined in the **config.txt** file. Moreover, the **G**lobal **T**itle (**GT**) identifiers of "SMS Router", MSC/HLR and SMSC (SMS Center) should also be defined in considered file:

- To configure DPC search the "M3UA level configuration" and "Configure SCCP module" blocks.
- To configure OPC search the "M3UA level configuration" and "Define Remote Signaling Points" blocks.
- To configure GT search the "SCCP GT translations" block.

>**N.B.**: Do not mix up the OPC and DPC - this depends on the point of view on the message sending. 

The IP addresses and SCTP ports of the "SMS Router" entity are also defined in **config.txt** file.

### How to configure inter-process connections?

The inter-process connection can be defined in **system.txt** file.

For example:

``` bash
LOCAL 0x2e	      * smsrouter
LOCAL 0x5d	      * module id for health_check (run at once type app)
```
This identifier should also be defined in user application ([**cnode**](https://github.com/elmirk/cnode) module in this project). 

>**N.B.**: The most of the options in **system.txt** file are defined by default.

## SCTP multihoming feature

The multihoming feature of the SCTP protocol \[1, p. 36\] can be used to implement transport reservation scheme (fig. 1).

<img src="https://raw.githubusercontent.com/kirlf/dialogic/master/doc/SMSR_Stand_Alone.png" width="600" />

*Fig. 1. The structural scheme of the stand-alone backup. The source file is placed in the doc directory in xml format. Redesign can be done, for example, with use of http://www.newart.ru .*

The second host is licensed addtionally.

## The structure of the module

This module is organized as the **docker**-container.

To build the image run this in the directory with *Dockerfile*:

```bash
docker build -t ss7:0.0.0
```

To run the docker container use the corresponding script:

``` bash
./run_ss7.sh
```

## Reference

[1] Stevens, W. Richard, Bill Fenner, and Andrew M. Rudoff. [UNIX Network Programming: The Sockets Networking API](https://books.google.ru/books?hl=ru&lr=&id=ptSC4LpwGA0C&oi=fnd&pg=PR17&dq=stevens+unix+network&ots=Kt6CNldmRm&sig=sUeB7wr8sXsdaPyB6B-ZJw6QmGY&redir_esc=y#v=onepage&q=stevens%20unix%20network&f=false). Vol. 1. Addison-Wesley Professional, 2004.
