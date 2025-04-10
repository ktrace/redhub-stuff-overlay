# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

DESCRIPTION="Graphical wireless scanning for Linux"
HOMEPAGE="https://sourceforge.net/projects/linssid/"
SRC_URI="https://downloads.sourceforge.net/project/linssid/LinSSID_3.6/${PN}_${PV}.orig.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${P}/${PN}-app"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/boost:=
	dev-qt/qtbase:6[gui,opengl,widgets]
	dev-qt/qtsvg:6
	x11-libs/qwt:6[opengl,qt6(+),svg]
"

RDEPEND="
	${DEPEND}
	net-wireless/iw
	sys-auth/polkit
	x11-libs/libxkbcommon[X]
"

DOCS=( README_${PV} )
PATCHES=( "${FILESDIR}/${P}"-qt6-deprecated-fix.patch )

src_configure() {
	eqmake6
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
