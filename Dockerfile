FROM ubuntu:18.04 as builder
#
# install dialogic gctload environment
#
COPY dpklnx.Z /opt/DSI/
WORKDIR /opt/DSI
RUN set -xe \
 && tar --no-same-owner -zxvf dpklnx.Z \
 && rm dpklnx.Z

FROM ubuntu:18.04 as prod
LABEL maintainer="elmir.karimullin@gmail.com"
ARG GIT_COMMIT=unspecified
LABEL git_commit=$GIT_COMMIT
COPY --from=builder /opt/DSI /opt/DSI
WORKDIR /opt/DSI
RUN set -xe \
 && dpkg --add-architecture i386 \
 && apt-get update && apt-get install -y --auto-remove libc6-i386 \
    lksctp-tools:i386 iproute2 tzdata \
 && ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime \
 && rm -rf /var/lib/apt/lists/* \
 && echo "/opt/DSI/32" >> /etc/ld.so.conf \
 && echo "/opt/DSI/64" >> /etc/ld.so.conf \
 && ldconfig

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

