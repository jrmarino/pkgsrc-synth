# $NetBSD: buildlink3.mk,v 1.3 2018/04/25 05:51:20 markd Exp $

BUILDLINK_TREE+=	libical

.if !defined(LIBICAL_BUILDLINK3_MK)
LIBICAL_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libical+=	libical>=0.42
BUILDLINK_ABI_DEPENDS.libical+=	libical>=3.0.3
BUILDLINK_PKGSRCDIR.libical?=	../../time/libical

.include "../../textproc/icu/buildlink3.mk"
.endif # LIBICAL_BUILDLINK3_MK

BUILDLINK_TREE+=	-libical
