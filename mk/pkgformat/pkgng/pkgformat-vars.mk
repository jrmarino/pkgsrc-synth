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

.if defined(PKG_PRESERVE)
USE_TOOLS+=	date
.endif

# This is the package database directory for the default view.
PKG_DBDIR?=		/var/db/pkgng

# _PKG_DBDIR is the actual packages database directory where we register
# packages.
#
_PKG_DBDIR=		${_CROSS_DESTDIR}${PKG_DBDIR}
_HOST_PKG_DBDIR=	${HOST_PKG_DBDIR:U${PKG_DBDIR}}

PKG_CMD?=		${PKG_TOOLS_BIN}/pkg
PKG_ADD_CMD?=		${PKG_CMD} add
PKG_ADMIN_CMD?=		false
PKG_CREATE_CMD?=	${PKG_CMD} create
PKG_DELETE_CMD?=	${PKG_CMD} delete
PKG_INFO_CMD?=		${PKG_CMD} info
LINKFARM_CMD?=		${PKG_TOOLS_BIN}/linkfarm

# Latest versions of tools required for correct pkgsrc operation.
.if make(replace) && ${_USE_DESTDIR} != "no"
PKGTOOLS_REQD=		20100914
.else
PKGTOOLS_REQD=		20090528
.endif

# Latest version of pkg_install required to extract packages
PKGTOOLS_VERSION_REQD=	20091115

.if !defined(PKGTOOLS_VERSION)
PKGTOOLS_VERSION!=	${PKG_INFO_CMD} -V 2>/dev/null || echo 20010302
MAKEFLAGS+=		PKGTOOLS_VERSION=${PKGTOOLS_VERSION}
.endif

# Check that we are using up-to-date pkg_* tools with this file.
.if !defined(NO_PKGTOOLS_REQD_CHECK) && ${PKGTOOLS_VERSION} < ${PKGTOOLS_REQD}
BOOTSTRAP_DEPENDS+=	pkg_install>=${PKGTOOLS_REQD}:../../pkgtools/pkg_install
_PKG_INSTALL_DEPENDS=	yes
.endif

AUDIT_PACKAGES?=	${PKG_ADMIN}
_AUDIT_PACKAGES_CMD?=	audit-pkg
_EXTRACT_PKGVULNDIR=	${PKG_ADMIN} config-var PKGVULNDIR
DOWNLOAD_VULN_LIST?=	${PKG_ADMIN} fetch-pkg-vulnerabilities
_AUDIT_CONFIG_FILE=	pkg_install.conf
_AUDIT_CONFIG_OPTION=	IGNORE_URL

# The binary pkg_install tools all need to consistently refer to the
# correct package database directory.
#
PKGTOOLS_ARGS?=		#-K ${_PKG_DBDIR}
SET_DBDIR?=		${PKGSRC_SETENV} PKG_DBDIR="${_PKG_DBDIR}" \
			INSTALL_AS_USER=yes
HOST_SET_DBDIR?=	${PKGSRC_SETENV} PKG_DBDIR="${_HOST_PKG_DBDIR}" \
			INSTALL_AS_USER=yes

PKG_ADD?=	${SET_DBDIR} ${PKG_ADD_CMD}
PKG_ADMIN?=	${PKG_ADMIN_CMD} # unsupported
PKG_CREATE?=	${SET_DBDIR} ${PKG_CREATE_CMD}
PKG_DELETE?=	${SET_DBDIR} ${PKG_DELETE_CMD}
PKG_INFO?=	${SET_DBDIR} ${PKG_INFO_CMD}
LINKFARM?=	${LINKFARM_CMD}

HOST_PKG_ADD?=		${HOST_SET_DBDIR} ${PKG_ADD_CMD}
HOST_PKG_ADMIN?=	${PKG_ADMIN_CMD} # unsupported
HOST_PKG_CREATE?=	${HOST_SET_DBDIR} ${PKG_CREATE_CMD}
HOST_PKG_DELETE?=	${HOST_SET_DBDIR} ${PKG_DELETE_CMD}
HOST_PKG_INFO?=		${HOST_SET_DBDIR} ${PKG_INFO_CMD}
HOST_LINKFARM?=		${LINKFARM_CMD}

# "${_PKG_BEST_EXISTS} pkgpattern" prints out the name of the installed
# package that best matches pkgpattern.  Use this instead of
# "${PKG_INFO} -e pkgpattern" if the latter would return more than one
# package name.
#
_PKG_BEST_EXISTS?=	${PKG_INFO} -Eg
_HOST_PKG_BEST_EXISTS?=	${HOST_PKG_INFO} -Eg

# XXX Leave this here until all uses of this have been purged from the
# XXX public parts of pkgsrc.
# XXX
PKG_BEST_EXISTS=	${_PKG_BEST_EXISTS}
