# $NetBSD$
#
# This Makefile fragment provides variable and target overrides that are
# specific to the pkgsrc native package format.
#

# PKG_FILELIST_CMD outputs the list of files owned by ${PKGNAME} as
# registered on the system.
#
# For DESTDIR support, just use _DEPENDS_PLIST instead.
#
.if ${_USE_DESTDIR} == "no"
PKG_FILELIST_CMD=	${PKG_INFO} -qL ${PKGNAME:Q}
.else
PKG_FILELIST_CMD=	${SED} -e "/^@/d" -e "s|^|${PREFIX}/|" ${_DEPENDS_PLIST}
.endif

.include "depends.mk"
.include "check.mk"
.include "metadata.mk"
.include "deinstall.mk"
.include "package.mk"

.include "utility.mk"
