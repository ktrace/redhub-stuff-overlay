# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit  cmake-utils

DESCRIPTION="Softphone for VoIP communcations using SIP protocol"
HOMEPAGE="http://twinkle.dolezel.info/"
SRC_URI="https://github.com/LubosD/twinkle/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa diamondcard g729 speex +qt5"

DEPEND="dev-cpp/commoncpp2
	dev-libs/boost
	dev-libs/ucommon
	media-libs/fontconfig
	media-libs/libsndfile
	net-libs/ccrtp
	alsa? ( media-libs/alsa-lib )
	g729? ( media-libs/bcg729 )
	speex? ( media-libs/speex )"

#	zrtp? ( net-libs/libzrtpcpp )
#	ilbc? ( dev-libs/ilbc-rfc3951 )

RDEPEND="${DEPEND}"
BDEPEND=""

#PATCHES=( "${FILESDIR}"/${P}-regexp-validator.patch )

src_configure() {

	local mycmakeargs=(
		-DWITH_ALSA=$(usex alsa)
		-DWITH_DIAMONDCARD=$(usex diamondcard)
		-DWITH_G729=$(usex g729)
		-DWITH_ILBC=$(usex ilbc)
		-DWITH_QT5=$(usex qt5)
		-DWITH_SPEEX=$(usex speex)
	)
	cmake-utils_src_configure
}
