# $NetBSD: buildlink3.mk,v 1.12 2018/03/12 11:15:32 wiz Exp $

BUILDLINK_TREE+=	libchamplain012

.if !defined(LIBCHAMPLAIN012_BUILDLINK3_MK)
LIBCHAMPLAIN012_BUILDLINK3_MK:=

BUILDLINK_ABI_DEPENDS.libchamplain012+=	libchamplain012>=0.12.10nb13
BUILDLINK_API_DEPENDS.libchamplain012+=	libchamplain012>=0.12.9
BUILDLINK_PKGSRCDIR.libchamplain012?=	../../geography/libchamplain012

.include "../../databases/sqlite3/buildlink3.mk"
.include "../../devel/glib2/buildlink3.mk"
.include "../../geography/libmemphis02/buildlink3.mk"
.include "../../graphics/clutter/buildlink3.mk"
.include "../../graphics/clutter-gtk/buildlink3.mk"
.include "../../net/libsoup/buildlink3.mk"
.include "../../x11/gtk3/buildlink3.mk"
.endif	# LIBCHAMPLAIN012_BUILDLINK3_MK

BUILDLINK_TREE+=	-libchamplain012
