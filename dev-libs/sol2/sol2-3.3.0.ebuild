# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A C++ library binding to Lua"
HOMEPAGE="https://github.com/ThePhD/sol2"

SRC_URI="https://github.com/ThePhD/sol2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
# tests/examples are disabled by default, none are run
RESTRICT="test"

DEPEND="dev-lang/lua:5.4"
RDEPEND="${DEPEND}"

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}/${P}"-gcc13-optional-ref-emplace.patch
)

src_configure() {
	# sol2 is a header-only library; use the system Lua instead of the
	# bundled one (SOL2_BUILD_LUA is only needed for tests/examples).
	local mycmakeargs=(
		-DSOL2_BUILD_LUA=OFF
	)

	cmake_src_configure
}
