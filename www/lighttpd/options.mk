# $NetBSD: options.mk,v 1.12 2016/10/17 22:00:22 nros Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.lighttpd
PKG_SUPPORTED_OPTIONS=	bzip2 fam gdbm inet6 ldap lua mysql ssl memcache geoip
PKG_SUGGESTED_OPTIONS=	inet6 ssl

.include "../../mk/bsd.options.mk"

###
### Allow using bzip2 as a compression method in the "compress" module.
###
.if !empty(PKG_OPTIONS:Mbzip2)
.  include "../../archivers/bzip2/buildlink3.mk"
CONFIGURE_ARGS+=	--with-bzip2
.else
CONFIGURE_ARGS+=	--without-bzip2
.endif

###
### Use FAM to optimize number of stat() syscalls used.
###
.if !empty(PKG_OPTIONS:Mfam)
.  include "../../mk/fam.buildlink3.mk"
CONFIGURE_ARGS+=	--with-fam
.endif

###
### Support using GDBM for storage in the "trigger before download" module.
###
.if !empty(PKG_OPTIONS:Mgdbm)
.  include "../../databases/gdbm/buildlink3.mk"
CONFIGURE_ARGS+=	--with-gdbm
.endif

###
### IPv6 support.
###
.if !empty(PKG_OPTIONS:Minet6)
CONFIGURE_ARGS+=	--enable-ipv6
.else
CONFIGURE_ARGS+=	--disable-ipv6
.endif

###
### Allow using LDAP for "basic" authentication.
###
.if !empty(PKG_OPTIONS:Mldap)
.  include "../../databases/openldap-client/buildlink3.mk"
CONFIGURE_ARGS+=	--with-ldap
.endif

###
### Support enabling the Cache Meta Language module with the Lua engine.
###
.if !empty(PKG_OPTIONS:Mlua)
LUA_VERSIONS_INCOMPATIBLE=	52 53
.  include "../../lang/lua/buildlink3.mk"
USE_TOOLS+=		pkg-config
CONFIGURE_ARGS+=	--with-lua
.endif

###
### Support using memcached as an in-memory caching system for the
### "trigger before download" and CML modules.
###
.if !empty(PKG_OPTIONS:Mmemcache)
.  include "../../devel/libmemcache/buildlink3.mk"
CONFIGURE_ARGS+=	--with-memcache
.endif

###
### Allow using MySQL for virtual host configuration.
###
.if !empty(PKG_OPTIONS:Mmysql)
.  include "../../mk/mysql.buildlink3.mk"
MYSQL_CONFIG?=		${BUILDLINK_PREFIX.mysql-client}/bin/mysql_config
CONFIGURE_ARGS+=	--with-mysql=${MYSQL_CONFIG:Q}
.endif

###
### HTTPS support
###
.if !empty(PKG_OPTIONS:Mssl)
.  include "../../security/openssl/buildlink3.mk"
CONFIGURE_ARGS+=	--with-openssl=${SSLBASE:Q}
.endif

###
### GeoIP support
###
.if !empty(PKG_OPTIONS:Mgeoip)
.  include "../../net/GeoIP/buildlink3.mk"
CONFIGURE_ARGS+=        --with-geoip
.endif
