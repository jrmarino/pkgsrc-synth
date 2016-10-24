# $NetBSD: options.mk,v 1.7 2016/07/09 13:03:44 wiz Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.py-tryton
PKG_SUPPORTED_OPTIONS=	cdecimal goocalendar pytz simplejson
PKG_SUGGESTED_OPTIONS+=	cdecimal pytz simplejson

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mcdecimal)
PYTHON_VERSIONS_INCOMPATIBLE+=	34 35 # py-cdecimal not available because obsolete
DEPENDS+=		${PYPKGPREFIX}-cdecimal-[0-9]*:../../math/py-cdecimal
.endif

.if !empty(PKG_OPTIONS:Mgoocalendar)
PYTHON_VERSIONS_INCOMPATIBLE+=	34 35 # py-gtk2 via py-goocanvas via py-goocalendar
DEPENDS+=		${PYPKGPREFIX}-goocalendar-[0-9]*:../../time/py-goocalendar
.endif

.if !empty(PKG_OPTIONS:Mpytz)
DEPENDS+=		${PYPKGPREFIX}-pytz-[0-9]*:../../time/py-pytz
.endif

.if !empty(PKG_OPTIONS:Msimplejson)
DEPENDS+=		${PYPKGPREFIX}-simplejson-[0-9]*:../../converters/py-simplejson
.endif
