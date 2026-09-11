# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Integration of VulkanSceneGraph with ImGui"
HOMEPAGE="https://github.com/vsg-dev/vsgImGui"

MY_PN="vsgImGui"

# Pinned submodule commits at tag v${PV}
IMGUI_COMMIT="01380c579715e62fb9a8d6ec0502c4ea83bfde6e"
IMPLOT_COMMIT="524f9fcd48d76c13fdf94c5ffbba8787a1ff7e39"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vsg-dev/${MY_PN}.git"
else
	SRC_URI="
		https://github.com/vsg-dev/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://codeload.github.com/ocornut/imgui/tar.gz/${IMGUI_COMMIT} -> imgui-${IMGUI_COMMIT}.tar.gz
		https://codeload.github.com/epezent/implot/tar.gz/${IMPLOT_COMMIT} -> implot-${IMPLOT_COMMIT}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

LICENSE="MIT"
SLOT="0"
# no testsuite available
RESTRICT="test"

RDEPEND=">=gui-libs/vsg-1.1.13"
DEPEND="${RDEPEND}"

DOCS=( README.md )

# The release tarball does not contain the imgui/implot git submodules,
# so they are fetched separately and placed into src/ before configuring.
src_unpack() {
	default

	if [[ -d "${WORKDIR}/imgui-${IMGUI_COMMIT}" ]]; then
		mv "${WORKDIR}/imgui-${IMGUI_COMMIT}" "${S}/src/imgui" || die "Failed to unpack imgui"
		mv "${WORKDIR}/implot-${IMPLOT_COMMIT}" "${S}/src/implot" || die "Failed to unpack implot"
	fi
}
