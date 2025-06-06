# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev

MY_PV=${PV//./_}

DESCRIPTION="CUPS and SANE drivers for Pantum series printer and scanner."
HOMEPAGE="https://www.pantum.ru/service-and-support/driver/"
SRC_URI="https://www.pantum.ru/wp-content/uploads/2024/07/pantum-ubuntu-driver-v${MY_PV}-4.zip -> ${P}.zip"

S="${WORKDIR}/Pantum Ubuntu Driver V${PV}"

LICENSE="Pantum-EULA"
SLOT="0"
KEYWORDS="amd64"
IUSE="scanner"
RESTRICT="bindist mirror strip"

DEPEND="
	media-libs/libjpeg8
	net-print/cups
	net-print/cups-filters
	sys-apps/dbus
	sys-libs/glibc
	sys-libs/libcap
	scanner? (
		media-gfx/sane-backends
	)
"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
"
RDEPEND="
	${DEPEND}
	app-text/ghostscript-gpl
"

src_prepare() {
	eapply_user
	unpack "${S}/Resources/pantum_${PV}-1_amd64.deb" || die
	tar -xvf "${S}/data.tar.xz" || die
}

src_install() {
	insinto /etc/sane.d
	doins -r etc/sane.d/*
	insinto "/usr/$(get_libdir)/sane"
	doins usr/lib/x86_64-linux-gnu/sane/libsane-pantum*.so*
	udev_dorules etc/udev/rules.d/*.rules

	exeinto /opt/pantum/bin
	doexe opt/pantum/bin/ptqpdf
	exeinto /usr/libexec/cups/filter
	doexe usr/lib/cups/filter/*
	insinto /usr/share/cups/model
	doins -r usr/share/cups/model/Pantum
}

pkg_postrm() {
	udev_reload
}

pkg_postinst() {
	udev_reload
}
