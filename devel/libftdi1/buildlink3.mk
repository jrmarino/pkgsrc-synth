# $NetBSD: buildlink3.mk,v 1.3 2018/02/10 13:53:47 khorben Exp $

BUILDLINK_TREE+=	libftdi1

.if !defined(LIBFTDI1_BUILDLINK3_MK)
LIBFTDI1_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libftdi1+=	libftdi1>=1.0
BUILDLINK_PKGSRCDIR.libftdi1?=		../../devel/libftdi1

.include "../../mk/libusb.buildlink3.mk"
.endif	# LIBFTDI1_BUILDLINK3_MK

BUILDLINK_TREE+=	-libftdi1
