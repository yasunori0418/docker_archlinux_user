FROM archlinux:latest

MAINTAINER yasunori0418

LABEL description="Make user in archlinux."

COPY ./mirrorlist /etc/pacman.d/mirrorlist
COPY ./pacman.conf /etc/pacman.conf

ENV TZ=Asia/Tokyo

RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Syu --noconfirm && \
    pacman -S --noconfirm zsh git vim

ARG UID=1000
ARG GID=1000
ARG USERNAME=user
ARG GROUPNAME=user
ARG PASSWD=user
ARG SHELL=/usr/bin/zsh

RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s $SHELL -u $UID -g $GID -G $GROUPNAME $USERNAME && \
    echo $USERNAME:$PASSWD | chpasswd && \
    echo "$USERNAME    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $UID
WORKDIR /home/$USERNAME
