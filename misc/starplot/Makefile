# $NetBSD: Makefile,v 1.9 2018/07/18 00:06:21 joerg Exp $

DISTNAME=	starplot-0.95.5
PKGREVISION=	7
CATEGORIES=	misc x11
MASTER_SITES=	http://starplot.org/downloads/

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://starplot.org/
COMMENT=	3-dimensional star chart viewer
LICENSE=	gnu-gpl-v2

GNU_CONFIGURE=		yes
USE_PKGLOCALEDIR=	yes
USE_LANGUAGES=		c c++03
USE_TOOLS+=		bison msgfmt pkg-config
PTHREAD_OPTS+=		require

.include "../../mk/pthread.buildlink3.mk"
.include "../../converters/libiconv/buildlink3.mk"
.include "../../sysutils/desktop-file-utils/desktopdb.mk"
.include "../../x11/gtk2/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
