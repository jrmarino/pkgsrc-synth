# $NetBSD: buildlink3.mk,v 1.4 2017/02/12 06:24:40 ryoon Exp $

BUILDLINK_TREE+=	libappindicator3

.if !defined(LIBAPPINDICATOR3_BUILDLINK3_MK)
LIBAPPINDICATOR3_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libappindicator3+=	libappindicator3>=12.10.0
BUILDLINK_ABI_DEPENDS.libappindicator3?=		libappindicator3>=12.10.0nb3
BUILDLINK_PKGSRCDIR.libappindicator3?=		../../devel/libappindicator3

.include "../../devel/libindicator3/buildlink3.mk"
.include "../../devel/libdbusmenu-gtk3/buildlink3.mk"
.include "../../x11/gtk3/buildlink3.mk"
.endif	# LIBAPPINDICATOR3_BUILDLINK3_MK

BUILDLINK_TREE+=	-libappindicator3
