# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="QXGEdit is a software for editing MIDI files for XG devices (eg. Yamaha DB50XG)."

inherit cmake

HOMEPAGE="https://qxgedit.sourceforge.io/"
SRC_URI="https://github.com/rncbc/qxgedit/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+wayland"

DEPEND="
	dev-qt/qtbase[gui,network,widgets]
	dev-qt/qtsvg:6
	media-libs/alsa-lib:0=
"

RDEPEND="${DEPEND}"

src_configure() {
	CMAKE_BUILD_TYPE="RelWithDebInfo"
	local mycmakeargs=( -DCONFIG_QT6=ON )
	use wayland && mycmakeargs+=( -DCONFIG_WAYLAND=ON )
	cmake_src_configure
}
