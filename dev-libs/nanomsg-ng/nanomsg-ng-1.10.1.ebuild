# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Rewrite of libnanomsg, with compability to original"
HOMEPAGE="https://github.com/nanomsg/nng"
SRC_URI="https://github.com/nanomsg/nng/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/nng-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"
