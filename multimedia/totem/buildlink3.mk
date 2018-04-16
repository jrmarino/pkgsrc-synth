# $NetBSD: buildlink3.mk,v 1.40 2018/04/16 14:33:54 wiz Exp $

BUILDLINK_TREE+=	totem

.if !defined(TOTEM_BUILDLINK3_MK)
TOTEM_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.totem+=	{totem,totem-xine}>=1.4.0
BUILDLINK_ABI_DEPENDS.totem+=	totem>=2.32.0nb46
BUILDLINK_PKGSRCDIR.totem?=	../../multimedia/totem

.include "../../textproc/libxml2/buildlink3.mk"
.include "../../x11/gtk2/buildlink3.mk"
.endif # TOTEM_BUILDLINK3_MK

BUILDLINK_TREE+=	-totem
