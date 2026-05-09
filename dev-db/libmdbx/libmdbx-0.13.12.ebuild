# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="An extremely fast, compact, powerful, embedded, transactional key-value database"
HOMEPAGE="https://sourcecraft.dev/dqdkfa/libmdbx
		https://libmdbx.dqdkfa.ru/"
SRC_URI="https://libmdbx.dqdkfa.ru/release/${PN}-amalgamated-${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test tools"

RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-cpp/gtest
		dev-libs/libevent
	)
"
BDEPEND="
	virtual/pkgconfig
"

#S="${WORKDIR}"

src_configure() {
	local mycmakeargs=(
		-DMDBX_BUILD_TOOLS=$(usex tools ON OFF)
		-DMDBX_BUILD_TESTS=$(usex test ON OFF)
		-DMDBX_INSTALL_MANPAGES=ON
	)
	cmake_src_configure
}

src_unpack() {
		unpack ${A}
		local flist=$(ls "${WORKDIR}")
		mkdir -p "${S}" || die
		for i in $flist; do
			mv -t "${S}" $i
		done
}

src_install() {
	cmake_src_install
	dodoc README.md ChangeLog.md SECURITY.md
}

pkg_postinst() {
	elog "libmdbx is a drop-in replacement for LMDB with enhanced features."
	elog "See https://libmdbx.dqdkfa.ru/ for documentation."
}
