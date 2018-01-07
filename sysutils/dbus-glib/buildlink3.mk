# $NetBSD: buildlink3.mk,v 1.17 2018/01/07 13:04:31 rillig Exp $

BUILDLINK_TREE+=	dbus-glib

.if !defined(DBUS_GLIB_BUILDLINK3_MK)
DBUS_GLIB_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.dbus-glib+=	dbus-glib>=0.61
BUILDLINK_ABI_DEPENDS.dbus-glib+=	dbus-glib>=0.100nb1
BUILDLINK_PKGSRCDIR.dbus-glib?=		../../sysutils/dbus-glib

.include "../../devel/glib2/buildlink3.mk"
.include "../../sysutils/dbus/buildlink3.mk"
.include "../../textproc/expat/buildlink3.mk"
.endif # DBUS_GLIB_BUILDLINK3_MK

BUILDLINK_TREE+=	-dbus-glib
