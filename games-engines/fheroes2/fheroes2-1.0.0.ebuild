# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Recreation of the Heroes of Might and Magic II game engine"
HOMEPAGE="https://ihhub.github.io/fheroes2/"
SRC_URI="https://github.com/ihhub/${PN}/archive/refs/tags/${PV}.tar.gz"

LICENSE="GPLv2"
SLOT="0"
KEYWORDS="~amd64"

inherit cmake

DEPEND="media-libs/libsdl2
media-libs/sdl2-mixer
sys-libs/zlib
media-libs/sdl2-image
media-libs/libpng
"

RDEPEND="${DEPEND}"
BDEPEND=""


#-- Found Threads: TRUE
