# $NetBSD: options.mk,v 1.2 2017/04/09 12:58:46 schmonz Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.qmail-run
PKG_SUPPORTED_OPTIONS+=	qmail-run-ofmipd sasl tls

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mqmail-run-ofmipd)
DEPENDS+=		mess822-[0-9]*:../../mail/mess822
.endif


.if !empty(PKG_OPTIONS:Msasl)
DEPENDS+=		spamdyke-[0-9]*:../../mail/spamdyke
.endif

.if !empty(PKG_OPTIONS:Mtls)
DEPENDS+=		stunnel-[0-9]*:../../security/stunnel
.endif
