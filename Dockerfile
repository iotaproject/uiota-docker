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
RUN "echo" "deb http://http.us.debian.org/debian jessie non-free" >> /etc/apt/sources.list

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
    vim \
	wget

# Adduser `uiota`
RUN adduser --disabled-password --gecos "" uiota && usermod -a -G dialout uiota

# Create our main work directory
RUN mkdir /uiota

# Create dir that will be used for staging our apps
RUN mkdir /uiota/staging

# Create dir that will be used for firmware output
RUN mkdir /uiota/firmware

# My heart belongs to daddy
RUN chown -R uiota:uiota /uiota

# Crosstool demands non-root user for compilation
USER uiota

# esp-open-sdk
RUN cd /uiota && git clone --recursive https://github.com/pfalcon/esp-open-sdk.git
RUN cd /uiota/esp-open-sdk && make STANDALONE=n

# Get Expressif source examples
RUN cd /uiota && git clone https://github.com/esp8266/source-code-examples.git

# esptool-ck
RUN cd /uiota && git clone https://github.com/tommie/esptool-ck.git && cd esptool-ck && make

# Export ENV
ENV PATH /uiota/esp-open-sdk/xtensa-lx106-elf/bin:$PATH
ENV XTENSA_TOOLS_ROOT /uiota/esp-open-sdk/xtensa-lx106-elf/bin
ENV SDK_BASE /uiota/esp-open-sdk/esp_iot_sdk_v1.4.0
ENV FW_TOOL /uiota/esptool-ck/esptool

# esp-open-rtos
RUN cd /uiota/ && git clone --recursive https://github.com/Superhouse/esp-open-rtos.git

# Espruino
RUN cd /uiota/ && git clone https://github.com/espruino/Espruino.git
ENV ESP8266_SDK_ROOT $SDK_BASE
ENV ESP8266_BOARD 1
ENV FLASH_4MB 1
ENV COMPORT /dev/ttyUSB0

# Micropython
RUN cd /uiota/ && git clone https://github.com/micropython/micropython.git

# Back to root
USER root

CMD (cd /uiota/ && /bin/bash)
