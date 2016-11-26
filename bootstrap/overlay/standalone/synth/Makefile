# $NetBSD$

PKGNAME=	synth-${SYNVERSION}
CATEGORIES=	pkgtools
MASTER_SITES=	https://codeload.github.com/jrmarino/synth/tar.gz/${TAGNAME}?dummy=/
DISTFILES=	synth-${TAGNAME}.tar.gz

MAINTAINER=	draco@marino.st
HOMEPAGE=	https://github.com/jrmarino/synth
COMMENT=	Custom package repository builder for pkgsrc

SYNVERSION=	1.66
TAGNAME=	f21aa59
LICENSE=	isc

DEPENDS+=	ncurses>=6:../../devel/ncurses
DEPENDS+=	ini_file_manager>=03:../../misc/ini_file_manager
DEPENDS+=	adacurses>=20150808:../../devel/adacurses

USE_LANGUAGES=	c ada
WRKSRC=		${WRKDIR}/synth-${TAGNAME}
GPR=		${LOCALBASE}/lib/gnat
MAKE_ENV=	NCURSES_LINK=static \
		ADA_PROJECT_PATH=${LOCALBASE}/lib/gnat

ONLY_FOR_PLATFORM=	FreeBSD-*-* DragonFly-*-* NetBSD-*-* \
			Linux-*-* SunOS-*-*

SUBST_CLASSES=		defs lbase tamper

SUBST_STAGE.defs=	post-patch
SUBST_FILES.defs=	src/definitions.ads
SUBST_SED.defs=		-e "s|/usr/local|${LOCALBASE}|" \
			-e "s|:= ports_collection|:= pkgsrc|" \
			-e "s|/usr/bin/make|${HOST_MAKE}|"
SUBST_MESSAGE.defs=	Tailor definitions for this build

SUBST_STAGE.lbase=	post-patch
SUBST_FILES.lbase=	src/replicant.ads
SUBST_SED.lbase=	-e "s|/usr/local|/usr/pkg|"
SUBST_MESSAGE.lbase=	Establish pkgsrc localbase

SUBST_STAGE.tamper=	post-patch
SUBST_FILES.tamper=	src/portscan.ads
SUBST_SED.tamper=	-e "s|pragma|--  pragma|"
SUBST_MESSAGE.tamper=	Disable Tampering_Check suppression pragma (requires gcc6-aux)

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
		${DESTDIR}/var/log/synth \
		${DESTDIR}/var/synth/live_packages
	${INSTALL_PROGRAM} ${WRKSRC}/build/synth \
		${DESTDIR}${PREFIX}/bin
	${INSTALL_PROGRAM} ${WRKSRC}/build/synthexec \
		${DESTDIR}${PREFIX}/libexec
	${INSTALL_MAN} ${WRKSRC}/synth.1 ${DESTDIR}${MANPREFIX}/man/man1
	${INSTALL_SCRIPT} ${WRKSRC}/shell-completers/_synth.bash \
		${DESTDIR}${PREFIX}/etc/bash_completion.d
	${INSTALL_DATA} ${WRKSRC}/shell-completers/_synth \
		${DESTDIR}${PREFIX}/share/zsh/site-functions
	${INSTALL_DATA} ${WRKSRC}/www/* ${DESTDIR}${PREFIX}/share/synth

.include "../../devel/gprbuild-aux/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
