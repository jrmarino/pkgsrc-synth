# $NetBSD: Makefile,v 1.26 2015/11/25 12:52:11 jperkin Exp $
#

DISTNAME=		djbdns-run-20141207
CATEGORIES=		net
MASTER_SITES=		# empty
DISTFILES=		# empty

MAINTAINER=		schmonz@NetBSD.org
COMMENT=		Configures djbdns to cache and serve queries
LICENSE=		2-clause-bsd

DEPENDS_DJBDNS=		djbdns>=1.05nb5:../../net/djbdns
DEPENDS+=		${DEPENDS_DJBDNS}
DEPENDS+=		daemontools-[0-9]*:../../sysutils/daemontools
DEPENDS+=		ucspi-tcp-[0-9]*:../../net/ucspi-tcp

WRKSRC=			${WRKDIR}
NO_BUILD=		yes
NO_CHECKSUM=		yes

MAKE_DIRS+=		${PKG_SYSCONFDIR}/axfrdns
MAKE_DIRS+=		${PKG_SYSCONFDIR}/dnscache/ip
MAKE_DIRS+=		${PKG_SYSCONFDIR}/dnscache/servers
MAKE_DIRS+=		${PKG_SYSCONFDIR}/rbldns
MAKE_DIRS+=		${PKG_SYSCONFDIR}/tinydns
PKG_GROUPS=		djbdns
PKG_USERS+=		dnslog:djbdns
PKG_USERS+=		axfrdns:djbdns
PKG_USERS+=		dnscache:djbdns
PKG_USERS+=		rbldns:djbdns
PKG_USERS+=		tinydns:djbdns
RCD_SCRIPTS=		axfrdns djbdns dnscache rbldns tinydns
FILES_SUBST+=		PKGNAME=${PKGNAME:Q}

INSTALLATION_DIRS=	share/doc/djbdns-run

.include "../../mk/bsd.prefs.mk"

# Detect the PKG_SYSCONFDIR of the installed djbdns, so we can create
# config files there and refer to them from rc.d scripts.
#
.if !defined(PKG_SYSCONFDIR.djbdns-run)
PKG_SYSCONFDIR.djbdns-run!=						\
	${PKG_INFO} -Q PKG_SYSCONFDIR					\
		${DEPENDS_DJBDNS:C/:.*$//:Q} 2>/dev/null ||		\
	${ECHO} "PKG_SYSCONFDIR.djbdns-run_not_set"
.  if empty(PKG_SYSCONFDIR.djbdns-run:M*not_set)
MAKEVARS+=	PKG_SYSCONFDIR.djbdns-run
.  endif
.endif

do-install:
	${INSTALL_DATA} ${FILESDIR}/README.pkgsrc ${DESTDIR}${PREFIX}/share/doc/djbdns-run

.include "../../mk/bsd.pkg.mk"
