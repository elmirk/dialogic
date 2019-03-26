FROM ubuntu:18.04

#COPY otp_src_21.1.tar.gz /opt
#WORKDIR /opt
#
# install erlang libs for c node
#
#RUN set -xe \
#        && apt-get update && apt-get install -y gcc make  \
#	&& tar -xvf otp_src_21.1.tar.gz \
#        && cd otp_src_21.1 \
#        && export ERL_TOP=`pwd` \
#        && ./configure --without-termcap \
#        && export TARGET=`erts/autoconf/config.guess` \
#        && cd lib/erl_interface \
#        && make opt \
#        && make release RELEASE_PATH=/usr/local/lib/erlang \
#        && rm /opt/otp_src_21.1.tar.gz \
#        && rm -rf /var/cache/apt \
#        && apt-get clean

#
# install dialogic gctload environment
#
COPY dpklnx.Z /opt/DSI/
WORKDIR /opt/DSI
RUN set -xe \
 && dpkg --add-architecture i386 \
 && apt-get update && apt-get install -y --auto-remove libc6-i386 lksctp-tools:i386 \
 && rm -rf /var/lib/apt/lists/* \
 && tar --no-same-owner -zxvf dpklnx.Z \
 && echo "/opt/DSI/32" >> /etc/ld.so.conf \
 && echo "/opt/DSI/64" >> /etc/ld.so.conf \
 && ldconfig \
 && rm dpklnx.Z \
 && apt-get clean

#
# copy cnode sources into docker and compile
#
#RUN mkdir src

COPY system.txt bootstrap.sh start_gctload.sh /opt/DSI/
#WORKDIR DSI
#RUN set -xe \
#        && make map_user

#ENTRYPOINT ["./bootstrap.sh"]

#TODO:
#
#1. last line in Dockerfile should be CMD or ENTRYPOINT command where we
#run map_user
#2. check gctload sw guide - maybe should tune some params according it
#

