# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake flag-o-matic

DESCRIPTION="C++ physics engine library in 3D"
HOMEPAGE="https://www.reactphysics3d.com/"
SRC_URI="https://github.com/DanielChappuis/reactphysics3d/releases/download/v${PV}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64"

IUSE="demo"

PATCHES=(
    "${FILESDIR}/${P}"-cstdint-fix.patch
    "${FILESDIR}/${P}"-gitmodules-fix.patch
    )

S="${WORKDIR}/${PN}"

src_configure() {
	append-cxxflags -std=c++11
	mycmakeargs+=(
		-DCLONE_GIT_SUBMODULES=OFF
		-DRP3D_COMPILE_TESTS=ON
		-DRP3D_COMPILE_TESTBED=$(usex demo ON OFF)
	)
	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}"/test || die
	./tests
}
