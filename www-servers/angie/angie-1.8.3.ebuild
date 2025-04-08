# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing systemd

DESCRIPTION="Efficient, powerful and scalable reverse proxy and web server"
HOMEPAGE="https://angie.software/"
SRC_URI="https://download.angie.software/files/angie-${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+aio gd debug +mail +perl test +threads xml"

RESTRICT="!test? ( test )"

RDEPEND="
	acct-group/angie
	acct-user/angie
	dev-libs/libpcre2:=
	virtual/libcrypt:=
	gd?   ( media-libs/gd:2= )
	perl? ( dev-lang/perl )
	xml?  ( dev-libs/libxml2 dev-libs/libxslt )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

BDEPEND="
	test? (
		dev-lang/perl
		dev-perl/CryptX
		dev-perl/Test-Deep
		dev-perl/Test-Most
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-shorten-temp-path.patch
	"${FILESDIR}"/${PN}-fix-perl-install-path.patch
	"${FILESDIR}"/${PN}-fix-auto-install-paths.patch
)

src_prepare() {
	default
	# Дополнительные шаги подготовки, если необходимо
}

pkg_setup() {
	ANGIE_HOME="/var/lib/angie"
	ANGIE_HOME_TMP="${ANGIE_HOME}/tmp"
}

src_configure() {
	# Mandatory and enabled
	local myconf=(
		--with-http_acme_module
		--with-http_addition_module
		--with-http_auth_request_module
		--with-http_dav_module
		--with-http_degradation_module
		--with-http_flv_module
		--with-http_gunzip_module
		--with-http_gzip_static_module
		--with-http_mp4_module
		--with-http_random_index_module
		--with-http_realip_module
		--with-http_secure_link_module
		--with-http_slice_module
		--with-http_ssl_module
		--with-http_stub_status_module
		--with-http_sub_module
		--with-http_v2_module
		--with-http_v3_module
		--with-stream
		--with-stream_realip_module
		--with-stream_ssl_module
		--with-stream_ssl_preread_module
	)

	use aio     && myconf+=( --with-file-aio )
	use gd      && myconf+=( --with-http_image_filter_module  ) #libgd
	use mail    && myconf+=( --with-mail --with-mail_ssl_module )
	use perl    && myconf+=( --with-http_perl_module )
	use threads && myconf+=( --with-threads  )
	use xml     && myconf+=( --with-http_xslt_module  ) #libxml2 libxslt

	./configure \
		--conf-path="${EPREFIX}"/etc/${PN}/${PN}.conf \
		--error-log-path="${EPREFIX}"/var/log/${PN}/error.log \
		--group=angie \
		--http-client-body-temp-path="${EPREFIX}${ANGIE_HOME_TMP}"/client \
		--http-fastcgi-temp-path="${EPREFIX}${ANGIE_HOME_TMP}"/fastcgi \
		--http-log-path="${EPREFIX}"/var/log/${PN}/access.log \
		--http-proxy-temp-path="${EPREFIX}${ANGIE_HOME_TMP}"/proxy \
		--http-scgi-temp-path="${EPREFIX}${ANGIE_HOME_TMP}"/scgi \
		--http-uwsgi-temp-path="${EPREFIX}${ANGIE_HOME_TMP}"/uwsgi \
		--lock-path="${EPREFIX}"/run/lock/${PN}.lock \
		--modules-path=/usr/libexec/angie \
		--pid-path="${EPREFIX}"/run/${PN}/${PN}.pid \
		--prefix="${EPREFIX}"/usr \
		--sbin-path=/usr/sbin/angie \
		--user=angie \
		--with-cc-opt="-I${ESYSROOT}/usr/include" \
		--with-ld-opt="-L${ESYSROOT}/usr/$(get_libdir)" \
		"${myconf[@]}" || die "configure failed"

#		--with-compat \
# install runnable
# create acme_client dir
# create cache dirs
}

src_compile() {
	emake build
	use debug && emake DEBUG=1
}

src_install() {
	emake DESTDIR="${D}" install

	# Создание директорий
	keepdir /var/log/angie

	# Установка конфигурационных файлов
	dodir /etc/angie
	newinitd "${FILESDIR}"/angie.initd angie
	#newconfd conf/angie.conf angie.conf
	systemd_douserunit  "${FILESDIR}"/angie.service

	insinto /etc/angie/http.d
	for i in fastcgi.conf fastcgi_params mime.types scgi_params uwsgi_params; do
		doins conf/${i}
	done
#	insinto /etc/angie/stream.d
#	doins "${WORKDIR}"/files/example.conf.sample

	# Установка HTML файлов
#	keepdir /var/www/localhost
	insinto /var/www/localhost
	doins -r html/*

	# Установка man-страницы
	dodoc CHANGES* README LICENSE
	doman man/angie.8

	for i in ftdetect ftplugin indent syntax; do
		insinto /usr/share/vim/vimfiles/${i}/
		doins contrib/vim/${i}/angie.vim
	done

#	if use perl; then
#		cd "${S}"/objs/src/http/modules/perl/ || die
#		emake DESTDIR="${D}" INSTALLDIRS=vendor
#		#perl_delete_localpod
#		cd "${S}" || die
#	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/angie.logrotate angie
#	dosbin objs/angie
}

src_test() {
	cd tests

#	local -x TEST_ANGIE_BINARY="${S}/objs/angie"

	prove -v -j $(makeopts_jobs) . || die
#	popd > /dev/null || die
}

pkg_postinst() {
	elog "The configuration file is located at /etc/angie/angie.conf"
	elog "Please review it before starting the service."
}
