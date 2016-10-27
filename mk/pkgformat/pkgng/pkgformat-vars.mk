# $NetBSD$
#
# This Makefile fragment is included indirectly by bsd.prefs.mk and
# defines some variables which must be defined earlier than where
# pkgformat.mk is included.
#

PKGSRC_MESSAGE_RECIPIENTS?=	# empty

.if !empty(PKGSRC_MESSAGE_RECIPIENTS)
USE_TOOLS+=	mail
.endif

# _PKG_DBDIR is the actual packages database directory where we register
# packages.
#
_PKG_DBDIR=		${_CROSS_DESTDIR}${PKG_DBDIR}
_HOST_PKG_DBDIR=	${HOST_PKG_DBDIR:U${PKG_DBDIR}}

PKG_CMD?=		${PKG_TOOLS_BIN}/pkg
PKG_ADD_CMD?=		${PKG_CMD} add
PKG_CREATE_CMD?=	${PKG_CMD} create
PKG_DELETE_CMD?=	${PKG_CMD} delete
PKG_INFO_CMD?=		${PKG_CMD} info
PKG_AUDIT_CMD=		${PKG_CMD} audit

# This is the package database directory that pkg(8) is configured to use
PKG_DBDIR!=		${PKG_CMD} config PKG_DBDIR

# Hardcode PKGTOOLS_VERSION to latest at time of writing
PKGTOOLS_VERSION=	20160410

# The binary pkg_install tools all need to consistently refer to the
# correct package database directory.
#
SET_DBDIR?=		${PKGSRC_SETENV} PKG_DBDIR="${_PKG_DBDIR}" \
			INSTALL_AS_USER=yes
HOST_SET_DBDIR?=	${PKGSRC_SETENV} PKG_DBDIR="${_HOST_PKG_DBDIR}" \
			INSTALL_AS_USER=yes

PKG_ADD?=		${SET_DBDIR} ${PKG_ADD_CMD}
PKG_CREATE?=		${SET_DBDIR} ${PKG_CREATE_CMD}
PKG_DELETE?=		${SET_DBDIR} ${PKG_DELETE_CMD}
PKG_INFO?=		${SET_DBDIR} ${PKG_INFO_CMD}

HOST_PKG_INFO?=		${HOST_SET_DBDIR} ${PKG_INFO_CMD}

# "${_PKG_BEST_EXISTS} pkgpattern" prints out the name of the installed
# package that best matches pkgpattern.  Use this instead of
# "${PKG_INFO} -e pkgpattern" if the latter would return more than one
# package name.
#
_PKG_BEST_EXISTS?=	${PKG_INFO_CMD} --show-name-only --glob

# XXX Leave this here until all uses of this have been purged from the
# XXX public parts of pkgsrc.
# XXX
PKG_BEST_EXISTS=	${_PKG_BEST_EXISTS}
