SUMMARY = "The nanoweb browser based on Qt WebEngine"
HOMEPAGE = "https://www.unosquare.com"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS += "qtwebengine"

PR = "r1"

SRC_URI = "file://nanoweb.tar.gz"

S = "${WORKDIR}/nanoweb"

require recipes-qt/qt5/qt5.inc

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/${PN} ${D}${bindir}
}

FILES_${PN} = "${bindir}"

RDEPENDS_${PN} = "qtwebengine"
