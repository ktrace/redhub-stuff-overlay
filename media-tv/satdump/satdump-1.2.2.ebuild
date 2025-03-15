# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Generic satellite data processing software"
HOMEPAGE="https://www.satdump.org
	https://github.com/SatDump/SatDump"
SRC_URI="https://github.com/SatDump/SatDump/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/SatDump-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
		app-arch/zstd
		dev-libs/jemalloc
		dev-libs/nanomsg-ng
		media-libs/libpng
		sci-libs/fftw
		sci-libs/volk
		sys-libs/zlib"

RDEPEND="${DEPEND}"

src_configure() {
		local mycmakeargs=( -DBUILD_GUI=OFF )
		cmake_src_configure
}
