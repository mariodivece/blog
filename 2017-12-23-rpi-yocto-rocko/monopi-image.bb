SUMMARY = "The MonoPi Image"
HOMEPAGE = "https://github.com/mariodivece/blog/tree/master/2017-12-23-rpi-yocto-rocko"
LICENSE = "MIT"

IMAGE_FEATURES += "package-management splash"
IMAGE_LINGUAS = "en-us"

inherit core-image

DEPENDS += "bcm2835-bootfiles"

CORE_OS = " \
    openssh openssh-keygen openssh-sftp-server \
    term-prompt \
    tzdata \
"

WIFI_SUPPORT = " \
    crda \
    iw \
    linux-firmware-bcm43430 \
    wireless-tools \
    wpa-supplicant \
"

DEV_SDK_INSTALL = " \
    binutils \
    binutils-symlinks \
    coreutils \
    cpp \
    cpp-symlinks \
    diffutils \
    file \
    g++ \
    g++-symlinks \
    gcc \
    gcc-symlinks \
    gdb \
    gdbserver \
    gettext \
    git \
    ldd \
    libstdc++ \
    libstdc++-dev \
    libtool \
    make \
    pkgconfig \
    python3-modules \
    mono \
"

DEV_EXTRAS = " \
    ntp \
    ntp-tickadj \
    serialecho  \
    spiloop \
"

EXTRA_TOOLS_INSTALL = " \
    bzip2 \
    devmem2 \
    dosfstools \
    ethtool \
    fbset \
    findutils \
    i2c-tools \
    iperf3 \
    iproute2 \
    iptables \
    less \
    nano \
    netcat \
    procps \
    sysfsutils \
    tcpdump \
    unzip \
    util-linux \
    wget \
    zip \
"

RPI_STUFF = " \
    omxplayer \
    raspi2fb \
    userland \
"

IMAGE_INSTALL += " \
    ${CORE_OS} \
    ${DEV_SDK_INSTALL} \
    ${DEV_EXTRAS} \
    ${EXTRA_TOOLS_INSTALL} \
    ${RPI_STUFF} \
    ${WIFI_SUPPORT} \
"

set_local_timezone() {
    ln -sf /usr/share/zoneinfo/EST5EDT ${IMAGE_ROOTFS}/etc/localtime
}

disable_bootlogd() {
    echo BOOTLOGD_ENABLE=no > ${IMAGE_ROOTFS}/etc/default/bootlogd
}

ROOTFS_POSTPROCESS_COMMAND += " \
    set_local_timezone ; \
    disable_bootlogd ; \
 "

export IMAGE_BASENAME = "monopi-image"

