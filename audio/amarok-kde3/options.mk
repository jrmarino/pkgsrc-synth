# $NetBSD: options.mk,v 1.3 2013/02/17 12:21:34 shattered Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.amarok
PKG_SUPPORTED_OPTIONS=	libgpod libmtp mysql pgsql debug

.include "../../mk/bsd.options.mk"

PLIST_VARS+=	ipod libmtp

.if !empty(PKG_OPTIONS:Mlibgpod)
PLIST.ipod=		yes
CONFIGURE_ARGS+=	--enable-libgpod
BUILDLINK_API_DEPENDS.libgpod+=	libgpod>=0.8.0
.  include "../../audio/libgpod/buildlink3.mk"
.  include "../../textproc/libplist/buildlink3.mk"
.  include "../../databases/sqlite3/buildlink3.mk"
.endif

.if !empty(PKG_OPTIONS:Mlibmtp)
PLIST.libmtp=		yes
.  include "../../devel/libmtp/buildlink3.mk"
.endif

.if !empty(PKG_OPTIONS:Mmysql)
CONFIGURE_ARGS+=	--enable-mysql
.  include "../../mk/mysql.buildlink3.mk"
.endif

.if !empty(PKG_OPTIONS:Mpgsql)
CONFIGURE_ARGS+=	--enable-postgresql
.  include "../../mk/pgsql.buildlink3.mk"
.endif

.if !empty(PKG_OPTIONS:Mdebug)
CC+=			-ggdb
CXX+=			-ggdb
CONFIGURE_ARGS+=	--enable-debug=full
CONFIGURE_ENV+=		INSTALL_STRIP_FLAG=
INSTALL_UNSTRIPPED=	yes
.endif
