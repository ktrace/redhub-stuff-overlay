# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"

inherit cmake desktop xdg

DESCRIPTION="Russian Railway Simulator - free, open-source railway simulator"
HOMEPAGE="https://github.com/maisvendoo/RRS
	https://rusrailsim.ru"
SRC_URI="https://github.com/maisvendoo/RRS/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/RRS-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

# Qt6Pdf (CMake module Qt6::Pdf) is provided by dev-qt/qtwebengine[pdfium],
# which builds the QtPdf module (qtpdf_build) on top of chromium's PDFium.
# Verified 2026-09-11, see docs/QTPDF.md for the full evidence.

BDEPEND="
	>=dev-build/cmake-3.29
	dev-qt/qttools:6[linguist]
"

COMMON_DEPEND="
	gui-libs/vsg
	gui-libs/vsgimgui
	gui-libs/vsgxchange
	dev-lang/lua:5.4
	dev-libs/sol2
	dev-qt/qtbase:6[gui,network,opengl,widgets,xml]
	dev-qt/qtwebengine:6[pdfium]
	dev-qt/qtserialbus:6
	dev-util/vulkan-headers
	media-libs/ktx
	media-libs/libsfml
	media-libs/openal
"

DEPEND="
	${COMMON_DEPEND}
"

RDEPEND="
	${COMMON_DEPEND}
	media-libs/vulkan-loader
"

DOCS=( CHANGELOG README.md )

# The game is designed to run from its own directory tree: the binaries live
# in bin/ and expect the game data (cfg/, routes/, data/, fonts/, themes/,
# docs/), shared libraries (lib/) and modules (modules/) in the parent
# directory, resolved relative to the current working directory.  The RPATH
# of the binaries is $ORIGIN/../lib, so the whole tree is installed verbatim
# under /usr/share/rrs and a small wrapper changes into bin/ before starting
# the launcher.
src_install() {
	local rrsdir="/usr/share/rrs"

	dodir "${rrsdir}"
	cp -a cfg data docs fonts routes themes "${D}${rrsdir}/" || die "Failed to install game data"

	# Executables: launcher, simulator, viewer, route-editor, tools
	exeinto "${rrsdir}/bin"
	doexe "${BUILD_DIR}"/bin/*

	# Shared libraries (built without the usual "lib" prefix)
	insinto "${rrsdir}/lib"
	doins "${BUILD_DIR}"/lib/*.so

	# Vehicle/equipment modules and Lua scripts (triggers_fabric.lua)
	dodir "${rrsdir}/modules"
	cp -a lua "${D}${rrsdir}/modules/" || die "Failed to install Lua modules"
	if [[ -d "${BUILD_DIR}/modules" ]]; then
		insinto "${rrsdir}/modules"
		doins -r "${BUILD_DIR}"/modules/*
	fi

	# Runtime plugins (e.g. freejoy)
	if [[ -d "${BUILD_DIR}/plugins" ]]; then
		insinto "${rrsdir}/plugins"
		doins "${BUILD_DIR}"/plugins/*.so
	fi

	# Directories written at runtime (logs, screenshots, scenarios)
	dodir "${rrsdir}/logs" "${rrsdir}/screenshots"
	fperms 0777 "${rrsdir}/logs" "${rrsdir}/screenshots"
	fperms -R a+rwX "${rrsdir}/routes"

	# Launcher wrapper: the game must run with bin/ as the working directory
	cat > "${T}/rrs" <<-EOF
		#!/bin/sh
		cd "${EPREFIX}${rrsdir}/bin" || exit 1
		exec ./launcher "\$@"
	EOF
	dobin "${T}/rrs"

	# Desktop integration
	newicon "${S}/launcher/resources/images/RRS_logo.png" rrs.png
	domenu "${FILESDIR}/rrs.desktop"

	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
