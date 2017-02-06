# $NetBSD: buildlink3.mk,v 1.20 2017/02/06 13:54:53 wiz Exp $

BUILDLINK_TREE+=	gnome-desktop3

.if !defined(GNOME_DESKTOP3_BUILDLINK3_MK)
GNOME_DESKTOP3_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.gnome-desktop3+=	gnome-desktop3>=3.4.2
BUILDLINK_ABI_DEPENDS.gnome-desktop3+=	gnome-desktop3>=3.20.1nb3
BUILDLINK_PKGSRCDIR.gnome-desktop3?=	../../x11/gnome-desktop3

.include "../../x11/gtk3/buildlink3.mk"
.include "../../x11/libxkbfile/buildlink3.mk"
.endif # GNOME_DESKTOP_BUILDLINK3_MK

BUILDLINK_TREE+=	-gnome-desktop3
