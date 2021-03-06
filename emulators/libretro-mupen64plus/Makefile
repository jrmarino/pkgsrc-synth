# $NetBSD: Makefile,v 1.12 2018/08/16 13:25:27 nia Exp $

DISTNAME=	libretro-mupen64plus-20180628
CATEGORIES=	emulators
MASTER_SITES=	${MASTER_SITE_GITHUB:=libretro/}
GITHUB_PROJECT=	mupen64plus-libretro
GITHUB_TAG=	4ca2fa8633666e26e2f163dcd3c226b598cb2aa4

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://docs.libretro.com/library/mupen64plus/
COMMENT=	Libretro core based on the Mupen64Plus emulator
LICENSE=	gnu-gpl-v3

EXTRACT_USING=	bsdtar
USE_LANGUAGES=	c c++03
USE_TOOLS+=	gmake

SUBST_CLASSES+=		vc
SUBST_STAGE.vc=		pre-configure
SUBST_MESSAGE.vc=	Fixing path to VideoCore libraries.
SUBST_FILES.vc=		Makefile
SUBST_SED.vc+=		-e 's;/opt/vc;${PREFIX};g'

MAKE_FLAGS+=		GIT_VERSION="-pkgsrc"

.if !empty(MACHINE_ARCH:M*arm*)
MAKE_FLAGS+=	WITH_DYNAREC=arm
.elif ${MACHINE_ARCH} == "i386"
MAKE_FLAGS+=	WITH_DYNAREC=x86
.elif ${MACHINE_ARCH} == "x86_64"
MAKE_FLAGS+=	WITH_DYNAREC=x86_64
.else
MAKE_FLAGS+=	WITH_DYNAREC=
.endif

INSTALLATION_DIRS+=	${PREFIX}/lib/libretro

CFLAGS.NetBSD+=		-DHAVE_POSIX_MEMALIGN=1

.include "options.mk"

do-install:
	${INSTALL_LIB} ${WRKSRC}/mupen64plus_libretro.so \
	    ${DESTDIR}${PREFIX}/lib/libretro/mupen64plus_libretro.so

.include "../../devel/zlib/buildlink3.mk"
.include "../../graphics/png/buildlink3.mk"
.include "../../mk/pthread.buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
