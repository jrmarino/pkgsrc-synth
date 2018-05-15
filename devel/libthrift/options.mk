# $NetBSD: options.mk,v 1.12 2018/05/15 10:16:17 jperkin Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.libthrift
PKG_SUPPORTED_OPTIONS=	lua perl python # csharp java erlang php ruby

.include "../../mk/bsd.options.mk"

PLIST_VARS+=		csharp erlang java lua perl php python ruby

.if !empty(PKG_OPTIONS:Mcsharp)
CONFIGURE_ARGS+=	--with-csharp
CONFIGURE_ARGS+=	--enable-gen-csharp
PLIST.csharp=		yes
INSTALLATION_DIRS+=	lib/thrift

post-install:
	${INSTALL_LIB} ${WRKSRC}/lib/csharp/Thrift.dll \
	  ${DESTDIR}${PREFIX}/lib/thrift/Thrift.dll

.include "../../lang/mono2/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--without-csharp
.endif

.if !empty(PKG_OPTIONS:Mjava)
CONFIGURE_ARGS+=	--with-java
CONFIGURE_ARGS+=	--enable-gen-java
USE_JAVA=		yes
USE_JAVA2=		6
.include "../../mk/java-vm.mk"
BUILD_DEPENDS+=		apache-ant-[0-9]*:../../devel/apache-ant
PLIST.java=		yes
.else
CONFIGURE_ARGS+=	--without-java
.endif

.if !empty(PKG_OPTIONS:Merlang)
CONFIGURE_ARGS+=	--with-erlang
CONFIGURE_ARGS+=	--enable-gen-erl
PLIST.erlang=		yes

.include "../../lang/erlang/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--without-erlang
.endif

.if !empty(PKG_OPTIONS:Mlua)
CONFIGURE_ARGS+=	--with-lua
.include "../../lang/lua/buildlink3.mk"
PLIST.lua=		yes
.else
CONFIGURE_ARGS+=	--without-lua
.endif

.if !empty(PKG_OPTIONS:Mpython)
CONFIGURE_ARGS+=	--with-python
CONFIGURE_ARGS+=	--enable-gen-py
PLIST.python=		yes
PLIST_SUBST+=		PYSITELIB=${PYSITELIB}

.include "../../lang/python/extension.mk"
CONFIGURE_ENV+=		PY_PREFIX=${BUILDLINK_PREFIX.${PYPACKAGE}}
.else
CONFIGURE_ARGS+=	--without-python
.endif

.if !empty(PKG_OPTIONS:Mperl)
CONFIGURE_ARGS+=	--with-perl
CONFIGURE_ARGS+=	--enable-gen-perl
CONFIGURE_ENV+=		PERL_PREFIX=${PREFIX}
MAKE_ENV+=		INSTALLDIRS=vendor
PERL5_CONFIGURE=	NO
USE_TOOLS+=		perl
PLIST.perl=		yes

#PERL5_PACKLIST=		auto/Thrift/.packlist

DEPENDS+=		p5-Bit-Vector-[0-9]*:../../devel/p5-Bit-Vector
DEPENDS+=		p5-Class-Accessor-[0-9]*:../../devel/p5-Class-Accessor
.include "../../lang/perl5/module.mk"
.else
CONFIGURE_ARGS+=	--without-perl
.endif

.if !empty(PKG_OPTIONS:Mphp)
CONFIGURE_ARGS+=	--with-php
CONFIGURE_ARGS+=	--with-php_extension
CONFIGURE_ARGS+=	--enable-gen-php
PLIST.php=		yes
# XXX: avoid override from php Makefile.common
EXTRACT_SUFX=		.tar.gz

# support PHP 5.6's API only
PHP_VERSIONS_ACCEPTED=	56

.include "../../lang/php/phpversion.mk"
.include "${PHPPKGSRCDIR}/Makefile.common"
.include "${PHPPKGSRCDIR}/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--without-php
CONFIGURE_ARGS+=	--without-php_extension
.endif

.if !empty(PKG_OPTIONS:Mruby)
CONFIGURE_ARGS+=	--with-ruby
CONFIGURE_ARGS+=	--enable-gen-rb
CONFIGURE_ENV+=		ac_cv_path_RUBY=${RUBY}
PLIST.ruby=		yes

.include "../../lang/ruby/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--without-ruby
.endif

# Languages without options that may be auto-detected
CONFIGURE_ARGS+=	--without-nodejs
CONFIGURE_ARGS+=	--without-dart
CONFIGURE_ARGS+=	--without-haskell
CONFIGURE_ARGS+=	--without-go
CONFIGURE_ARGS+=	--without-rs
CONFIGURE_ARGS+=	--without-haxe
CONFIGURE_ARGS+=	--without-dotnetcore
CONFIGURE_ARGS+=	--without-d

