# $NetBSD: Makefile,v 1.218 2016/06/21 12:23:01 joerg Exp $

PKGNAME=		pkgng_admin-1.00
CATEGORIES=		pkgtools

MAINTAINER=		draco@marino.st
HOMEPAGE=		https://github.com/jrmarino/pkgsrc-synth
COMMENT=		Package administration tool for pkgsrc
LICENSE=		modified-bsd

BOOTSTRAP_PKG=		yes
SKIP_LICENSE_CHECK=	yes
USE_CWRAPPERS=		no
CFLAGS+=		-DSYSCONFDIR=\"${PKG_SYSCONFDIR}\"
ALLOW_VULNERABLE_PACKAGES=	# circular dependency, requires pkgng_admin

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

.include "../../mk/bsd.prefs.mk"

# pkgng_admin is supposed to be installed before PKG_FORMAT is set to "pkgng"
# Detect when user fails to do that or if they accidently delete it, and
# provide a way of installing it without packaging or registering it.

.if ${PKG_FORMAT:Mpkgng} && !exists(${PKG_CMD})
package: build
	@echo "No pkg(8) installed, skipping package creation"

su-real-package-install:
	@echo "Installing unregistered pkgng_admin"
	${MKDIR} ${PREFIX}/sbin
	${INSTALL_PROGRAM} ${WRKSRC}/pkgng_admin ${PREFIX}/sbin/
.endif

.include "../../mk/bsd.pkg.mk"
