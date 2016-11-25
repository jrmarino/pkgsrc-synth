# $NetBSD: bsd.pkginstall.mk,v 1.69 2016/06/17 08:53:42 jaapb Exp $
#
# This Makefile fragment is included by bsd.pkg.mk and implements the
# common INSTALL/DEINSTALL scripts framework.  To use the pkginstall
# framework, simply set the relevant variables to customize the install
# scripts to the package.
#
_VARGROUPS+=		pkginstall
_PKG_VARS.pkginstall= \
	PKG_USERS PKG_GROUPS USERGROUP_PHASE
.for u in ${PKG_USERS}
_PKG_VARS.pkginstall+=	PKG_UID.${u} PKG_GECOS.${u} PKG_HOME.${u} PKG_SHELL.${u}
.endfor
.for g in ${PKG_GROUPS}
_PKG_VARS.pkginstall+=	PKG_GID.${g}
.endfor
_SYS_VARS.pkginstall= \
	SETUID_ROOT_PERMS \
	SETGID_GAMES_PERMS

# XXX This should not be duplicated from the install module, but we
# XXX need this until pkginstall is refactored.
# XXX
PKG_DB_TMPDIR?=		${WRKDIR}/.pkgdb

# Set info dependency when INFO files are installed
.if defined (INFO_FILES)
USE_TOOLS+=	indexinfo:run
.endif

# If INSTALL template file exists in the PKGDIR directory, the +INSTALL
# script will be created.  Likewise, the presence of a DEINSTALL template
# file in the PKGDIR directory leads to the creation of the +DEINSTALL
# script for pkg(8).
#
_HEADER_TMPL=		${.CURDIR}/../../mk/pkginstall/header-pkgng
_FOOTER_TMPL=		${.CURDIR}/../../mk/pkginstall/footer
DEINSTALL_FILE=		# none
INSTALL_FILE=		# none

.if exists(${PKGDIR}/DEINSTALL)
DEINSTALL_FILE=		${PKG_DB_TMPDIR}/+DEINSTALL
DEINSTALL_TEMPLATES=	${PKGDIR}/DEINSTALL
.endif

.if exists(${PKGDIR}/INSTALL)
INSTALL_FILE=		${PKG_DB_TMPDIR}/+INSTALL
INSTALL_TEMPLATES=	${PKGDIR}/INSTALL
.endif

# These are the list of source files that are concatenated to form the
# INSTALL/DEINSTALL scripts.
#
DEINSTALL_SRC=		${_HEADER_TMPL}		\
			${DEINSTALL_TEMPLATES}	\
			${_FOOTER_TMPL}
INSTALL_SRC=		${_HEADER_TMPL}		\
			${INSTALL_TEMPLATES}	\
			${_FOOTER_TMPL}


# PKG_USERS represents the users to create for the package.  It is a
#	space-separated list of elements of the form
#
#		user:group
#
# The following variables are optional and specify further details of
# the user accounts listed in PKG_USERS:
#
# PKG_UID.<user> is the hardcoded numeric UID for <user>.
# PKG_GECOS.<user> is <user>'s description, as well as contact info.
# PKG_HOME.<user> is the home directory for <user>.
# PKG_SHELL.<user> is the login shell for <user>.
#
#
# PKG_GROUPS represents the groups to create for the package.  It is a
#	space-separated list of elements of the form
#
#		group
#
# The following variables are optional and specify further details of
# the user accounts listed in PKG_GROUPS:
#
# PKG_GID.<group> is the hardcoded numeric GID for <group>.
#
# For example:
#
#	PKG_GROUPS+=	mail
#	PKG_USERS+=	courier:mail
#
#	PKG_GECOS.courier=	Courier authlib and mail user
#
# USERGROUP_PHASE is set to the phase just before which users and
#	groups need to be created.  Valid values are "configure" and
#	"build".  In this case, the variables PKG_UID.<user> and
#	PKG_GID.<group> must be defined, otherwise a FAIL due to SKIP
#	is defined.
#
PKG_GROUPS?=		# empty
PKG_USERS?=		# empty
_PKG_USER_HOME?=	/nonexistent
_PKG_USER_SHELL?=	${NOLOGIN}
_UG_INSTALL=		${PKG_DB_TMPDIR}/+PRE_INSTALL
_UG_DEINSTALL=		${PKG_DB_TMPDIR}/+POST_DEINSTALL

USE_GAMESGROUP?=	no
SETGIDGAME?=            ${USE_GAMESGROUP}
# If USE_GAMESGROUP == yes, then we need the "games" group.
# SETGIDGAME is a deprecated alias for USE_GAMESGROUP.
#
# If USE_GAMESGROUP is set, GAMES_GROUP, GAMEMODE, SETGID_GAMES_PERMS,
# etc. variables can be used to install setgid games and their data
# files.
#
# SETGIDGAME is a deprecated alternative variable with the same
# purpose but a murky history and unclear semantics; it is being
# phased out because it conflicts with a like-named build variable in
# the NetBSD base system.
#
# For now we also create the "games" user; this should not be used and
# should be removed at some point.
.if (defined(USE_GAMESGROUP) && !empty(USE_GAMESGROUP:tl:Myes)) ||\
    (defined(SETGIDGAME) && !empty(SETGIDGAME:tl:Myes))
PKG_GROUPS+=	${GAMES_GROUP}
PKG_USERS+=	${GAMES_USER}:${GAMES_GROUP}
_BUILD_DEFS+=	GAMES_GROUP GAMES_USER GAMEDATAMODE GAMEDIRMODE GAMEMODE
.endif

# predefined accounts from src/etc/master.passwd
# alpha numeric sort order
USERS_BLACKLIST=	_dhcp _pflogd _ypldap auditdistd bin bind daemon \
			games hast kmem mailnull man news nobody operator \
			pop proxy root smmsp sshd toor tty unbound uucp www

# predefined accounts from src/etc/group
# alpha numeric sort order
GROUPS_BLACKLIST=	_dhcp _pflogd _ypldap audit authpf bin bind daemon \
			dialer ftp games guest hast kmem mail mailnull man \
			network news nobody nogroup operator proxy smmsp \
			sshd staff sys tty unbound uucp wheel www

.if defined(USERGROUP_PHASE) && (${USERGROUP_PHASE:Mconfigure} || ${USERGROUP_PHASE:Mbuild})
. for _entry_ in ${PKG_USERS}
PGE=PKG_GID.${_entry_:C|^.+:||}
PUE=PKG_UID.${_entry_:C|:.*||}
.  if !defined(${PGE}) || !defined(${PUE})
PKG_SKIP_REASON+=	"Because USERGROUP_PHASE is set 'configure', the\
	${PUE} and ${PGE} variables must be defined by the user"
.  endif
. endfor
.endif

.for _entry_ in ${PKG_USERS:u}
usr=${_entry_:C|:.*||}
grp=${_entry_:C|^.+:||}
.if defined(PKG_GID.${grp})
PGE=${PKG_GID.${grp}}
.else
PGE=${grp}
.endif
PUE=${PKG_UID.${usr}}
_P4=${PKG_GECOS.${usr}:Q:S|\ |~|g}
_P5=${PKG_HOME.${usr}:Q:S|\ |~|g}
_P6=${PKG_SHELL.${usr}:Q:S|\ |~|g}
_PKG_USERS+=	${usr}:${PGE}:${PUE}:${_P4}:${_P5}:${_P6}:
.endfor

pre-install: create-usergroup

.PHONY: create-usergroup
create-usergroup: su-target
	@${STEP_MSG} "Requiring users and groups for ${PKGNAME}"

.PHONY: su-create-usergroup
su-create-usergroup: ${PKGDIR:H:H}/mk/scripts/do-users-groups
	@${SETENV} \
		dp_ECHO_MSG="${ECHO_MSG}" \
		dp_GROUPS_BLACKLIST="${GROUPS_BLACKLIST}" \
		dp_USERS_BLACKLIST="${USERS_BLACKLIST}" \
		dp_OPSYS="${OPSYS}" \
		dp_UG_DEINSTALL="${_UG_DEINSTALL}" \
		dp_UG_INSTALL="${_UG_INSTALL}" \
		dp_DFLT_SHELL="${_PKG_USER_SHELL}" \
		dp_DFLT_HOME="${_PKG_USER_HOME}" \
		${SH} ${.ALLSRC} "${_PKG_USERS}" "${PKG_GROUPS:u}"

# SPECIAL_PERMS are lists that look like:
#		file user group mode
#	At post-install time, <file> (it may be a directory) is changed
#	to be owned by <user>:<group> with <mode> permissions.  If a file
#	pathname is relative, then it is taken to be relative to ${PREFIX}.
#
#	SPECIAL_PERMS should be used primarily to change permissions of
#	files or directories listed in the PLIST.  This may be used to
#	make certain files set-uid or to change the ownership or a
#	directory.
#
#	The special permissions may not directly recorded (as file
#	attributes) in the binary package file.
#
# SETUID_ROOT_PERMS is a convenience definition to note an executable is
# meant to be setuid-root, and should be used as follows:
#
#	SPECIAL_PERMS+=	/path/to/suidroot ${SETUID_ROOT_PERMS}
#
# SETGID_GAMES_PERMS is a convenience definition to note an executable is
# meant to be setgid games, and should be used as follows:
#
#	SPECIAL_PERMS+=	/path/to/sgidgame ${SETGID_GAMES_PERMS}
#
# GAMEDATA_PERMS and GAMEDIR_PERMS are convenience definitions for files
# that are meant to be accessed by things that are setgid games. Because
# such files should normally be under ${VARBASE}, generally these 
# definitions should be used roughly as follows:
#
#	REQD_DIRS_PERMS+=  /path/to/scoredir ${GAMEDIR_PERMS}
#	REQD_FILES_PERMS+= /dev/null /path/to/scorefile ${GAMEDATA_PERMS}
#
# Note that GAMEDIR_PERMS should only be used when the game requires
# write access to scribble in its directory; many games do not, in which
# case REQD_DIRS instead of REQD_DIRS_PERMS can be used and GAMEDIR_PERMS
# is not needed.
#
# Keywords: setuid setgid st_mode perms
#
SPECIAL_PERMS?=		# empty
SETUID_ROOT_PERMS?=	${REAL_ROOT_USER} ${REAL_ROOT_GROUP} 4511
SETGID_GAMES_PERMS?=	${GAMES_USER} ${GAMES_GROUP} ${GAMEMODE}
GAMEDATA_PERMS?=	${GAMES_USER} ${GAMES_GROUP} ${GAMEDATAMODE}
GAMEDIR_PERMS?=		${GAMES_USER} ${GAMES_GROUP} ${GAMEDIRMODE}

# CONF_FILES
# REQD_FILES
#	Pairs of example and true config files, used much like MLINKS in
#	the NetBSD base system.  At post-install time, if the true config
#	file doesn't exist, then the example one is copied into place.  At
#	deinstall time, the true one is removed if it doesn't differ from the
#	example one.  REQD_FILES is the same as CONF_FILES but the value
#	of PKG_CONFIG is ignored.
#
#	However, all files listed in REQD_FILES should be under ${PREFIX}.
#	(XXX: Why?)
#
# CONF_FILES_MODE and REQD_FILES_MODE are the file permissions for the
# files in CONF_FILES and REQD_FILES, respectively.
#
# CONF_FILES_PERMS
# REQD_FILES_PERMS
#	Lists that look like:
#
#		example_file config_file user group mode
#
#	This works like CONF_FILES and REQD_FILES, except that the config
#	files are owned by user:group and have mode permissions.
#	REQD_FILES_PERMS is the same as CONF_FILES_PERMS but the value of
#	PKG_CONFIG is ignored;
#
#	However, all files listed in REQD_FILES_PERMS should be under
#	${PREFIX}. (XXX: Why?)
#
# RCD_SCRIPTS lists the basenames of the rc.d scripts.  They are
#	expected to be found in ${PREFIX}/share/examples/rc.d, and
#	the scripts will be copied into ${RCD_SCRIPTS_DIR} with
#	${RCD_SCRIPTS_MODE} permissions.
#
# If any file pathnames are relative, then they are taken to be relative
# to ${PREFIX}.
#
# Keywords: etc conf configuration
#

CONF_FILES?=		# empty
CONF_FILES_MODE?=	0644
CONF_FILES_PERMS?=	# empty
RCD_SCRIPTS?=		# empty
RCD_SCRIPTS_MODE?=	0755
RCD_SCRIPTS_EXAMPLEDIR=	share/examples/rc.d
RCD_SCRIPTS_SHELL?=	${SH}

# Only generate init scripts if we are using rc.d
_INSTALL_RCD_SCRIPTS=	# empty

.if ${INIT_SYSTEM} == "rc.d"
_INSTALL_RCD_SCRIPTS=	${RCD_SCRIPTS}
.endif

# PKG_SHELL contains the pathname of the shell that should be added or
#	removed from the shell database, /etc/shells.  If a pathname
#	is relative, then it is taken to be relative to ${PREFIX}.
#
PKG_SHELL?=		# empty

# PKGNG only supports ELF format, so there's no need to test library type
# Set the @ldconfig configure if port provided RUN_LDCONFIG setting

SHLIB_TYPE=	ELF
RUN_LDCONFIG?=	no

.if !empty(RUN_LDCONFIG:tl:Myes)
SET_LDCONFIG_KEYWORD=	yes
.endif

# FONTS_DIRS.<type> are lists of directories in which the font databases
#	are updated.  If this is non-empty, then the appropriate tools are
#	used to update the fonts database for the font type.  The supported
#	types are:
#
#	    ttf		TrueType fonts
#	    type1	Type1 fonts
#	    x11		Generic X fonts, e.g. PCF, SNF, BDF, etc.
#
FONTS_DIRS.ttf?=	# empty
FONTS_DIRS.type1?=	# empty
FONTS_DIRS.x11?=	# empty

.if !empty(FONTS_DIRS.ttf:M*)
.if ${X11_TYPE} == "modular"
USE_TOOLS+=		mkfontscale:run
.else
USE_TOOLS+=		ttmkfdir:run
.endif
.endif

.if !empty(FONTS_DIRS.type1:M*)
.if ${X11_TYPE} == "modular"
USE_TOOLS+=		mkfontscale:run
.else
USE_TOOLS+=		type1inst:run
.endif
.endif

.if !empty(FONTS_DIRS.x11:M*) || !empty(FONTS_DIRS.ttf:M*) || !empty(FONTS_DIRS.type1:M*)
USE_TOOLS+=		mkfontdir:run
.if ${X11_TYPE} == "modular"
DEPENDS+=		encodings-[0-9]*:../../fonts/encodings
.endif
.endif

# Awk command to tailor commands based on script requirements

TAILOR_COMMAND=	${AWK} -f ${PKGDIR:H:H}/mk/scripts/commands_needed.awk \
		-vAWK="${AWK}" \
		-vBASENAME="${BASENAME}" \
		-vCAT="${CAT}" \
		-vCHGRP="${CHGRP}" \
		-vCHMOD="${CHMOD}" \
		-vCHOWN="${CHOWN}" \
		-vCMP="${CMP}" \
		-vCP="${CP}" \
		-vDIRNAME="${DIRNAME}" \
		-vECHO="${ECHO}" \
		-vECHO_N="${ECHO_N}" \
		-vEGREP="${EGREP}" \
		-vEXPR="${EXPR}" \
		-vFALSE="${FALSE}" \
		-vFIND="${FIND}" \
		-vGREP="${GREP}" \
		-vHEAD="${HEAD}" \
		-vID="${ID}" \
		-vLN="${LN}" \
		-vLS="${LS}" \
		-vMKDIR="${MKDIR}" \
		-vMV="${MV}" \
		-vPERL5="${PERL5}" \
		-vPKG_ADMIN="${PKG_ADMIN_CMD}" \
		-vPKG_INFO="${PKG_INFO_CMD}" \
		-vPW="${PW}" \
		-vPWD_CMD="${PWD_CMD}" \
		-vRM="${RM}" \
		-vRMDIR="${RMDIR}" \
		-vSED="${SED}" \
		-vSETENV="${SETENV}" \
		-vSH="${SH}" \
		-vSORT="${SORT}" \
		-vSU="${SU}" \
		-vTEST="${TEST}" \
		-vTOUCH="${TOUCH}" \
		-vTR="${TR}" \
		-vTRUE="${TRUE}" \
		-vXARGS="${XARGS} " \
		-vPREFIX="${PREFIX}" \
		-vLOCALBASE="${LOCALBASE}" \
		-vX11BASE="${X11BASE}" \
		-vVARBASE="${VARBASE}" \
		-vPKG_SYSCONFBASE="${PKG_SYSCONFBASE}" \
		-vPKG_SYSCONFBASEDIR="${PKG_SYSCONFBASEDIR}" \
		-vPKG_SYSCONFDIR="${PKG_SYSCONFDIR}" \
		-vPKGBASE="${PKGBASE}"

# We still need to support defaults and FILES_SUBST from the makefiles

FILES_SUBST+=		PREFIX=${PREFIX:Q}
FILES_SUBST+=		LOCALBASE=${LOCALBASE:Q}
FILES_SUBST+=		X11BASE=${X11BASE:Q}
FILES_SUBST+=		VARBASE=${VARBASE:Q}
FILES_SUBST+=		PKG_SYSCONFBASE=${PKG_SYSCONFBASE:Q}
FILES_SUBST+=		PKG_SYSCONFBASEDIR=${PKG_SYSCONFBASEDIR:Q}
FILES_SUBST+=		PKG_SYSCONFDIR=${PKG_SYSCONFDIR:Q}
FILES_SUBST+=		CONF_DEPENDS=${CONF_DEPENDS:C/:.*//:Q}
FILES_SUBST+=		PKGBASE=${PKGBASE:Q}

FILES_SUBST_SED=	${FILES_SUBST:S/=/@!/:S/$/!g/:S/^/ -e s!@/}
CVSID_SED=		'/$$NetBSD/d'

.PHONY: generate-install-scripts
generate-install-scripts: ${DEINSTALL_FILE} ${INSTALL_FILE}

${DEINSTALL_FILE}: ${DEINSTALL_SRC}
	${RUN}${MKDIR} ${.TARGET:H}
	${RUN}${CAT} ${_HEADER_TMPL} > ${.TARGET}
	${RUN}${TAILOR_COMMAND} ${DEINSTALL_TEMPLATES} >> ${.TARGET}
	${RUN}${SED} ${FILES_SUBST_SED} ${DEINSTALL_TEMPLATES} >> ${.TARGET}
	${RUN}${SED} ${CVSID_SED} ${_FOOTER_TMPL} >> ${.TARGET}
	${RUN}${CHMOD} +x ${.TARGET}

${INSTALL_FILE}: ${INSTALL_SRC}
	${RUN}${MKDIR} ${.TARGET:H}
	${RUN}${CAT} ${_HEADER_TMPL} > ${.TARGET}
	${RUN}${TAILOR_COMMAND} ${INSTALL_TEMPLATES} >> ${.TARGET}
	${RUN}${SED} ${FILES_SUBST_SED} ${INSTALL_TEMPLATES} >> ${.TARGET}
	${RUN}${SED} ${CVSID_SED} ${_FOOTER_TMPL} >> ${.TARGET}
	${RUN}${CHMOD} +x ${.TARGET}

# rc.d scripts are automatically generated and installed into the rc.d
# scripts example directory at the post-install step.  The following
# variables are relevant to this process:
#
# RCD_SCRIPTS			lists the basenames of the rc.d scripts
#
# RCD_SCRIPT_SRC.<script>	the source file for <script>; this will
#				be run through commands_needed awk script
#                               to generate the rc.d script (defaults to
#				${FILESDIR}/<script>.sh)
#
# If the source rc.d script is not present, then the automatic handling
# doesn't occur.

.PHONY: generate-rcd-scripts
generate-rcd-scripts:	# do nothing

.PHONY: install-rcd-scripts
post-install: install-rcd-scripts
install-rcd-scripts:	# do nothing

.for _script_ in ${_INSTALL_RCD_SCRIPTS}
RCD_SCRIPT_SRC.${_script_}?=	${FILESDIR}/${_script_}.sh
RCD_SCRIPT_WRK.${_script_}?=	${WRKDIR}/.rc.d/${_script_}

.  if !empty(RCD_SCRIPT_SRC.${_script_})
generate-rcd-scripts: ${RCD_SCRIPT_WRK.${_script_}}
${RCD_SCRIPT_WRK.${_script_}}: ${RCD_SCRIPT_SRC.${_script_}}
	@${STEP_MSG} "Creating ${.TARGET}"
	${RUN}${MKDIR} ${.TARGET:H}
	${RUN}${CAT} ${.ALLSRC} | ${SED} ${FILES_SUBST_SED} | \
		${TAILOR_COMMAND} -vMODE="replace" > ${.TARGET}
	${RUN}${CHMOD} +x ${.TARGET}

install-rcd-scripts: install-rcd-${_script_}
install-rcd-${_script_}: ${RCD_SCRIPT_WRK.${_script_}}
	${RUN}								\
	if [ -f ${RCD_SCRIPT_WRK.${_script_}} ]; then			\
		${MKDIR} ${DESTDIR}${PREFIX}/${RCD_SCRIPTS_EXAMPLEDIR};		\
		${INSTALL_SCRIPT} ${RCD_SCRIPT_WRK.${_script_}}		\
			${DESTDIR}${PREFIX}/${RCD_SCRIPTS_EXAMPLEDIR}/${_script_}; \
	fi
.  endif
GENERATE_PLIST+=	${ECHO} ${RCD_SCRIPTS_EXAMPLEDIR}/${_script_};
PRINT_PLIST_AWK+=	/^${RCD_SCRIPTS_EXAMPLEDIR:S|/|\\/|g}\/${_script_}/ { next; }
.endfor

_PKGINSTALL_TARGETS+=	acquire-pkginstall-lock
_PKGINSTALL_TARGETS+=	real-pkginstall
_PKGINSTALL_TARGETS+=	release-pkginstall-lock

.PHONY: pkginstall install-script-data
pkginstall: ${_PKGINSTALL_TARGETS}

install-script-data:	# do nothing

.PHONY: acquire-pkginstall-lock release-pkginstall-lock
acquire-pkginstall-lock: acquire-lock
release-pkginstall-lock: release-lock

.PHONY: real-pkginstall
real-pkginstall: generate-rcd-scripts generate-install-scripts
