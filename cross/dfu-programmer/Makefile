# $NetBSD: Makefile,v 1.6 2018/02/27 23:56:08 khorben Exp $
#

DISTNAME=	dfu-programmer-0.7.2
PKGREVISION=	1
CATEGORIES=	cross
MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=dfu-programmer/dfu-programmer/0.7.2/}

MAINTAINER=	jakllsch@NetBSD.org
HOMEPAGE=	http://dfu-programmer.sourceforge.net/
COMMENT=	Programmer for Atmel USB DFU Bootloader
LICENSE=	gnu-gpl-v2

GNU_CONFIGURE=	yes
CONFIGURE_ARGS+= --disable-libusb_1_0

.include "../../mk/libusb.buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
