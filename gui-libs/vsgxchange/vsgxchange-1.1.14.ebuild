# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library providing import of 3D models, images and textures for VulkanSceneGraph"
HOMEPAGE="https://github.com/vsg-dev/vsgXchange"

MY_PN="vsgXchange"
MY_P="${MY_PN}-${PV}"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vsg-dev/${MY_PN}.git"
else
	SRC_URI="https://github.com/vsg-dev/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="assimp curl freetype gdal ktx meshoptimizer openexr openscenegraph"
# no testsuite available (yet)
RESTRICT="test"

RDEPEND="
	gui-libs/vsg
	assimp? ( media-libs/assimp )
	curl? ( net-misc/curl )
	freetype? ( media-libs/freetype:= )
	gdal? ( sci-libs/gdal:= )
	ktx? ( media-libs/ktx )
	meshoptimizer? ( dev-libs/meshoptimizer )
	openexr? ( media-libs/openexr:= )
	openscenegraph? ( media-libs/osg2vsg )
"
DEPEND="
	${RDEPEND}
"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		-DvsgXchange_GDAL=$(usex gdal)
		-DvsgXchange_OSG=$(usex openscenegraph)
		-DvsgXchange_assimp=$(usex assimp)
		-DvsgXchange_curl=$(usex curl)
		-DvsgXchange_freetype=$(usex freetype)
		-DvsgXchange_ktx=$(usex ktx)
		-DvsgXchange_meshoptimizer=$(usex meshoptimizer)
		-DvsgXchange_openexr=$(usex openexr)
	)

	cmake_src_configure
}
