# $NetBSD: buildlink3.mk,v 1.3 2017/02/06 13:54:40 wiz Exp $

BUILDLINK_TREE+=	libappindicator

.if !defined(LIBAPPINDICATOR_BUILDLINK3_MK)
LIBAPPINDICATOR_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libappindicator+=	libappindicator>=12.10.0
BUILDLINK_ABI_DEPENDS.libappindicator?=	libappindicator>=12.10.0nb2
BUILDLINK_PKGSRCDIR.libappindicator?=	../../devel/libappindicator

.include "../../devel/libindicator/buildlink3.mk"
.include "../../devel/libdbusmenu-gtk/buildlink3.mk"
.include "../../devel/glib2/buildlink3.mk"
.include "../../x11/gtk2/buildlink3.mk"
.endif	# LIBAPPINDICATOR_BUILDLINK3_MK

BUILDLINK_TREE+=	-libappindicator
