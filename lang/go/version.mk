# $NetBSD: version.mk,v 1.38 2018/06/12 17:37:59 bsiegert Exp $

SSP_SUPPORTED=	no

.include "../../mk/bsd.prefs.mk"

GO_VERSION=	1.10.3
GO14_VERSION=	1.4.3

ONLY_FOR_PLATFORM=	*-*-i386 *-*-x86_64 *-*-earmv[67]hf
NOT_FOR_PLATFORM=	SunOS-*-i386
.if ${MACHINE_ARCH} == "i386"
GOARCH=		386
GOCHAR=		8
.elif ${MACHINE_ARCH} == "x86_64"
GOARCH=		amd64
GOCHAR=		6
.elif ${MACHINE_ARCH} == "earmv6hf" || ${MACHINE_ARCH} == "earmv7hf"
GOARCH=		arm
GOCHAR=		5
.endif
.if ${MACHINE_ARCH} == "earmv6hf"
GOOPT=		GOARM=6
.elif ${MACHINE_ARCH} == "earmv7hf"
GOOPT=		GOARM=7
.endif
PLIST_SUBST+=	GO_PLATFORM=${LOWER_OPSYS:Q}_${GOARCH:Q} GOARCH=${GOARCH:Q}
PLIST_SUBST+=	GOCHAR=${GOCHAR:Q}
