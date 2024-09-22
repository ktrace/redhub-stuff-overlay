# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools # multilib

COMMIT="175f8ff4464591feb67728c7752ac752c7b48d43"

DESCRIPTION="Canon CAPT-based printers (LBP-20xx/30xx)"
HOMEPAGE="https://github.com/agalakhov/captdriver/"
SRC_URI="https://github.com/agalakhov/captdriver/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/captdriver-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=net-print/cups-1.1.17
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	einstalldocs

	insinto /usr/share/cups/model
	doins *.ppd

	insinto /usr/share/cups/drv
	doins src/canon-lbp.drv

	exeinto $(cups-config --serverbin)/filter
	doexe src/rastertocapt
}
