# $NetBSD: Makefile,v 1.62 2018/07/13 11:31:58 jperkin Exp $

.include "../../textproc/libxml2/Makefile.common"

PKGNAME=	${PYPKGPREFIX}-${DISTNAME}

COMMENT=	Python wrapper for libxml2
LICENSE=	modified-bsd

USE_GCC_RUNTIME=	yes

PYSETUPSUBDIR=	python
NO_CONFIGURE=	YES

SUBST_CLASSES+=		setup
SUBST_MESSAGE.setup=	Fixing hardcoded paths.
SUBST_STAGE.setup=	pre-build
SUBST_FILES.setup=	python/setup.py
SUBST_SED.setup=	-e "/ROOT/s,'/usr','${BUILDLINK_PREFIX.libxml2}',g"
SUBST_SED.setup+=	-e "/^\"/s,/usr/include,${BUILDLINK_PREFIX.iconv}/include,g"
SUBST_SED.setup+=	-e "/^\"/s,/usr/local/include,${BUILDLINK_PREFIX.iconv}/include,g"

BUILDLINK_TRANSFORM.Darwin+=	opt:-bundle:-dynamiclib

.include "../../mk/bsd.prefs.mk"

.if ${OPSYS} == "Darwin"
post-install: fix-darwin-install-name
fix-darwin-install-name:
	install_name_tool -id ${PREFIX}/${PYSITELIB}/libxml2mod.so \
	    ${DESTDIR}${PREFIX}/${PYSITELIB}/libxml2mod.so
.endif

EGG_NAME=	${DISTNAME:S/-/_python-/}

BUILD_DEPENDS+=	${PYPKGPREFIX}-expat>=0:../../textproc/py-expat

BUILDLINK_API_DEPENDS.libxml2+=	libxml2>=${PKGVERSION_NOREV}
.include "../../textproc/libxml2/buildlink3.mk"

.include "../../lang/python/distutils.mk"
.include "../../converters/libiconv/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
