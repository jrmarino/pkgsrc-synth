# $NetBSD: Makefile,v 1.22 2018/08/13 08:00:30 adam Exp $

DISTNAME=	pyzmq-17.1.2
PKGNAME=	${PYPKGPREFIX}-${DISTNAME:S/^py//}
CATEGORIES=	net python
MASTER_SITES=	${MASTER_SITE_PYPI:=p/pyzmq/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://github.com/zeromq/pyzmq
COMMENT=	Python bindings for zeromq
LICENSE=	gnu-lgpl-v3 AND modified-bsd

DEPENDS+=	${PYPKGPREFIX}-cython-[0-9]*:../../devel/py-cython
TEST_DEPENDS+=	${PYPKGPREFIX}-test-[0-9]*:../../devel/py-test

USE_TOOLS+=	pkg-config

PYSETUPBUILDARGS+=	--zmq=${BUILDLINK_PREFIX.zeromq:Q}

.include "../../lang/python/distutils.mk"
.include "../../net/zeromq/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
