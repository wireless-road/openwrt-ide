FROM ubuntu:20.04

RUN apt-get update
RUN apt-get upgrade -y

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

RUN apt-get install -y build-essential libssl-dev git libncurses5-dev unzip gawk zlib1g-dev flex vim curl wget bison python net-tools iputils-ping libflatbuffers-dev openjdk-8-jre libswt-gtk* libcanberra-gtk-module udev gdb-multiarch

COPY install.sh drivers /drivers/
RUN ls /drivers
#COPY install.sh /drivers
#RUN ls /drivers

RUN ["/drivers/install.sh"]

ARG UNAME=al
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

RUN mkdir -p /opt/eclipse/
RUN chown $UNAME:$UNAME /opt/eclipse

USER $UNAME

COPY --chown=1000:1000 setup_ide.sh m2m-eclipse.tar.gz projects "/home/$UNAME/"
WORKDIR /home/$UNAME

