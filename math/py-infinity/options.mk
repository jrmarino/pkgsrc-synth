# $NetBSD: options.mk,v 1.1 2014/06/14 13:57:58 rodent Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.py-infinity
PKG_SUPPORTED_OPTIONS=	tests
PKG_SUGGESTED_OPTIONS+=	# blank

.include "../../mk/bsd.options.mk"

.include "../../lang/python/pyversion.mk"

.if !empty(PKG_OPTIONS:Mtests)
DEPENDS+=	${PYPKGPREFIX}-test>=2.2.3:../../devel/py-test
DEPENDS+=	${PYPKGPREFIX}-pygments>=1.2:../../textproc/py-pygments
DEPENDS+=	${PYPKGPREFIX}-six>=1.4.1:../../lang/py-six
.endif
