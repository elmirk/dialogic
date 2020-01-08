CamelGW
=========

# Table of contents
1. [Introduction](#introduction)
1. [Some paragraph](#paragraph1)
    1. [Sub paragraph](#subparagraph1)
1. [CamelGW software components](#components)
1. [SIGTRAN data for interconnection between CamelGW and MSC](#sigtran)
1. [Notes](#notes)
1. [References](#refs)

## This is the introduction <a name="introduction"></a>
Some introduction text, formatted in heading 2 style

## Some paragraph <a name="paragraph1"></a>
The first paragraph text

### Sub paragraph <a name="subparagraph1"></a>
This is a sub paragraph, formatted in heading 3 style

## CamelGW software components<a name="components"></a>

---

TBD!


*List of components:*

| Component     | Comment                                           |
|---------------|---------------------------------------------------|
| Docker engine | Used to run gctload in standalone docker container|
| Tarantool     | NoSQL DB used to store services data |



## The main purpose

This module is responsible to connect the **M**obile **S**witching **C**ontroller (**MSC**) and the server with uploaded "SMS Router" software over the following protocols:
- SCTP
- M3UA
- SCCP
- TCAP
- MAP

The documentation about each of the protocols can be downloaded via the [following link](https://www.dialogic.com/signaling-and-ss7-components/download/dsi-interface-protocol-stacks).

## SIGTRAN data for interconnection between CAMELGW and MSC<a name="sigtran"></a>

---

*M3UA asso data:*

| CamelGW IP1   | CamelGw port1 | MSC IP1      | MSC port1 |
|---------------|---------------|--------------|-----------|
| 172.27.41.186 | 2907          | 172.27.32.4  | 2907      |
| 172.27.41.194 | 2907          | 172.27.32.36 | 2907      |

*Signalling Point Codes:*

|     | CamelGW | MSC   |
|-----|---------|-------|
| SPC | 14118   | 14140 |


*Used VLANs (CamelGW):*

| VLAN ID  | Subnet           | Gateway       |
| ---------|------------------|---------------|
| 338      | 172.27.41.192/29 | 172.27.41.198 |
| 349      | 172.27.41.184/29 | 172.27.41.190 |


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

## Dependencies 

This module is dependent on software by Dialogic company (https://www.dialogic.com/).

The necessary binary files can be downloaded via the [following link](https://www.dialogic.com/signaling-and-ss7-components/download/dsi-interface-protocol-stacks).

All of the protocols are protected by license files.

### How to define the license file?

The path to the license file should be defined in **system.txt** file.

> **Attention**: The addition of the corresponding lines is done automaticaly in **bootstrap.sh** file in this project.

### How to configure the signalling connection?

The **O**riginating **P**oint **C**ode (**OPC**) of the "SMS Router" and the **D**estination **P**oint **C**ode (**DPC**) of the MSC should be defined in the **config.txt** file. Moreover, the **G**lobal **T**itle (**GT**) identifiers of "SMS Router", MSC/HLR and SMSC (SMS Center) should also be defined in considered file:

- To configure DPC search the "M3UA level configuration" and "Configure SCCP module" blocks.
- To configure OPC search the "M3UA level configuration" and "Define Remote Signaling Points" blocks.
- To configure GT search the "SCCP GT translations" block.

The IP addresses and SCTP ports of the "SMS Router" entity are also defined in **config.txt** file.

### How to configure inter-process connections?

The inter-process connection can be defined in **system.txt** file.

For example:

``` bash
LOCAL 0x2e	      * smsrouter
LOCAL 0x5d	      * module id for health_check (run at once type app)
```
This identifier should also be defined in user application ([**cnode**](https://github.com/elmirk/cnode) module in this project). 

The most of the options in **system.txt** file are defined by default. More information can be obtained in *U10SSS-SwEnv-PM.pdf* file.

## SCTP multihoming feature

The multihoming feature of the SCTP protocol \[1, p. 36\] can be used to implement transport reservation scheme (fig. 1).

<img src="https://raw.githubusercontent.com/kirlf/dialogic/master/doc/SMSR%20Stand-Alone.png" width="600" />

*Fig. 1. The structural scheme of the stand-alone backup. The source file is placed in the doc directory in xml format. Redesign can be done, for example, with use of http://www.newart.ru .*

The second host is licensed addtionally.


## Notes<a name="notes"></a>

---

should set some kernel parameters according to Dialogic SW manual
before starting ss7 container

```
sysctl -w kernel.msgmnb=800000
```

## References<a name="refs"></a>

---

[1] TBD!
