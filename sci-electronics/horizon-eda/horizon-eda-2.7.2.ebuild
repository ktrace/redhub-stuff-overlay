# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit meson python-any-r1 xdg

DESCRIPTION="Horizon EDA - an Electronic Design Automation package for PCB design"
HOMEPAGE="https://github.com/horizon-eda/horizon"
SRC_URI="https://github.com/horizon-eda/horizon/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/horizon-${PV}"

RESTRICT="test" # tests require a running display server

COMMON_DEP="
	app-arch/libarchive:=
	dev-cpp/giomm:2.4
	dev-cpp/glibmm:2.4
	dev-cpp/gtkmm:3.0
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libgit2:=
	dev-libs/libpcre2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/glm
	media-libs/libpng:0=
	media-libs/librsvg:2.0
	net-libs/cppzmq
	net-libs/zeromq
	net-misc/curl
	sci-libs/opencascade:=
	sys-apps/util-linux
	virtual/libiconv
	x11-libs/gtk+:3
	x11-libs/libepoxy
	x11-libs/pango
"

RDEPEND="${COMMON_DEP}
	gnome-base/dconf
	sci-electronics/electronics-menu
"

DEPEND="${COMMON_DEP}
	${PYTHON_DEPS}
	dev-util/glib-utils
"

BDEPEND="
	virtual/pkgconfig
"

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		python-any-r1_pkg_setup
	fi
}

src_configure() {
	local emesonargs=(
		-Dpython=disabled
		-Dpr-review=disabled
		-Dgen-pkg=disabled
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
