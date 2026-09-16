# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev desktop xdg

DESCRIPTION="CUPS and SANE drivers for Katusha printers and MFP devices"
HOMEPAGE="https://katusha-it.ru"
SRC_URI="https://katusha-it.ru/storage/filemanager/downloads/Katusha%20Devices/Unidrv/Katusha-Universal-Driver_installer_v2.1-1-stable.tar -> ${P}.tar"

S="${WORKDIR}/${P}"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="~amd64"
IUSE="scanner"
# proprietary prebuilt binaries: strip nothing, do not mirror the distfile
RESTRICT="bindist mirror strip"
QA_PREBUILT="*"

COMMON_DEPEND="
	dev-libs/glib:2
	dev-libs/libusb
	net-print/cups
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
"
DEPEND="
	${COMMON_DEPEND}
"
RDEPEND="
	${COMMON_DEPEND}
	scanner? (
		dev-libs/libusb-compat
		media-gfx/sane-backends
	)
"
BDEPEND="
	app-arch/libarchive
"

# The upstream tarball has no top-level directory and contains ready-made
# DEB/RPM packages (ALT Linux flavour) plus per-model SANE backends.  All
# models are installed: the "universal" package is the driver core for the
# whole Katusha line, M130/M247/M348 are additional model packages.  The
# binary layout of the vendor (/opt/apps/Katusha) is kept as-is; there is
# no RPATH or hardcoded path inside the ELF files (only the .desktop files
# reference /opt), and the CUPS filters are installed into the Gentoo
# path /usr/libexec/cups/filter/Katusha.
src_unpack() {
	mkdir -p "${S}" || die
	tar -xf "${DISTDIR}/${A}" -C "${S}" || die

	# ALT Linux flavour only: drop the AstraLinux DEB packages
	rm -f "${S}"/packages/*.deb || die

	local pkg
	for pkg in universal m130-series m247-series m348-series; do
		mkdir -p "${WORKDIR}/rpm-${pkg}" || die
		bsdtar -xf "${S}"/packages/katusha-mfp-driver-${pkg}-amd64-*.x86_64.rpm \
			-C "${WORKDIR}/rpm-${pkg}" || die "Failed to unpack ${pkg} RPM"
	done
}

src_install() {
	# ---- printing part (always installed) ----

	# driver core and M130 package keep the vendor /opt/apps/Katusha layout
	dodir /opt/apps/Katusha
	cp -a "${WORKDIR}/rpm-universal/opt/apps/Katusha/mfp-driver-universal" \
		"${D}/opt/apps/Katusha/" || die
	cp -a "${WORKDIR}/rpm-m130-series/opt/apps/Katusha/mfp-driver-m130-series" \
		"${D}/opt/apps/Katusha/" || die

	# CUPS raster filters of all model packages (PPDs refer to Katusha/*)
	dodir /usr/libexec/cups/filter/Katusha
	cp -a "${WORKDIR}/rpm-universal/usr/lib/cups/filter/Katusha/." \
		"${D}/usr/libexec/cups/filter/Katusha/" || die
	cp -a "${WORKDIR}/rpm-m130-series/usr/lib/cups/filter/Katusha/." \
		"${D}/usr/libexec/cups/filter/Katusha/" || die
	cp -a "${WORKDIR}/rpm-m247-series/usr/lib/cups/filter/Katusha/." \
		"${D}/usr/libexec/cups/filter/Katusha/" || die
	cp -a "${WORKDIR}/rpm-m348-series/usr/lib/cups/filter/Katusha/." \
		"${D}/usr/libexec/cups/filter/Katusha/" || die
	fperms 0755 /usr/libexec/cups/filter/Katusha

	# PPD files
	insinto /usr/share/cups/model/Katusha
	doins "${WORKDIR}"/rpm-*/usr/share/cups/model/Katusha/*.ppd

	# desktop entries, icons and autostart of the Status Monitor
	domenu "${WORKDIR}/rpm-universal/usr/share/applications/BST.desktop"
	domenu "${WORKDIR}/rpm-universal/usr/share/applications/PSM.desktop"
	insinto /usr/share/icons/hicolor/scalable/apps
	doins "${WORKDIR}/rpm-universal"/usr/share/icons/hicolor/scalable/apps/*
	insinto /etc/xdg/autostart
	doins "${WORKDIR}/rpm-universal"/etc/xdg/autostart/PSM.desktop

	# ---- scanning part (USE=scanner) ----
	if use scanner; then
		dodir /usr/lib64/sane

		# universal and M130 backends live in /opt, register via symlinks
		dosym ../../../opt/apps/Katusha/mfp-driver-universal/sane/libsane-katusha_mfp_adv.so.1.0.22 \
			/usr/lib64/sane/libsane-katusha_mfp_adv.so
		dosym ../../../opt/apps/Katusha/mfp-driver-universal/sane/libsane-katusha_mfp_adv.so.1.0.22 \
			/usr/lib64/sane/libsane-katusha_mfp_adv.so.1
		dosym ../../../opt/apps/Katusha/mfp-driver-m130-series/sane/libsane-katusha_m130_series.so.1.0.22 \
			/usr/lib64/sane/libsane-katusha_m130_series.so
		dosym ../../../opt/apps/Katusha/mfp-driver-m130-series/sane/libsane-katusha_m130_series.so.1.0.22 \
			/usr/lib64/sane/libsane-katusha_m130_series.so.1

		# M247/M348 backends (ALT Linux flavour) go directly into the
		# SANE library directory
		cp -a "${S}/libs/m247/ALT/16.10.24__stable/libsane-katusham247.so.1.0.27" \
			"${D}/usr/lib64/sane/" || die
		dosym libsane-katusham247.so.1.0.27 /usr/lib64/sane/libsane-katusham247.so
		dosym libsane-katusham247.so.1.0.27 /usr/lib64/sane/libsane-katusham247.so.1
		cp -a "${S}/libs/m348/ALT/16.10.24__stable/libsane-katusham348.so.1.0.27" \
			"${D}/usr/lib64/sane/" || die
		dosym libsane-katusham348.so.1.0.27 /usr/lib64/sane/libsane-katusham348.so
		dosym libsane-katusham348.so.1.0.27 /usr/lib64/sane/libsane-katusham348.so.1

		# backend registration via /etc/sane.d/dll.d drop-ins
		printf 'katusha_mfp_adv\nkatusha_m130_series\n' > "${T}/katusha" || die
		insinto /etc/sane.d/dll.d
		doins "${T}/katusha"
		doins "${WORKDIR}/rpm-m247-series/etc/sane.d/dll.d/katusham247"
		doins "${WORKDIR}/rpm-m348-series/etc/sane.d/dll.d/katusham348"

		# backend configuration files
		insinto /etc/sane.d
		doins "${WORKDIR}/rpm-universal/etc/sane.d/DeviceList_katusha_mfp_adv.conf"
		doins "${WORKDIR}/rpm-m130-series/etc/sane.d/DeviceList_katusha_m130_series.conf"
		doins "${WORKDIR}/rpm-m247-series/etc/sane.d/katusham247.conf"
		doins "${WORKDIR}/rpm-m348-series/etc/sane.d/katusham348.conf"

		# udev rules grant scanner access (vendor id 3197, group lp)
		udev_dorules "${S}/optional/99-katusha-usb-driver.rules"
	fi

	dodoc Readme.txt KUDP.txt m130.txt m247.txt m348.txt
}

pkg_postinst() {
	udev_reload
	xdg_desktop_database_update

	if use scanner; then
		elog "SANE backends registered: katusha_mfp_adv, katusha_m130_series,"
		elog "katusham247, katusham348. Re-login or replug USB devices if"
		elog "needed so that the new udev rules take effect."
	fi
	elog "Add the printer in CUPS using the PPD files from the Katusha"
	elog "manufacturer list. For network printing use AppSocket/port 9101"
	elog "for P/M130 devices."
}

pkg_postrm() {
	udev_reload
	xdg_desktop_database_update
}
