FROM ubuntu:18.04

#
# install dialogic gctload environment
#
COPY dpklnx.Z /opt/DSI/
WORKDIR /opt/DSI
RUN set -xe \
 && dpkg --add-architecture i386 \
 && apt-get update && apt-get install -y --auto-remove libc6-i386 lksctp-tools:i386 nano tzdata \
 && ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime \
 && rm -rf /var/lib/apt/lists/* \
 && tar --no-same-owner -zxvf dpklnx.Z \
 && echo "/opt/DSI/32" >> /etc/ld.so.conf \
 && echo "/opt/DSI/64" >> /etc/ld.so.conf \
 && ldconfig \
 && rm dpklnx.Z \
 && apt-get clean

#
# copy config files and scripts into image
# .bashrc used for colorized [ss7] indicator in promt when connect to container
COPY .bashrc /root/
COPY system.txt config.txt sms_router.lic bootstrap.sh /opt/DSI/

ENTRYPOINT ["./bootstrap.sh"]

#TODO:
#
#2. check gctload sw guide - maybe should tune some params according it
#

