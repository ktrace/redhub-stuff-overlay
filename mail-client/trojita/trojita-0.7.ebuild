# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE=RelWithDebInfo
inherit cmake virtualx

DESCRIPTION="A Qt IMAP e-mail client"
HOMEPAGE="http://trojita.flaska.net/"
SRC_URI="https://github.com/KDE/trojita/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
IUSE="debug +password test +zlib"

RDEPEND="
		dev-qt/linguist-tools:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwebengine:5[widgets]
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtsvg:5
		dev-libs/qtkeychain
"
DEPEND="${RDEPEND}
	dev-util/ragel
	dev-libs/mimetic
	app-crypt/gpgme
	password?  ( dev-libs/qtkeychain:0 dev-qt/qtdbus:5 )
	test?  ( dev-qt/qttest:5 )
	zlib? (
		virtual/pkgconfig
		sys-libs/zlib
	)
"

DOCS="README LICENSE"

PATCHES=(
	"${FILESDIR}"/2.patch
	"${FILESDIR}"/ragel7.patch
	)

src_configure() {
	CMAKE_BUILD_TYPE=RelWithDebInfo
	local mycmakeargs=(
		-DQTKEYCHAIN_PLUGIN=$(usex password)
		-DWITH_TESTS=$(usex test)
		-DWITH_ZLIB=yes
		-DWITH_RAGEL=yes
		-DWITH_MIMETIC=yes
		-DWITH_GPGME=yes )
	cmake_src_configure
}

src_test() {
	VIRTUALX_COMMAND=cmake_src_test virtualmake
}
