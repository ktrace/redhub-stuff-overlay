# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Weblate commandline client using Weblate's REST API."
HOMEPAGE="https://weblate.org"
SRC_URI="https://github.com/WeblateOrg/weblate/releases/download/${P}/Weblate-${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
	media-libs/freetype
	virtual/jpeg
	sys-libs/zlib
	dev-libs/libyaml
	x11-libs/cairo

	dev-python/pytest-runner
	dev-python/pyxdg
	dev-python/requests"

DEPEND="
	${COMMON_DEPEND}
"
RDEPEND="
	${COMMON_DEPEND}
"
S="${WORKDIR}/Weblate-${PV}"

#src_configure() {
#	default
#	mv 
#}

#src_test() {
#}
