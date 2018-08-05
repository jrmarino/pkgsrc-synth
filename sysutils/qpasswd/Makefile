# $NetBSD: Makefile,v 1.1 2018/08/05 15:00:46 schmonz Exp $

DISTNAME=		qpasswd-0.5
CATEGORIES=		sysutils
MASTER_SITES=		${HOMEPAGE}dl/
EXTRACT_SUFX=		.tar.bz2

MAINTAINER=		schmonz@NetBSD.org
HOMEPAGE=		https://mcmilk.de/projects/qpasswd/
COMMENT=		Password-checking tools for many authentication schemes
#LICENSE=		# TODO: (see mk/license.mk)

SUBST_CLASSES+=		paths
SUBST_STAGE.paths=	pre-build
SUBST_FILES.paths=	man/checkqpasswd.8 man/qpasswd.5
SUBST_FILES.paths+=	qpasswd_gethome.c usage.c do_checkqpasswd.c params.h
SUBST_FILES.paths+=	params.h do_checkqpasswd.c qpasswd_gethome.c usage.c
SUBST_SED.paths=	-e 's|/etc/qpasswd|${PKG_SYSCONFDIR}/qpasswd|g'

DJB_RESTRICTED=		no

LDFLAGS.Linux+=		-lcrypt
LDFLAGS.NetBSD+=	-lcrypt

NO_CONFIGURE=		yes
TEST_TARGET=		check

BUILD_DEFS+=		QMAIL_NOFILES_GROUP QMAIL_ROOT_USER

SPECIAL_PERMS+=		bin/multicheckpw ${QMAIL_ROOT_USER} ${QMAIL_NOFILES_GROUP} 4510

INSTALLATION_DIRS=	bin ${PKGMANDIR}

.include "../../mk/djbware.mk"
.include "../../mk/bsd.pkg.mk"
