# $NetBSD: Makefile,v 1.2 2018/07/18 00:07:51 joerg Exp $

DISTNAME=	Cairo_1.5-9
CATEGORIES=	graphics

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://www.rforge.net/Cairo/
COMMENT=	R graphics device using cairo graphics library
LICENSE=	gnu-gpl-v2

USE_TOOLS+=	pkg-config

BUILDLINK_API_DEPENDS.R+=	R>=2.4.0
.include "../../math/R/Makefile.extension"
BUILDLINK_API_DEPENDS.cairo+=	cairo>=1.2
.include "../../graphics/cairo/buildlink3.mk"
.include "../../x11/libXt/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
