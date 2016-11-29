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

${WRKDIR}/.created_fixed_dirs:
.for D in ${OWN_DIRS} ${OWN_DIRS_PERMS} ${MAKE_DIRS} ${MAKE_DIRS_PERMS}
	${RUN}${MKDIR} ${DESTDIR}${D}
.endfor
.for D in ${REQD_DIRS} ${REQD_DIRS_PERMS}
.  if ${D:M/*}
	${RUN}${MKDIR} ${DESTDIR}${D}
.  else
	${RUN}${MKDIR} ${DESTDIR}${PREFIX}/${D}
.  endif
.endfor
.if ${PKG_SYSCONFDIR:M*}
.  if ${PKG_SYSCONFDIR:M/*}
	${RUN}${MKDIR} ${DESTDIR}${PKG_SYSCONFDIR}
.  else
	${RUN}${MKDIR} ${DESTDIR}${PREFIX}/${PKG_SYSCONFDIR}
.  endif
.endif
.if ${PKG_SYSCONFSUBDIR:M*}
.  if ${PKG_SYSCONFSUBDIR:M/*}
	${RUN}${MKDIR} ${DESTDIR}${PKG_SYSCONFSUBDIR}
.  else
	${RUN}${MKDIR} ${DESTDIR}${PREFIX}/${PKG_SYSCONFSUBDIR}
.  endif
.endif
.for D in ${FONTS_DIRS.x11} ${FONTS_DIRS.ttf} ${FONTS_DIRS.type1}
.  if ${D:M/*}
	${RUN}${MKDIR} ${DESTDIR}${D}
.  else
	${RUN}${MKDIR} ${DESTDIR}${PREFIX}/${D}
.  endif
.endfor
	${RUN}pkgdir=$$(${AWK} '/@pkgdir / {print $$2}' ${PLIST}); \
		for pd in $${pkgdir}; do \
			${MKDIR} ${DESTDIR}${PREFIX}/$${pd}; \
		done
	${RUN}${TOUCH} ${.TARGET}

${PLIST_PKGNG}: ${WRKDIR}/.created_fixed_dirs ${PLIST}
	${AWK} -vPREFIX="${PREFIX}" \
		-vREQD_FILES="${REQD_FILES}" \
		-vREQD_FILES_MODE="${REQD_FILES_MODE}" \
		-vCONF_FILES="${CONF_FILES}" \
		-vCONF_FILES_MODE="${CONF_FILES_MODE}" \
		-vCONF_FILES_PERMS="${CONF_FILES_PERMS} ${REQD_FILES_PERMS}" \
		-vRCD_SCRIPTS="${RCD_SCRIPTS}" \
		-vRCD_SCRIPTS_DIR="${RCD_SCRIPTS_DIR}" \
		-vRCD_SCRIPTS_MODE="${RCD_SCRIPTS_MODE}" \
		-vRCD_SCRIPTS_EXAMPLEDIR="${RCD_SCRIPTS_EXAMPLEDIR}" \
		-vPKG_SHELL="${PKG_SHELL}" \
		-vSPECIAL_PERMS="${SPECIAL_PERMS}" \
		-vOCAML_FINDLIB_DIRS="${OCAML_FINDLIB_DIRS}" \
		-vLDCONFIG="${SET_LDCONFIG_KEYWORD}" \
		-vX11_TYPE="${X11_TYPE}" \
		-vFONTSDIR_X11="${FONTS_DIRS.x11}" \
		-vFONTSDIR_TTF="${FONTS_DIRS.ttf}" \
		-vFONTSDIR_TYPE1="${FONTS_DIRS.type1}" \
		-vPKG_SYSCONFDIR="${PKG_SYSCONFDIR}" \
		-f  ${PKGSRCDIR}/mk/pkgformat/pkgng/transform_plist.awk \
		${PLIST} > ${.TARGET}
	# Treat REQD_DIRS, MAKE_DIRS and OWN_DIRS identically
.for D in ${REQD_DIRS} ${OWN_DIRS} ${MAKE_DIRS}
	${RUN}${ECHO} "@dir ${D}" >> ${.TARGET}
.endfor
.for D owner group mode in ${REQD_DIRS_PERMS} ${OWN_DIRS_PERMS} ${MAKE_DIRS_PERMS}
	${RUN}${ECHO} "@dir(${owner},${group},${mode}) ${D}" >> ${.TARGET}
.endfor
.if ${PKG_SYSCONFSUBDIR:M*}
.for D owner group mode in ${PKG_SYSCONFSUBDIR} ${PKG_SYSCONFDIR_PERMS}
.  if ${D:M/*}
	${RUN}${ECHO} "@dir(${owner},${group},${mode}) ${D}" >> ${.TARGET}
.  else
	${RUN}${ECHO} "@dir(${owner},${group},${mode}) ${PREFIX}/${D}" >> ${.TARGET}
.  endif
.endfor
.endif
.for i in ${INFO}
	@${LS} ${STAGEDIR}${PREFIX}/${INFO_PATH}/$i.info* | ${SED} -e s:${STAGEDIR}:@info\ :g >> ${TMPPLIST}
.endfor

${STAGE_PKGFILE}: ${_MANIFEST_TARGETS} ${PLIST_PKGNG}
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

.if !target(su-real-package-install)
MAKEFLAGS.su-real-package-install=	PKGNAME_REQD=${PKGNAME_REQD:Q}
su-real-package-install:
	@${PHASE_MSG} "Installing binary package of "${PKGNAME:Q}
	${RUN} case ${_AUTOMATIC:Q}"" in \
	[yY][eE][sS])	${PKG_ADD_CMD} -A ${PKGFILE} ;; \
	*)		${PKG_ADD_CMD} ${PKGFILE} ;; \
	esac
.endif
