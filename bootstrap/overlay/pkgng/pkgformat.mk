# $NetBSD$
#
# This Makefile fragment provides variable and target overrides that are
# specific to the pkgsrc native package format.
#
PKG_FILELIST_CMD=	${PKG_CMD} query '%Fp' ${PKGNAME:Q}

.if "${OBJECT_FMT}" != "ELF"
.error The pkgng format is only available on ELF systems
.endif

.include "depends.mk"
.include "check.mk"
.include "metadata.mk"
.include "deinstall.mk"
.include "package.mk"

.include "utility.mk"

# dependency installation is handled by pkg(8), provide empty targets

_pkgformat-install-dependencies:
_pkgformat-post-install-dependencies:

_pkgformat-install-clean: .PHONY _pkgformat-clean-metadata
