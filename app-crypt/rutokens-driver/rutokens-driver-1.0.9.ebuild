# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools udev

DESCRIPTION="USB IFD Handler for RutokenS smart card readers"
HOMEPAGE="https://github.com/AktivCo/rutokens-driver"
SRC_URI="https://github.com/AktivCo/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="udev"

RDEPEND="
	virtual/libusb:1
	sys-apps/pcsc-lite
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
#		$(use_enable udev udevrules)
		--disable-udevrules
		--enable-pcsclite
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	udev_dorules src/95-rutokens.rules
}

pkg_postrm() {
	udev_reload
}

pkg_postinst() {
	udev_reload
	elog "Please restart pcscd service to load the new driver."
}

