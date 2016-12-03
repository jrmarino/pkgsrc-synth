# $NetBSD$

PKGNAME=	synth-${SYNVERSION}
CATEGORIES=	pkgtools
MASTER_SITES=	https://codeload.github.com/jrmarino/synth/tar.gz/${TAGNAME}?dummy=/
DISTFILES=	synth-${TAGNAME}.tar.gz

MAINTAINER=	draco@marino.st
HOMEPAGE=	https://github.com/jrmarino/synth
COMMENT=	Custom package repository builder for pkgsrc

SYNVERSION=	1.66
TAGNAME=	c8a361a
LICENSE=	isc

BUILD_DEPENDS=	ncurses>=6:../../devel/ncurses
BUILD_DEPENDS+=	ini_file_manager>=03:../../misc/ini_file_manager
BUILD_DEPENDS+=	adacurses>=20150808:../../devel/adacurses
DEPENDS=	bmake>=20150505:../../devel/bmake
DEPENDS+=	digest>=20160304:../../pkgtools/digest

USE_LANGUAGES=	c ada
WRKSRC=		${WRKDIR}/synth-${TAGNAME}
GPR=		${LOCALBASE}/lib/gnat
MAKE_ENV=	NCURSES_LINK=static \
		ADA_PROJECT_PATH=${LOCALBASE}/lib/gnat

USE_LANGUAGES+=		c++ fortran # not used but avoids bogus warnings
ONLY_FOR_PLATFORM=	FreeBSD-*-* DragonFly-*-* NetBSD-*-*
# TO-DO			Linux-*-* SunOS-*-*

SUBST_CLASSES=		defs lbase tamper pkgng web pdir

SUBST_STAGE.defs=	post-patch
SUBST_FILES.defs=	src/definitions.ads
SUBST_SED.defs=		-e "s|/usr/local|${LOCALBASE}|" \
			-e "s|:= ports_collection|:= pkgsrc|" \
			-e "/host_make/ s|/usr/bin/make|${HOST_MAKE}|" \
			-e "/chroot_make_prog/ s|:= chroot_make|:= chroot_bmake|"
SUBST_MESSAGE.defs=	Tailor definitions for this build

SUBST_STAGE.lbase=	post-patch
SUBST_FILES.lbase=	src/replicant.ads
SUBST_SED.lbase=	-e "s|/usr/local|/usr/pkg|"
SUBST_MESSAGE.lbase=	Establish pkgsrc localbase

SUBST_STAGE.tamper=	post-patch
SUBST_FILES.tamper=	src/portscan.ads
SUBST_SED.tamper=	-e "s|pragma|--  pragma|"
SUBST_MESSAGE.tamper=	Disable Tampering_Check suppression pragma (requires gcc6-aux)

SUBST_STAGE.pkgng=	post-patch
SUBST_FILES.pkgng=	src/portscan-pilot.ads
SUBST_SED.pkgng=	-e "s|ports-mgmt/pkg|pkgtools/pkg|"
SUBST_MESSAGE.pkgng=	Reset location for pkg(8) port

SUBST_STAGE.web=	post-patch
SUBST_FILES.web=	www/progress.js
SUBST_SED.web=		-e "s|return FPClink|return NPSlink|"
SUBST_MESSAGE.web=	Change web interface links from portsmon to pkgsrc.se

SUBST_STAGE.pdir=	post-patch
SUBST_FILES.pdir=	synth.1
SUBST_SED.pdir=		-e "s|PORTSDIR|PKGSRCDIR|g"
SUBST_MESSAGE.pdir=	Replace PORTSDIR with PKGSRCDIR on synth man page

SUBST_STAGE.popen=	post-patch
SUBST_FILES.popen=	src/unix.adb
SUBST_SED.popen=	-e 's|"re"|"r"|'
SUBST_MESSAGE.popen=	Disable close-on-exec on popen command

.include "../../mk/bsd.prefs.mk"

.if ${OPSYS:MNetBSD} || ${OPSYS:MSunOS} 
SUBST_CLASSES+=	popen
.endif

.if ${OPSYS:MNetBSD}
HOST_MAKE=	/usr/bin/make
.else
HOST_MAKE=	${LOCALBASE}/bin/bmake
.endif

do-build:
	(cd ${WRKSRC}/src && ${SETENV} ${MAKE_ENV} \
		gcc -c unix_core.c -o ../build/unix_core.o)
	(cd ${WRKSRC}/synthexec && ${SETENV} ${MAKE_ENV} \
		gcc synthexec.c -o ../build/synthexec)
	(cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} gprbuild -P default \
		-largs build/unix_core.o)

do-install:
	${MKDIR} ${DESTDIR}${PREFIX}/etc/bash_completion.d \
		${DESTDIR}${PREFIX}/share/zsh/site-functions \
		${DESTDIR}${PREFIX}/share/synth \
		${DESTDIR}${PREFIX}/man/man1 \
		${DESTDIR}${PREFIX}/libexec \
		${DESTDIR}${PREFIX}/bin \
		${DESTDIR}/var/log/synth \
		${DESTDIR}/var/synth/live_packages
	${INSTALL_PROGRAM} ${WRKSRC}/build/synth \
		${DESTDIR}${PREFIX}/bin
	${INSTALL_PROGRAM} ${WRKSRC}/build/synthexec \
		${DESTDIR}${PREFIX}/libexec
	${INSTALL_MAN} ${WRKSRC}/synth.1 ${DESTDIR}${PREFIX}/man/man1
	${INSTALL_SCRIPT} ${WRKSRC}/shell-completers/_synth.bash \
		${DESTDIR}${PREFIX}/etc/bash_completion.d
	${INSTALL_DATA} ${WRKSRC}/shell-completers/_synth \
		${DESTDIR}${PREFIX}/share/zsh/site-functions
	${INSTALL_DATA} ${WRKSRC}/www/* ${DESTDIR}${PREFIX}/share/synth

.include "../../devel/gprbuild-aux/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
