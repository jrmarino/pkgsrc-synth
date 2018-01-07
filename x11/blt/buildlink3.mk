# $NetBSD: buildlink3.mk,v 1.18 2018/01/07 13:04:37 rillig Exp $

BUILDLINK_TREE+=	blt

.if !defined(BLT_BUILDLINK3_MK)
BLT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.blt+=	blt>=2.4z
BUILDLINK_ABI_DEPENDS.blt+=	blt>=2.4znb7
BUILDLINK_PKGSRCDIR.blt?=	../../x11/blt

.include "../../lang/tcl/buildlink3.mk"
.include "../../x11/tk/buildlink3.mk"
.endif # BLT_BUILDLINK3_MK

BUILDLINK_TREE+=	-blt
