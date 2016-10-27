# $NetBSD$

.if ${PKG_COMPRESSION} == "gzip"
_PKG_FORMAT=	-f tgz
PKGNG_SUFX=	.tgz
.elif ${PKG_COMPRESSION} == "bzip2"
_PKG_FORMAT=	-f tbz
PKGNG_SUFX=	.tbz
.elif ${PKG_COMPRESSION} == "none"
_PKG_FORMAT=	-f tar
PKGNG_SUFX=	.tar
.else #includes valid "xz" and ignores invalid formats
_PKG_FORMAT=	-f txz
PKGNG_SUFX=	.txz
.endif

FILEBASE?=		${PKGBASE}
PACKAGE_NAME=		${FILEBASE}-${PKGVERSION}${PKGNG_SUFX}
PKGFILE?=		${PKGREPOSITORY}/${PACKAGE_NAME}
STAGE_PKGFILE?=		${WRKDIR}/.packages/${PACKAGE_NAME}
PKGREPOSITORY?=		${PACKAGES}/${PKGREPOSITORYSUBDIR}
PKGREPOSITORYSUBDIR?=	All

######################################################################
### package-check-installed (PRIVATE, pkgsrc/mk/package/package.mk)
######################################################################
### package-check-installed verifies that the package is installed on
### the system.
###
.PHONY: package-check-installed
package-check-installed:
	${RUN} ${PKG_INFO} -qe ${PKGNAME} \
	|| ${FAIL_MSG} "${PKGNAME} is not installed."

######################################################################
### package-create (PRIVATE, pkgsrc/mk/package/package.mk)
######################################################################
### package-create creates the binary package.
###
.PHONY: package-create
package-create: ${PKGFILE}

######################################################################
### stage-package-create (PRIVATE, pkgsrc/mk/package/package.mk)
######################################################################
### stage-package-create creates the binary package for stage install.
###
.PHONY: stage-package-create
stage-package-create:	stage-install ${STAGE_PKGFILE}

_PKG_ARGS_PACKAGE+=	${_PKG_CREATE_ARGS} ${_PKG_FORMAT}

${STAGE_PKGFILE}: ${_MANIFEST_TARGETS}
	@${STEP_MSG} "Creating binary package ${.TARGET}"
	${RUN} ${MKDIR} ${.TARGET:H}
	if ! ${PKG_CREATE} ${_PKG_ARGS_PACKAGE}; then		\
		exitcode=$$?; ${RM} -f "${.TARGET}"; exit $$exitcode;	\
	fi

# Note that with pkg(8), it's the repository that is signed, not individual
# packages.  The repositories contain hashes of the packages, so pkg(8)
# will automatically verification automatically given a public key

.if ${PKGFILE} != ${STAGE_PKGFILE}
${PKGFILE}: ${STAGE_PKGFILE}
	${RUN} ${MKDIR} ${.TARGET:H}
	@${STEP_MSG} "Creating binary package ${.TARGET}"
	${LN} -f ${STAGE_PKGFILE} ${PKGFILE} 2>/dev/null || \
		${CP} -pf ${STAGE_PKGFILE} ${PKGFILE}
.endif

######################################################################
### package-remove (PRIVATE)
######################################################################
### package-remove removes the binary package from the package
### repository.
###
.PHONY: package-remove
package-remove:
	${RUN} ${RM} -f ${PKGFILE}

######################################################################
### stage-package-remove (PRIVATE)
######################################################################
### stage-package-remove removes the binary package for stage install
###
.PHONY: stage-package-remove
stage-package-remove:
	${RUN} ${RM} -f ${STAGE_PKGFILE}

######################################################################
### tarup (PUBLIC)
######################################################################
### tarup is a public target to generate a binary package from an
### installed package instance.
###

.PHONY: tarup
tarup:
	${FAIL_MSG} "Do not use the tarup hack with pkg(8)."

######################################################################
### package-install (PUBLIC)
######################################################################
### package-install uses package to create a binary package and
### install it.  Otherwise it is identical to calling package.
###

.PHONY: package-install real-package-install
.if defined(_PKGSRC_BARRIER)
package-install: package real-package-install
.else
package-install: barrier
.endif

.PHONY: stage-package-install
.if defined(_PKGSRC_BARRIER)
stage-package-install: stage-package-create real-package-install
.else
stage-package-install: barrier
.endif

real-package-install: su-target
