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
	wget \
    sudo

# Change root password to something known
RUN echo "root:uiota" | chpasswd

# Adduser `uiota`
RUN adduser --disabled-password --gecos "" uiota && usermod -a -G dialout uiota
RUN echo "uiota ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir /uiota && chown -R uiota:uiota /uiota

USER uiota

RUN cd /uiota && git clone --recursive https://github.com/pfalcon/esp-open-sdk.git

RUN cd /uiota/esp-open-sdk && make STANDALONE=n

RUN cd /uiota && git clone https://github.com/esp8266/source-code-examples.git

RUN cd /uiota && git clone https://github.com/tommie/esptool-ck.git && cd esptool-ck && make

ENV PATH /uiota/esp-open-sdk/xtensa-lx106-elf/bin:$PATH
ENV XTENSA_TOOLS_ROOT /uiota/esp-open-sdk/xtensa-lx106-elf/bin
ENV SDK_BASE /uiota/esp-open-sdk/esp_iot_sdk_v1.4.0
ENV FW_TOOL /uiota/esptool-ck/esptool

# esp-open-rtos
RUN cd /uiota/ && git clone --recursive https://github.com/Superhouse/esp-open-rtos.git

# Espruino
RUN cd /uiota/ && git clone https://github.com/espruino/Espruino.git
ENV ESP8266_SDK_ROOT $SDK_BASE

# Micropython
RUN cd /uiota/ && git clone https://github.com/micropython/micropython.git

USER root

CMD (cd /uiota/ && /bin/bash)
