# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="GNU ZRTP C++ library provide ZRTP support to the GNU ccRTP stack"
HOMEPAGE="https://www.gnu.org/software/ccrtp/zrtp.html"
SRC_URI="https://github.com/wernerd/${PN^^}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~ppc ~ppc64 x86"
LICENSE="GPL-2"
IUSE="doc"
SLOT="0"

RDEPEND="
	dev-libs/libgcrypt:0=
	>=dev-libs/ucommon-6.2.2:=
	net-libs/ccrtp
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${P}-bool-fix.patch" 
		  "${FILESDIR}/${P}-no-git-commit.patch" )

S="${WORKDIR}/${P^^}"

