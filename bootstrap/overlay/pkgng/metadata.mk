# $NetBSD$

######################################################################
### The targets below are all PRIVATE.
######################################################################

######################################################################
###
### Temporary package meta-data directory.  The contents of this directory
### are copied directly into the real package meta-data directory.
###
PKG_DB_TMPDIR=	${WRKDIR}/.pkgdb

unprivileged-install-hook: ${PKG_DB_TMPDIR}
${PKG_DB_TMPDIR}:
	${RUN}${MKDIR} ${.TARGET}

######################################################################
###
### +DESC - Package description file
###
### This file contains the paragraph description of the package.
###
_DESCR_FILE=		${PKG_DB_TMPDIR}/+DESC
_MANIFEST_TARGETS+=	${_DESCR_FILE}

${_DESCR_FILE}: ${DESCR_SRC}
	${RUN}${MKDIR} ${.TARGET:H}
	${RUN}${RM} -f ${.TARGET}
	${RUN}${CAT} ${.ALLSRC} > ${.TARGET}

######################################################################
###
### +DISPLAY - Package message file
###
### This file contains important messages which apply to this package,
### and are shown during installation.
###
.if exists(${PKGDIR}/MESSAGE)
MESSAGE_SRC_DFLT=	${PKGDIR}/MESSAGE
.else
.  if exists(${PKGDIR}/MESSAGE.common)
MESSAGE_SRC_DFLT=	${PKGDIR}/MESSAGE.common
.  endif
.  if exists(${PKGDIR}/MESSAGE.${OPSYS})
MESSAGE_SRC_DFLT+=	${PKGDIR}/MESSAGE.${OPSYS}
.  endif
.  if exists(${PKGDIR}/MESSAGE.${MACHINE_ARCH:C/i[3-6]86/i386/g})
MESSAGE_SRC_DFLT+=	${PKGDIR}/MESSAGE.${MACHINE_ARCH:C/i[3-6]86/i386/g}
.  endif
.  if exists(${PKGDIR}/MESSAGE.${OPSYS}-${MACHINE_ARCH:C/i[3-6]86/i386/g})
MESSAGE_SRC_DFLT+=	${PKGDIR}/MESSAGE.${OPSYS}-${MACHINE_ARCH:C/i[3-6]86/i386/g}
.  endif
.endif
MESSAGE_SRC?=	${MESSAGE_SRC_DFLT}

.if !empty(MESSAGE_SRC)
_MESSAGE_FILE=		${PKG_DB_TMPDIR}/+DISPLAY
_MANIFEST_TARGETS+=	${_MESSAGE_FILE}

# Set MESSAGE_SUBST to substitute "${variable}" to "value" in MESSAGE
MESSAGE_SUBST+=	PKGNAME=${PKGNAME}					\
		PKGBASE=${PKGBASE}					\
		PREFIX=${PREFIX}					\
		EMULDIR=${EMULDIR}					\
		EMULSUBDIR=${EMULSUBDIR}				\
		LOCALBASE=${LOCALBASE}					\
		X11PREFIX=${X11PREFIX}					\
		X11BASE=${X11BASE}					\
		PKG_SYSCONFDIR=${PKG_SYSCONFDIR}			\
		ROOT_GROUP=${REAL_ROOT_GROUP}				\
		ROOT_USER=${REAL_ROOT_USER}

_MESSAGE_SUBST_SED=	${MESSAGE_SUBST:S/=/}!/:S/$/!g/:S/^/ -e s!\\\${/}

${_MESSAGE_FILE}: ${MESSAGE_SRC}
	${RUN}${MKDIR} ${.TARGET:H}
	${RUN}${CAT} ${.ALLSRC} |			\
		${SED} ${_MESSAGE_SUBST_SED} > ${.TARGET}

# Display MESSAGE file and optionally mail the contents to
# PKGSRC_MESSAGE_RECIPIENTS.
#
.PHONY: install-display-message
#_pkgformat-register: install-display-message
install-display-message: ${_MESSAGE_FILE}
.  if !empty(PKGSRC_MESSAGE_RECIPIENTS)
	${RUN}								\
	(${ECHO} "The ${PKGNAME} package was built on `${HOSTNAME_CMD}` at `date`"; \
	${ECHO} "";							\
	${ECHO} "Please note the following:";				\
	${ECHO} "";							\
	${CAT} ${_MESSAGE_FILE};					\
	${ECHO} "") |							\
	${MAIL_CMD} -s"Package ${PKGNAME} installed on `${HOSTNAME_CMD}`" ${PKGSRC_MESSAGE_RECIPIENTS}
.  endif
.endif	# MESSAGE_SRC


######################################################################
###
### +MANIFEST - Package manifest file
###
### This file contains the list of files and checksums, along with
### any special "@" commands, e.g. @dirrm.
###
_MANIFEST_FILE=		${PKG_DB_TMPDIR}/+MANIFEST
PLIST_PKGNG:=		${WRKDIR}/.PLIST.pkgng

_PKG_CREATE_ARGS+=	--metadata ${PKG_DB_TMPDIR} \
			--plist    ${PLIST_PKGNG} \
			--out-dir  ${WRKDIR}/.packages \
			--root-dir ${DESTDIR}

.if defined(PKG_CREATE_VERBOSE)
_PKG_CREATE_ARGS+=	--verbose
.endif

.if defined(NO_ARCH)
PKGNG_ARCH!=	${PKG_CMD} config abi
.endif

LICLOGIC=	single
.if defined(LICENSE) && !empty(LICENSE)
.  if ${LICENSE:MAND}
LICLOGIC=	multi
.  elif ${LICENSE:NOR}
LICLOGIC=	dual
.  endif
.endif

ACTUAL-PACKAGE-DEPENDS?= ${SETENV} PKG_BIN="${PKG_CMD}" ${SH} \
	${PKGDIR:H:H}/mk/scripts/actual-package-depends ${DEPENDS:C/(.*)\:.*/"\1"/}

${_MANIFEST_FILE}: ${_MANIFEST_TARGETS}
	${RUN}${MKDIR} ${.TARGET:H}
	${RUN} { \
	${ECHO} "name: \"${PKGNAME:C/(.*)-.*/\1/}\""; \
	${ECHO} "version: \"${PKGVERSION}\""; \
	${ECHO} "origin: ${PKGDIR:H:T}/${PKGDIR:T}"; \
	${ECHO} "comment: <<EOD"; \
	${ECHO} ${COMMENT:Q}; \
	${ECHO} "EOD"; \
	${ECHO} "maintainer: ${MAINTAINER}"; \
	${ECHO} "prefix: ${PREFIX}"; \
	${ECHO} "categories: [ ${CATEGORIES} ]"; \
	${ECHO} "licenselogic: ${LICLOGIC}"; \
		} > ${.TARGET}

.if defined(HOMEPAGE)
	${RUN}${ECHO} "www: ${HOMEPAGE}" >> ${.TARGET}
.endif
.if defined(LICENSE) && !empty(LICENSE)
	${RUN}${ECHO} "licenses: [ ${LICENSE:NAND:NOR:u:S/$/,/} ]" >> ${.TARGET}
.endif
.if defined(PKG_USERS) && !empty(PKG_USERS)
	${RUN}${ECHO} "users: [ ${PKG_USERS:C/:.*//:S/$/,/} ]" >> ${.TARGET}
.endif
.if defined(PKG_GROUPS) && !empty(PKG_GROUPS)
	${RUN}${ECHO} "groups: [ ${PKG_GROUPS:u:S/$/,/} ]" >> ${.TARGET}
.endif
.if defined(NO_ARCH)
	${RUN}${ECHO} "arch: ${PKGNG_ARCH:S/:/ /g:[1]:tl}:${PKGNG_ARCH:S/:/ /g:[2]}:*" >> ${.TARGET}
	${RUN}${ECHO} "abi: ${PKGNG_ARCH:S/:/ /g:[1]}:${PKGNG_ARCH:S/:/ /g:[2]}:*" >> ${.TARGET}
.endif

	${RUN}${ECHO} "deps: {" >> ${.TARGET}
	${RUN}${ACTUAL-PACKAGE-DEPENDS} | ${SORT} -u >> ${.TARGET}
	${RUN}${ECHO} "}" >> ${.TARGET}

	${RUN}${ECHO} "options: {" >> ${.TARGET}
.if defined(PKG_SUPPORTED_OPTIONS) && !empty(PKG_SUPPORTED_OPTIONS)
.  for opt in ${PKG_OPTIONS}
	${RUN}${ECHO} " ${opt}: on," >> ${.TARGET}
.  endfor
.  for opt in ${PKG_DESELECTED_OPTIONS}
	${RUN}${ECHO} " ${opt}: off," >> ${.TARGET}
.  endfor
.endif
	${RUN}${ECHO} "}" >> ${.TARGET}


######################################################################
### _pkgformat-generate-metadata (PRIVATE)
######################################################################
### _pkgformat-generate-metadata is a convenience target for generating
### all of the pkgsrc binary package meta-data files.  It populates
### ${PKG_DB_TMPDIR} with the following files:
###
###	+MANIFEST
###	+DESC
###	+DISPLAY
###
### See the targets above for descriptions of each of those files.
###
.PHONY: _pkgformat-generate-metadata
_pkgformat-generate-metadata: ${_MANIFEST_FILE}

######################################################################
### _pkgformat-clean-metadata (PRIVATE)
######################################################################
### _pkgformat-clean-metadata is a convenience target for removing the
### package meta-data files.  This is essentially the reverse action
### of _pkgformat-generate-metadata.
###
.PHONY: _pkgformat-clean-metadata
_pkgformat-clean-metadata:
	${RUN}${RM} -f ${_MANIFEST_TARGETS} ${_MANIFEST_FILE}
