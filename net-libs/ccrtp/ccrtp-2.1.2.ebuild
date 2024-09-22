# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="GNU ccRTP - Implementation of the IETF real-time transport protocol"
HOMEPAGE="https://www.gnu.org/software/ccrtp/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/2"
KEYWORDS="amd64 x86"

IUSE="doc"

RDEPEND="
	dev-libs/libgcrypt:0=
	>=dev-libs/ucommon-6.2.2:=
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"
PATCHES=( "${FILESDIR}"/"${PN}-${PV}"-gcrypt-only.patch )
