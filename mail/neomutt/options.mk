# $NetBSD: options.mk,v 1.9 2017/07/18 18:39:37 wiz Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.neomutt
PKG_OPTIONS_REQUIRED_GROUPS=	display
PKG_OPTIONS_GROUP.display=	slang ncurses ncursesw curses
PKG_SUPPORTED_OPTIONS=	debug gpgme gssapi idn ssl smime sasl
PKG_SUPPORTED_OPTIONS+=	mutt-hcache tokyocabinet
PKG_SUGGESTED_OPTIONS=	ncursesw gpgme idn mutt-hcache sasl smime ssl
PKG_SUGGESTED_OPTIONS+=	gssapi
PKG_SUGGESTED_OPTIONS+=	mutt-hcache tokyocabinet

.include "../../mk/bsd.options.mk"

###
### GSSAPI
###
CONFIGURE_ENV+=		ac_cv_path_KRB5CFGPATH=${KRB5_CONFIG}
.if !empty(PKG_OPTIONS:Mgssapi)
.  include "../../mk/krb5.buildlink3.mk"
CONFIGURE_ARGS+=	--with-gss=${KRB5BASE}
.endif

###
### Slang
###
.if !empty(PKG_OPTIONS:Mslang)
.  include "../../devel/libslang/buildlink3.mk"
CONFIGURE_ARGS+=	--with-slang=${BUILDLINK_PREFIX.libslang}
.endif

###
### ncurses
###
.if !empty(PKG_OPTIONS:Mncurses)
USE_NCURSES=		yes
.  include "../../devel/ncurses/buildlink3.mk"
CONFIGURE_ARGS+=	--with-curses=${BUILDLINK_PREFIX.ncurses}
.endif

###
### SASLv2
###
.if !empty(PKG_OPTIONS:Msasl)
.  include "../../security/cyrus-sasl/buildlink3.mk"
CONFIGURE_ARGS+=	--with-sasl=${BUILDLINK_PREFIX.cyrus-sasl}
.endif

### curses
###
.if !empty(PKG_OPTIONS:Mcurses)
.  include "../../mk/curses.buildlink3.mk"
OPSYSVARS+=			BUILDLINK_PASSTHRU_DIRS
BUILDLINK_PASSTHRU_DIRS.SunOS+=	/usr/xpg4
CONFIGURE_ARGS.SunOS+=		--with-curses=/usr/xpg4
LDFLAGS.SunOS+=			-L/usr/xpg4/lib${LIBABISUFFIX}
LDFLAGS.SunOS+=			${COMPILER_RPATH_FLAG}/usr/xpg4/lib${LIBABISUFFIX}
.endif

###
### ncursesw
###
.if !empty(PKG_OPTIONS:Mncursesw)
.  include "../../devel/ncursesw/buildlink3.mk"
.else
SUBST_CLASSES+=		curse
SUBST_MESSAGE.curse=	Fixing mutt to avoid ncursesw
SUBST_STAGE.curse=	post-patch
SUBST_FILES.curse=	configure.ac
SUBST_SED.curse=	-e 's,for lib in ncurses ncursesw,for lib in ncurses,'
.endif

###
### SSL
###
.if !empty(PKG_OPTIONS:Mssl)
.  include "../../security/openssl/buildlink3.mk"
CONFIGURE_ARGS+=	--with-ssl=${SSLBASE:Q}
.else
CONFIGURE_ARGS+=	--without-ssl
.endif

###
### S/MIME
###
PLIST_VARS+=		smime
.if !empty(PKG_OPTIONS:Msmime)
USE_TOOLS+=		perl:run
REPLACE_PERL+=		*.pl */*.pl contrib/smime_keys
.  include "../../security/openssl/buildlink3.mk"
CONFIGURE_ARGS+=	--enable-smime
PLIST.smime=		yes
.else
CONFIGURE_ARGS+=	--disable-smime
.endif

###
### Header cache
###
.if !empty(PKG_OPTIONS:Mmutt-hcache)
.  if !empty(PKG_OPTIONS:Mtokyocabinet)
.  include "../../databases/tokyocabinet/buildlink3.mk"
CONFIGURE_ARGS+=	--with-tokyocabinet
CONFIGURE_ARGS+=	--without-gdbm
CONFIGURE_ARGS+=	--without-bdb
.  else
BDB_ACCEPTED=		db4 db5
BUILDLINK_TRANSFORM+=	l:db:${BDB_TYPE}
.  include "../../mk/bdb.buildlink3.mk"
CONFIGURE_ARGS+=	--with-bdb
CONFIGURE_ARGS+=	--without-gdbm
# BDB_INCLUDE_DIR_ and BDB_LIB_DIR don't have to be particularly accurate
# since the real -I and -L flags are added by buildlink already.
CONFIGURE_ENV+=		BDB_INCLUDE_DIR=${BDBBASE}/include
CONFIGURE_ENV+=		BDB_LIB_DIR=${BDBBASE}/lib
CONFIGURE_ENV+=		BDB_LIB=${BDB_LIBS:S/^-l//:M*:Q}
.  endif
.else
CONFIGURE_ARGS+=	--disable-hcache
.endif

#BUILD_DEPENDS+=		libxslt-[0-9]*:../../textproc/libxslt
#BUILD_DEPENDS+=		docbook-xsl-[0-9]*:../../textproc/docbook-xsl

###
### Internationalized Domain Names
###
.if !empty(PKG_OPTIONS:Midn)
.  include "../../devel/libidn/buildlink3.mk"
CONFIGURE_ARGS+=	--with-idn=${BUILDLINK_PREFIX.libidn}
.else
CONFIGURE_ARGS+=	--with-idn=no
.endif

###
### Enable debugging support
###
.if !empty(PKG_OPTIONS:Mdebug)
CONFIGURE_ARGS+=	--enable-debug
CFLAGS+= -g
.endif

###
### gpgme support
###
.if !empty(PKG_OPTIONS:Mgpgme)
.  include "../../security/gpgme/buildlink3.mk"
CONFIGURE_ARGS+=	--enable-gpgme
CONFIGURE_ARGS+=	--with-gpgme-prefix=${BUILDLINK_PREFIX.gpgme}
.else
CONFIGURE_ARGS+=	--disable-gpgme
.endif
