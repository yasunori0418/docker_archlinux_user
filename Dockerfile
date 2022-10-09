FROM archlinux:base-devel

LABEL maintainer='yasunori0418' \
      description="Create a user in archlinux:base-devel. \
                   You can add packages specified in pkglist. \
                   And configure the user directory with the structure of the XDG Base Directory."

# Archlinux package manager configs mount in container.
COPY ./config/mirrorlist    /etc/pacman.d/mirrorlist
COPY ./config/pacman.conf   /etc/pacman.conf
COPY ./config/makepkg.conf  /etc/makepkg.conf

# You can specify a list of non-aur packages in text format.
# Adding package list.
COPY ./config/pkglist.txt   /etc/pacman.d/pkglist.txt

# The pacman-key and pacman -Syu commands must be run for the initial time with archlinux images.
RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Syu --noconfirm && \
    pacman -S --needed --noconfirm - < /etc/pacman.d/pkglist.txt

# Arguments for user making.
ARG UID=1000
ARG GID=1000
ARG USER_NAME=user
ARG GROUP_NAME=user
ARG PASSWD=user
ARG SHELL_NAME=bash
ARG SHELL=/usr/bin/${SHELL_NAME}

RUN groupadd -g ${GID} ${GROUP_NAME} && \
    useradd -m -s ${SHELL} -u ${UID} -g ${GID} -G ${GROUP_NAME} ${USER_NAME} && \
    echo ${USER_NAME}:${PASSWD} | chpasswd && \
    echo "${USER_NAME}    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Change the user used from root to $USER_NAME.
USER ${UID}:${GID}
WORKDIR /home/${USER_NAME}

# Structuring XDG Base Directory in user directory.
RUN xdg-user-dirs-update

# Execute ${SHELL} in the container.
CMD ${SHELL}
