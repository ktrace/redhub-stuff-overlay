# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9,10} )

inherit distutils-r1

DESCRIPTION="Weblate commandline client using Weblate's REST API."
HOMEPAGE="https://weblate.org"
SRC_URI="https://github.com/WeblateOrg/wlc/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	dev-python/argcomplete
	dev-python/python-dateutil
	dev-python/pyxdg
	dev-python/requests"

DEPEND="
	${COMMON_DEPEND}
"
RDEPEND="
	${COMMON_DEPEND}
"
S="${WORKDIR}/wlc-${PV}"
