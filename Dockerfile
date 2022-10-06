FROM archlinux:base-devel

MAINTAINER yasunori0418

LABEL description="Create a user in archlinux:base-devel that can use zsh, vim, git, and paru"

COPY ./mirrorlist /etc/pacman.d/mirrorlist
COPY ./pacman.conf /etc/pacman.conf

RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Syu --noconfirm && \
    pacman -S --noconfirm zsh git vim rust xdg-user-dirs

ARG UID=1000
ARG GID=1000
ARG USERNAME=user
ARG GROUPNAME=user
ARG PASSWD=user
ARG SHELL=/usr/bin/zsh

RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s $SHELL -u $UID -g $GID -G $GROUPNAME $USERNAME && \
    echo $USERNAME:$PASSWD | chpasswd && \
    echo "$USERNAME    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    zsh -v >> /home/$USERNAME/.zshrc

USER $UID
WORKDIR /home/$USERNAME

RUN xdg-user-dirs-update && \
    git clone https://aur.archlinux.org/paru.git Downloads/paru && \
    cd Downloads/paru && makepkg --noconfirm -si
