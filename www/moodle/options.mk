# $NetBSD: options.mk,v 1.5 2017/04/15 15:55:21 taca Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.moodle

PKG_OPTIONS_REQUIRED_GROUPS=	db
PKG_OPTIONS_GROUP.db=		mysql pgsql
PKG_SUGGESTED_OPTIONS=		mysql

.include "../../mk/bsd.options.mk"

###
### Use mysql or postgresql backend
###
.if !empty(PKG_OPTIONS:Mmysql)
DEPENDS+=	${PHP_PKG_PREFIX}-mysqli>=5.2.14:../../databases/php-mysqli
.elif !empty(PKG_OPTIONS:Mpgsql)
DEPENDS+=	${PHP_PKG_PREFIX}-pgsql>=5:../../databases/php-pgsql
.endif
