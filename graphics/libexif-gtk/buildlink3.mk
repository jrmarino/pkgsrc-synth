# $NetBSD: buildlink3.mk,v 1.36 2018/04/16 14:33:51 wiz Exp $
#
# This file was created automatically using createbuildlink-3.4.

BUILDLINK_TREE+=	libexif-gtk

.if !defined(LIBEXIF_GTK_BUILDLINK3_MK)
LIBEXIF_GTK_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libexif-gtk+=	libexif-gtk>=0.3.3nb7
BUILDLINK_ABI_DEPENDS.libexif-gtk+=	libexif-gtk>=0.3.5nb30
BUILDLINK_PKGSRCDIR.libexif-gtk?=	../../graphics/libexif-gtk

.include "../../devel/gettext-lib/buildlink3.mk"
.include "../../graphics/libexif/buildlink3.mk"
.include "../../x11/gtk2/buildlink3.mk"
.endif # LIBEXIF_GTK_BUILDLINK3_MK

BUILDLINK_TREE+=	-libexif-gtk
