# $NetBSD: buildlink3.mk,v 1.81 2018/04/16 14:33:46 wiz Exp $

BUILDLINK_TREE+=	gnome-pilot

.if !defined(GNOME_PILOT_BUILDLINK3_MK)
GNOME_PILOT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.gnome-pilot+=	gnome-pilot>=2.0.12nb2
BUILDLINK_ABI_DEPENDS.gnome-pilot+=	gnome-pilot>=2.0.17nb65
BUILDLINK_PKGSRCDIR.gnome-pilot?=	../../comms/gnome-pilot

.include "../../devel/gettext-lib/buildlink3.mk"
.include "../../comms/pilot-link-libs/buildlink3.mk"
.include "../../devel/libglade/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.include "../../x11/gnome-panel/buildlink3.mk"
.endif # GNOME_PILOT_BUILDLINK3_MK

BUILDLINK_TREE+=	-gnome-pilot
