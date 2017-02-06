# $NetBSD: buildlink3.mk,v 1.3 2017/02/06 13:54:56 wiz Exp $
#

BUILDLINK_TREE+=	mate-desktop

.if !defined(MATE_DESKTOP_BUILDLINK3_MK)
MATE_DESKTOP_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.mate-desktop+=	mate-desktop>=1.14.0
BUILDLINK_ABI_DEPENDS.mate-desktop?=	mate-desktop>=1.14.1nb2
BUILDLINK_PKGSRCDIR.mate-desktop?=	../../x11/mate-desktop

.include "../../devel/dconf/buildlink3.mk"
.include "../../devel/glib2/buildlink3.mk"
.include "../../graphics/gdk-pixbuf2/buildlink3.mk"
.include "../../x11/gtk2/buildlink3.mk"
.include "../../x11/libX11/buildlink3.mk"
.include "../../x11/libXrandr/buildlink3.mk"
.include "../../x11/startup-notification/buildlink3.mk"
.endif	# MATE_DESKTOP_BUILDLINK3_MK

BUILDLINK_TREE+=	-mate-desktop
