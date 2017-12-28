SUMMARY = "The MonoPi Image with Qt 5!"
HOMEPAGE = "https://github.com/mariodivece/blog/blob/master/2017-12-23-rpi-yocto-rocko/"
LICENSE = "MIT"

require console-image.bb

QT_TOOLS = " \
    qtbase \
    qt5-env \
    qtserialport \
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
    tslib-tests \
"

QT5_PKGS = " \
    qt3d \
    qtcharts \
    qtdeclarative \
    qtdeclarative-plugins \
    qtdeclarative-qmlplugins \
    qtgraphicaleffects \
    qtlocation-plugins \
    qtmultimedia \
    qtquickcontrols2 \
    qtsensors-plugins \
    qtserialbus \
    qtsvg \
    qtwebsockets-qmlplugins \
    qtvirtualkeyboard \
    qtxmlpatterns \
    qtwebkit \
    qtwebengine \
    qttools \
"

QML_APPS = " \
    qqtest \
"

IMAGE_INSTALL += " \
    ${FONTS} \
    ${QT_TOOLS} \
    qcolorcheck \
    ${TSLIB} \
    tspress \
    ${QT5_PKGS} \
    ${QML_APPS} \
    mono \
    nanoweb \
"

export IMAGE_BASENAME = "monopi-image"