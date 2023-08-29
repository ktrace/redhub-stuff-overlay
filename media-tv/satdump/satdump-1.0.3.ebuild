# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Generic satellite data processing software"
HOMEPAGE="https://www.satdump.org
			https://github.com/SatDump/SatDump"
SRC_URI="https://github.com/SatDump/SatDump/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="app-arch/zstd
		media-libs/libpng
		sci-libs/fftw
		sci-libs/volk
		sys-libs/zlib"

RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( "${FILESDIR}/${P}-fix-gnudirs.patch" )

S="${WORKDIR}/SatDump-${PV}"

src_configure() {
		local mycmakeargs=( -DBUILD_GUI=OFF )
		cmake_src_configure
}
