version 0.0 - prod ready

# The main purpose

This module is responsable to connect the **M**obile **S**witching **C**ontroller (**MSC**) and the server with "SMS Router" software over the following protocols:
- SCCP
- TCAP
- MAP

In other words, there is the signalling (**M3UA**) part of the connection in the "SMS Router" project.

# Dependencies 

This module is dependent on software by Dialogic company (https://www.dialogic.com/).

## How to define the licence file?

The path to the license file should be defined in **system.txt** file.

## How to configure the signalling connection?

The **D**estination **P**oint **C**ode (**DPC**) of the "SMS Router" and the **O**riginating **P**oint **C**ode (**OPC**) of the MSC should be defined in the **config.txt** file:

- To configure DPC search the "Configure SCCP module" block.
- To configure OPC search the "Define Remote Signaling Points" block.

The IP addresses are also defined in **config.txt** file.

## SCTP multihomin feature

The multihoming feature of the SCTP protocol \[1, p. 36\] can be used to implement smart transport backup scheme (fig. 1).

<img src="https://raw.githubusercontent.com/kirlf/dialogic/master/doc/SMSR_Stand_Alone.png" width="600" />

*Fig. 1. The structural scheme of the stand-alone backup. The source file is placed in the doc directory in xml format. Redesign can be done, for example, with use of http://www.newart.ru .*

# The structure of the module

This module is organized as the **docker**-container.

To build the image run this in the directory with *Dockerfile*:

```bash
docker build -t ss7:0.0.0
```

To run the docker container use the corresponding script:

``` bash
./run_ss7.sh
```

# Reference

[1] Stevens, W. Richard, Bill Fenner, and Andrew M. Rudoff. [UNIX Network Programming: The Sockets Networking API](https://books.google.ru/books?hl=ru&lr=&id=ptSC4LpwGA0C&oi=fnd&pg=PR17&dq=stevens+unix+network&ots=Kt6CNldmRm&sig=sUeB7wr8sXsdaPyB6B-ZJw6QmGY&redir_esc=y#v=onepage&q=stevens%20unix%20network&f=false). Vol. 1. Addison-Wesley Professional, 2004.
