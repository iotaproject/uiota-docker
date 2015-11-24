#
# uIota Dockerfile
#
# The resulting image will contain everything needed to build uIota FW.
#
# Setup: (only needed once per Dockerfile change)
# 1. install docker, add yourself to docker group, enable docker, relogin
# 2. # docker build -t uiota-build .
#
# Usage:
# 3. cd to riot root
# 4. # docker run -i -t -u $UID -v $(pwd):/data/riotbuild uiota-build ./dist/tools/compile_test/compile_test.py


FROM debian:jessie

MAINTAINER Drasko DRASKOVIC <drasko.draskovic@mainflux.com>

# unrar is non-free
RUN "echo" "deb http://http.us.debian.org/debian testing non-free" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    autoconf \
	automake \
	bison \
	bzip2 \
	flex \
	g++ \
	gawk \
	gcc \
	git \
	gperf \
	libexpat-dev \
	libtool \
    libtool-bin \
	make \
	ncurses-dev \
	nano \
	python \
	python-serial \
	sed \
	texinfo \
	unrar \
	unzip \
	wget

RUN adduser uiota && usermod -a -G dialout uiota

USER uiota

RUN cd /home/uiota && git clone --recursive https://github.com/pfalcon/esp-open-sdk.git

RUN cd /home/uiota/esp-open-sdk && make STANDALONE=n

RUN (cd /home/uiota/ && git clone https://github.com/esp8266/source-code-examples.git)

RUN (cd /home/uiota/ && git clone https://github.com/tommie/esptool-ck.git && cd esptool-ck && make )

ENV PATH /home/uiota/esp-open-sdk/xtensa-lx106-elf/bin:$PATH
ENV XTENSA_TOOLS_ROOT /home/uiota/esp-open-sdk/xtensa-lx106-elf/bin
ENV SDK_BASE /home/uiota/esp-open-sdk/esp_iot_sdk_v1.4.0
ENV FW_TOOL /home/uiota/esptool-ck/esptool

# esp-open-rtos
RUN cd /home/uiota/ && git clone --recursive https://github.com/Superhouse/esp-open-rtos.git

# espruino
RUN cd /home/uiota/ && git clone https://github.com/espruino/Espruino.git
ENV ESP8266_SDK_ROOT $SDK_BASE

CMD (cd /home/uiota/ && /bin/bash)
