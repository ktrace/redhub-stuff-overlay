# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit  cmake xdg

DESCRIPTION="Softphone for VoIP communcations using SIP protocol"
HOMEPAGE="http://twinkle.dolezel.info/"
SRC_URI="https://sourcecraft.dev/api/archive/ktrace/twinkle?rev=tag%3Av${PV}&format=tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/ktrace-twinkle-b73a191"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa g729 gsm speex zrtp"

DEPEND="dev-libs/libxml2:2
	dev-libs/ucommon
	dev-qt/qt5compat:6[qml]
	dev-qt/qtbase:6[dbus,gui,widgets]
	dev-qt/qtsvg:6
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
BDEPEND="dev-qt/qttools:6[linguist]
	sys-devel/bison
	sys-devel/flex"

#PATCHES=( "${FILESDIR}/${PN}"-1.10.3-g729.patch )

src_configure() {

	local mycmakeargs=(
		-DWITH_ALSA=$(usex alsa)
		-DWITH_G729=$(usex g729)
		-DWITH_GSM=$(usex gsm)
		-DWITH_ILBC=no
		-DWITH_QT6=yes
		-DWITH_SPEEX=$(usex speex)
		-DWITH_ZRTP=$(usex zrtp)
	)
	cmake_src_configure
}
