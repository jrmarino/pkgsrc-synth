# $NetBSD: Makefile,v 1.218 2016/06/21 12:23:01 joerg Exp $

PKGNAME=		pkgng_admin-1.00
CATEGORIES=		pkgtools

MAINTAINER=		draco@marino.st
HOMEPAGE=		https://github.com/jrmarino/pkgsrc-synth
COMMENT=		Package administration tool for pkgsrc
LICENSE=		modified-bsd

BOOTSTRAP_PKG=		yes
SKIP_LICENSE_CHECK=	yes
CFLAGS+=		-DSYSCONFDIR=\"${PKG_SYSCONFDIR}\"

CHECK_PERMS=		no
USE_NATIVE_GCC=		yes

FILESDIR.pkg_install=	${PKGDIR:H}/pkg_install/files

do-extract:
	${CP} -R ${FILESDIR} ${WRKSRC}
	${CP} ${FILESDIR.pkg_install}/lib/dewey.[ch] \
		${FILESDIR.pkg_install}/lib/license.c \
		${FILESDIR.pkg_install}/lib/opattern.c ${WRKSRC}/
	${SED} -e "s|@SYSCONFDIR@|${PKG_SYSCONFDIR}|" \
		${WRKSRC}/pkgng_admin.conf.5.in > \
		${WRKSRC}/pkgng_admin.conf.5

.include "../../mk/bsd.pkg.mk"
