# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
inherit cmake xdg

DESCRIPTION="PokerTH - Texas Hold'em poker game with network play"
HOMEPAGE="https://www.pokerth.net/"
SRC_URI="https://github.com/pokerth/pokerth/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${P}"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+client dedicated-server"

REQUIRED_USE="|| ( client dedicated-server )"

BDEPEND="
	dev-libs/protobuf
	dev-qt/qttools:6[linguist]
"

COMMON_DEPEND="
<<<<<<< HEAD
	>=dev-libs/boost-1.83:=[iostreams,thread,random,filesystem,program_options]
	dev-libs/openssl:=
	>=dev-libs/protobuf-2.3.0:=
	dev-cpp/abseil-cpp:=
	dev-cpp/utf8-range:=
	dev-qt/qtbase:6[gui,sql,widgets,xml,network]
=======
	>=dev-libs/boost-1.83:=
	>=dev-libs/protobuf-2.3.0:=
	dev-cpp/abseil-cpp:=
	dev-libs/openssl:=
	dev-qt/qtbase:6[gui,network,sql,widgets,xml]
>>>>>>> rail-simul
	dev-qt/qtmultimedia:6
	dev-qt/qtsvg:6
	dev-qt/qtwebsockets:6
"

DEPEND="
	${COMMON_DEPEND}
"

RDEPEND="
	${COMMON_DEPEND}
"

PATCHES=(
	"${FILESDIR}/${P}-fix-desktop-exec.patch"
	"${FILESDIR}/${P}-fix-protobuf-find-module.patch"
	"${FILESDIR}/${P}-fix-abseil-link-linux.patch"
	"${FILESDIR}/${P}-fix-install-libs.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
	)
	cmake_src_configure
}

src_compile() {
	if use client; then
		cmake_build pokerth_client pokerth_db
	fi

	if use dedicated-server; then
		cmake_build pokerth_dedicated_server pokerth_db
	fi
}
