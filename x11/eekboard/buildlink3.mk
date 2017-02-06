# $NetBSD: buildlink3.mk,v 1.28 2017/02/06 13:54:52 wiz Exp $
#

BUILDLINK_TREE+=	eekboard

.if !defined(EEKBOARD_BUILDLINK3_MK)
EEKBOARD_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.eekboard+=	eekboard>=1.0.6
BUILDLINK_ABI_DEPENDS.eekboard?=	eekboard>=1.0.8nb10
BUILDLINK_PKGSRCDIR.eekboard?=	../../x11/eekboard

.include "../../devel/glib2/buildlink3.mk"
.include "../../devel/pango/buildlink3.mk"
.include "../../textproc/libcroco/buildlink3.mk"
.include "../../x11/gtk3/buildlink3.mk"
.include "../../x11/libxklavier/buildlink3.mk"
.endif	# EEKBOARD_BUILDLINK3_MK

BUILDLINK_TREE+=	-eekboard
