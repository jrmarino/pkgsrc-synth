# $NetBSD: Makefile,v 1.2 2018/05/06 11:55:13 markd Exp $

DISTNAME=	ifplatform
PKGNAME=	tex-${DISTNAME}-0.4a
TEXLIVE_REV=	45533

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://ctan.org/pkg/ifplatform
COMMENT=	Conditionals to test which platform is being used
LICENSE=	lppl-1.3c

DEPENDS+=	tex-ifluatex-[0-9]*:../../print/tex-ifluatex
DEPENDS+=	tex-oberdiek-[0-9]*:../../print/tex-oberdiek

.include "../../print/texlive/package.mk"
.include "../../mk/bsd.pkg.mk"
