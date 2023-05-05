# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit  cmake xdg

DESCRIPTION="Softphone for VoIP communcations using SIP protocol"
HOMEPAGE="http://twinkle.dolezel.info/"
SRC_URI="https://github.com/LubosD/twinkle/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa g729 gsm speex zrtp"

DEPEND="dev-libs/libxml2:2
	dev-libs/ucommon
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtwidgets:5
	media-libs/fontconfig
	media-libs/libsndfile
	media-libs/libsndfile
	net-libs/ccrtp
	sys-libs/readline:=
	sys-apps/file:=
	alsa? ( media-libs/alsa-lib )
	g729? ( media-libs/bcg729 )
	gsm? ( media-sound/gsm )
	speex? ( media-libs/speex media-libs/speexdsp )
	zrtp? ( net-libs/zrtpcpp )"

RDEPEND="${DEPEND}"
BDEPEND="dev-qt/linguist-tools:5
	sys-devel/bison
	sys-devel/flex"

PATCHES=( "${FILESDIR}/${P}"-g729.patch )

src_configure() {

	local mycmakeargs=(
		-DWITH_ALSA=$(usex alsa)
		-DWITH_G729=$(usex g729)
		-DWITH_GSM=$(usex gsm)
		-DWITH_ILBC=no
		-DWITH_QT5=yes
		-DWITH_SPEEX=$(usex speex)
		-DWITH_ZRTP=$(usex zrtp)
	)
	cmake_src_configure
}
