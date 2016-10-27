# $NetBSD$
#
# This Makefile fragment provides variable and target overrides that are
# specific to the pkgsrc native package format.
#
_DEPENDS_PLIST:=	# non-existant, referenced by plist.mk and install.mk
PKG_FILELIST_CMD=	${PKG_CMD} query '%Fp' ${PKGNAME:Q}

.include "check.mk"
.include "metadata.mk"
.include "deinstall.mk"
.include "package.mk"

.include "utility.mk"

# dependency installation is handled by pkg(8), provide empty targets

_pkgformat-install-dependencies:
_pkgformat-post-install-dependencies:
