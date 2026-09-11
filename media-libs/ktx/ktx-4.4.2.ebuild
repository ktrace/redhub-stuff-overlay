# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Libraries and tools for working with Khronos KTX 1.0 and KTX 2.0 textures"
HOMEPAGE="https://github.com/KhronosGroup/KTX-Software"

MY_PN="KTX-Software"
MY_P="${MY_PN}-${PV}"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/KhronosGroup/${MY_PN}.git"
else
	SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="Apache-2.0"
SLOT="0"
# the unit test suite is not built (KTX_FEATURE_TESTS=OFF)
RESTRICT="test"

# All codecs (Basis Universal, ASTC, ETC, Zstd) are bundled under external/,
# Vulkan/OpenGL headers are self-contained, so no library dependencies.
BDEPEND="
	app-shells/bash
"

DOCS=( README.md RELEASE_NOTES.md )

src_configure() {
	local mycmakeargs=(
		-DKTX_FEATURE_DOC=OFF
		-DKTX_FEATURE_JNI=OFF
		-DKTX_FEATURE_PY=OFF
		-DKTX_FEATURE_TESTS=OFF
		-DKTX_FEATURE_TOOLS=ON
		-DKTX_FEATURE_LOADTEST_APPS=OFF
		-DKTX_FEATURE_ETC_UNPACK=ON
		-DKTX_FEATURE_VK_UPLOAD=ON
		-DKTX_FEATURE_GL_UPLOAD=ON
	)

	cmake_src_configure
}
