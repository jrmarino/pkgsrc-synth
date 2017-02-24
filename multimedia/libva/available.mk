# $NetBSD: available.mk,v 1.5 2017/02/24 00:10:04 maya Exp $

.include "../../mk/bsd.prefs.mk"

# At the moment VAAPI is available only for XXX.  The following
# condition is here to NOT list these platforms in multiple places,
# i.e. in mplayer, xine, xbmc etc.  Have a look at buildlink3.mk too.

# The following should be kept up-to-date!
.if ${OPSYS} != "Darwin"
VAAPI_AVAILABLE=	yes
.else
VAAPI_AVAILABLE=	no
.endif
