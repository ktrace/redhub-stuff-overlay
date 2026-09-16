# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt integration with VulkanSceneGraph"
HOMEPAGE="https://github.com/vsg-dev/vsgQt"

MY_PN="vsgQt"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vsg-dev/${MY_PN}.git"
else
	SRC_URI="https://github.com/vsg-dev/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="examples"
# no testsuite available
RESTRICT="test"

RDEPEND="
	>=gui-libs/vsg-1.1.13
	dev-qt/qtbase:6[gui,widgets]
	examples? ( gui-libs/vsgxchange )
"
DEPEND="
	${RDEPEND}
"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		# Upstream defaults to Qt5; this overlay targets Qt6 only.
		-DQT_PACKAGE_NAME=Qt6
		-DVSGQT_BUILD_EXAMPLES=$(usex examples)
	)

	cmake_src_configure
}
