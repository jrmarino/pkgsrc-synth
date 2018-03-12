# $NetBSD: buildlink3.mk,v 1.63 2018/03/12 11:15:49 wiz Exp $

BUILDLINK_TREE+=	gnome-desktop-sharp

.if !defined(GNOME_DESKTOP_SHARP_BUILDLINK3_MK)
GNOME_DESKTOP_SHARP_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.gnome-desktop-sharp+=	gnome-desktop-sharp>=2.24.0
BUILDLINK_ABI_DEPENDS.gnome-desktop-sharp+=	gnome-desktop-sharp>=2.26.0nb67
BUILDLINK_PKGSRCDIR.gnome-desktop-sharp?=	../../x11/gnome-desktop-sharp

.include "../../devel/libwnck/buildlink3.mk"
.include "../../graphics/librsvg/buildlink3.mk"
.include "../../print/libgnomeprint/buildlink3.mk"
.include "../../print/libgnomeprintui/buildlink3.mk"
.include "../../www/gtkhtml314/buildlink3.mk"
.include "../../x11/gnome-panel/buildlink3.mk"
.include "../../x11/gnome-sharp/buildlink3.mk"
.include "../../x11/gtk-sharp/buildlink3.mk"
.include "../../x11/gtksourceview2/buildlink3.mk"
.include "../../x11/vte/buildlink3.mk"
.endif # GNOME_DESKTOP_SHARP_BUILDLINK3_MK

BUILDLINK_TREE+=	-gnome-desktop-sharp
