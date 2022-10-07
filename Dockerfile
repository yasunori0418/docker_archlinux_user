FROM archlinux:base-devel

LABEL maintainer='yasunori0418' \
      description="Create a user in archlinux:base-devel that can use zsh, vim, git. \
                   And configure the user directory with the structure of the XDG Base Directory."

# Archlinux package manager configs mount in container.
COPY ./mirrorlist /etc/pacman.d/mirrorlist
COPY ./pacman.conf /etc/pacman.conf
COPY ./makepkg.conf /etc/makepkg.conf

# The pacman-key and pacman -Syu commands must be run for the initial time with archlinux images.
# And adding packages of git, zsh, vim and xdg-user-dirs.
RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Syu --noconfirm && \
    pacman -S --noconfirm zsh git vim xdg-user-dirs

# Arguments for user making.
ARG UID=1000
ARG GID=1000
ARG USERNAME=user
ARG GROUPNAME=user
ARG PASSWD=user

# Dont change arg.
# This image of purpose is can use zsh.
ARG SHELL=/usr/bin/zsh

RUN groupadd -g ${GID} ${GROUPNAME} && \
    useradd -m -s ${SHELL} -u ${UID} -g ${GID} -G ${GROUPNAME} ${USERNAME} && \
    echo ${USERNAME}:${PASSWD} | chpasswd && \
    echo "${USERNAME}    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Change the user used from root to $USERNAME.
USER ${UID}:${GID}
WORKDIR /home/${USERNAME}

# Structuring XDG Base Directory in user directory.
# And making empty .zshrc file.
RUN xdg-user-dirs-update && \
    touch $HOME/.zshrc

# Execute zsh at the time of entering the container.
CMD zsh
