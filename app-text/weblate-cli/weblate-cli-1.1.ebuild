# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Weblate commandline client using Weblate's REST API."
HOMEPAGE="https://weblate.org"
SRC_URI="https://github.com/WeblateOrg/wlc/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	dev-python/pytest-runner
	dev-python/pyxdg
	dev-python/requests"

DEPEND="
	${COMMON_DEPEND}
"
RDEPEND="
	${COMMON_DEPEND}
"
S="${WORKDIR}/wlc-${PV}"

#dev-python/twine             1.11.0   1.13.0  OK
#dev-python/requests-toolbelt 0.8.0    0.9.1   OK
#dev-python/pytest            4.3.0    4.3.0   OK
#dev-python/tqdm              4.23.3 >=4.14    OK
#dev-python/pkginfo          ~1.4.2  >=1.4.2   OK
#dev-python/pluggy            0.7.1  >=0.7     OK
#dev-python/more-itertools    4.2.0  >=4.0.0   OK
#dev-python/atomicwrites      1.2.1  >=1.0     OK
#dev-python/readme_renderer  ~17.2   >=21.0    NEW VERSION
#dev-python/coverage          4.2    >=4.4     NEW VERSION
#dev-python/pytest-cov       ~2.5.1-r2 2.6.1   NEW VERSION
#dev-python/httpretty         0.8.14   0.9.6   NEW VERSION
#multipart                    !!!      0.1     CREATE
#codacy-coverage              !!!      1.3.11  CREATE
#codecov                      !!!      2.0.15  CREATE

python_test() {
        local TMPDIR=".egg"
        esetup.py test
}

#src_configure() {
#	default
#	mv 
#}
