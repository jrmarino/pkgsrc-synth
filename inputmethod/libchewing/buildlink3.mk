# $NetBSD: buildlink3.mk,v 1.13 2017/04/22 21:03:12 adam Exp $

BUILDLINK_TREE+=	libchewing

.if !defined(LIBCHEWING_BUILDLINK3_MK)
LIBCHEWING_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libchewing+=		libchewing>=0.3.2
BUILDLINK_ABI_DEPENDS.libchewing+=	libchewing>=0.4.0nb6
BUILDLINK_PKGSRCDIR.libchewing?=	../../inputmethod/libchewing

.include "../../databases/sqlite3/buildlink3.mk"
.endif # LIBCHEWING_BUILDLINK3_MK

BUILDLINK_TREE+=	-libchewing
