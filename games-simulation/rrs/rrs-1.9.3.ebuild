# Copyright 2026 Gentoo Authors
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

BDEPEND="
	>=dev-build/cmake-3.29
	dev-qt/qttools:6[linguist]
"

COMMON_DEPEND="
	dev-lang/lua:5.4
	dev-libs/sol2
	dev-qt/qtbase:6[gui,network,opengl,widgets,xml]
	dev-qt/qtserialbus:6
	dev-qt/qtwebengine:6[pdfium]
	dev-util/vulkan-headers
	gui-libs/vsg
	gui-libs/vsgimgui
	gui-libs/vsgxchange
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

PATCHES=(
	"${FILESDIR}"/rrs-1.9.3-modbus-qt6-client.patch
	"${FILESDIR}"/rrs-1.9.3-vsg116-build-fix.patch
	"${FILESDIR}"/rrs-1.9.3-ktx-4.4-api.patch
	"${FILESDIR}"/rrs-1.9.3-cmake-install.patch
)

src_prepare() {
	cmake_src_prepare

	# Upstream sets the legacy EXECUTABLE_OUTPUT_PATH / LIBRARY_OUTPUT_PATH
	# variables to *relative* paths that were written for in-source builds
	# (e.g. "../../bin", "../../../modules").  With an out-of-source build
	# those paths resolve against each subproject's binary directory and all
	# artifacts land one level above the build tree (e.g. <work>/bin instead
	# of <build>/bin).  Point them at absolute paths inside the build
	# directory so that the runtime tree (bin/, lib/, modules/, plugins/)
	# is produced where the distro expects it.
	sed -i \
		-e 's|^\([[:space:]]*set *(EXECUTABLE_OUTPUT_PATH "\)[^"]*bin\(")\)|\1${CMAKE_BINARY_DIR}/bin\2|' \
		-e 's|^\([[:space:]]*set *(LIBRARY_OUTPUT_PATH "\)[^"]*/lib\(")\)|\1${CMAKE_BINARY_DIR}/lib\2|' \
		-e 's|^\([[:space:]]*set *(LIBRARY_OUTPUT_PATH "\)[^"]*/modules/\([^"]*\)\(")\)|\1${CMAKE_BINARY_DIR}/modules/\2\3|' \
		-e 's|^\([[:space:]]*set *(LIBRARY_OUTPUT_PATH "\)[^"]*/modules\(")\)|\1${CMAKE_BINARY_DIR}/modules\2|' \
		-e 's|^\([[:space:]]*set *(LIBRARY_OUTPUT_PATH "\)[^"]*/plugins\(")\)|\1${CMAKE_BINARY_DIR}/plugins\2|' \
		$(find . -name CMakeLists.txt) || die "Failed to fix CMake output directories"
}

# The game is designed to run from its own directory tree: the binaries live
# in bin/ and expect the game data (cfg/, routes/, data/, fonts/, themes/,
# docs/), shared libraries (lib/) and modules (modules/) in the parent
# directory, resolved relative to the current working directory.  The RPATH
# of the binaries is $ORIGIN/../lib, so the whole tree is installed verbatim
# under /usr/share/rrs and a small wrapper changes into bin/ before starting
# the launcher.
src_install() {
	local rrsdir="/usr/share/rrs"

	# The CMake install rules added by rrs-1.9.3-cmake-install.patch
	# place the built runtime tree (bin/, lib/, modules/, plugins/) under
	# ${EPREFIX}/usr/share/rrs.  Game data, the launcher wrapper and the
	# desktop integration are installed below.
	cmake_src_install

	# The upstream SDK install rules (sdk/include, sdk/lib, sdk/lib/cmake)
	# target add-on developers; they are not part of the game package.
	rm -rf "${D}${EPREFIX}/usr/sdk" || die "Failed to remove upstream SDK files"

	dodir "${rrsdir}"
	cp -a cfg data docs fonts routes themes "${D}${rrsdir}/" || die "Failed to install game data"

	# Lua scripts (e.g. triggers_fabric.lua) shipped in the source tree
	dodir "${rrsdir}/modules"
	cp -a lua "${D}${rrsdir}/modules/" || die "Failed to install Lua modules"

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
