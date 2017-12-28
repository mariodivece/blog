SUMMARY = "The MonoPi Image version 2.0"
HOMEPAGE = "https://github.com/mariodivece/blog/blob/master/2017-12-23-rpi-yocto-rocko/"
LICENSE = "MIT"

IMAGE_FEATURES += "package-management splash"
IMAGE_LINGUAS = "en-us"

inherit core-image

DEPENDS += "bcm2835-bootfiles"

CORE_OS = " \
    openssh openssh-keygen openssh-sftp-server \
    term-prompt \
    tzdata \
    coreutils \
"

WIFI_SUPPORT = " \
    crda \
    iw \
    linux-firmware-bcm43430 \
    wireless-tools \
    wpa-supplicant \
"

ALSA += " \
    libasound \
    libavcodec \
    libavdevice \
    libavfilter \
    libavformat \
    libavutil \
    libpostproc \
    libswresample \
    libswscale \
    alsa-conf \
    alsa-utils \
    alsa-utils-scripts \
"

DEV_SDK = " \
    git \
    mono \
    ntp \
    ntp-tickadj \
    serialecho  \
    spiloop \
"

SUPPORT_TOOLS = " \
    bzip2 \
    devmem2 \
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

RPI_APPS = " \
    raspi2fb \
    userland \
"

QT_TOOLS = " \
    qtbase \
    qt5-env \
"

FONTS = " \
    fontconfig \
    fontconfig-utils \
    ttf-bitstream-vera \
"

TSLIB = " \
    tslib \
    tslib-conf \
    tslib-calibrate \
"

QT5_PKGS = " \
    qtdeclarative \
    qtdeclarative-plugins \
    qtdeclarative-qmlplugins \
    qtquickcontrols2 \
    qtvirtualkeyboard \
    qtwebengine \
"

QT5_APPS = " \
    qqtest \
    qcolorcheck \
    tspress \
    nanoweb \
"

IMAGE_INSTALL += " \
    ${CORE_OS} \
    ${WIFI_SUPPORT} \
    ${ALSA} \
    ${DEV_SDK} \
    ${SUPPORT_TOOLS} \
    ${RPI_APPS} \
    ${FONTS} \
    ${QT_TOOLS} \
    ${TSLIB} \
    ${QT5_PKGS} \
    ${QT5_APPS} \
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
