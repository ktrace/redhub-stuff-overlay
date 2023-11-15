# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="QXGEdit is a software for editing MIDI files for XG devices (eg. Yamaha DB50XG)."

inherit cmake

MY_PV="${PV//./_}"
HOMEPAGE="https://qxgedit.sourceforge.io/"
SRC_URI="https://github.com/rncbc/qxgedit/archive/refs/tags/${PN}_${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+wayland"

S="${WORKDIR}/${PN}-${PN}_${MY_PV}"
DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib:0=
"
RDEPEND="${DEPEND}"

src_configure() {
	CMAKE_BUILD_TYPE="RelWithDebInfo"
	local mycmakeargs=( -DCONFIG_QT6=OFF )
	use wayland && mycmakeargs+=( -DCONFIG_WAYLAND=ON )
	cmake_src_configure
}
