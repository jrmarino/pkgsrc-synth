# $NetBSD: buildlink3.mk,v 1.10 2016/10/07 18:25:34 adam Exp $

BUILDLINK_TREE+=	edbus

.if !defined(EDBUS_BUILDLINK3_MK)
EDBUS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.edbus+=	edbus>=1.7.7
BUILDLINK_ABI_DEPENDS.edbus?=	edbus>=1.7.7nb3
BUILDLINK_PKGSRCDIR.edbus?=	../../sysutils/edbus

.include "../../devel/ecore/buildlink3.mk"
.include "../../sysutils/dbus/buildlink3.mk"
.include "../../sysutils/efreet/buildlink3.mk"
.endif # EDBUS_BUILDLINK3_MK

BUILDLINK_TREE+=	-edbus
