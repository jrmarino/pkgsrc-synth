# $NetBSD: buildlink3.mk,v 1.6 2018/03/12 11:15:52 wiz Exp $

BUILDLINK_TREE+=	keybinder

.if !defined(KEYBINDER_BUILDLINK3_MK)
KEYBINDER_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.keybinder+=	keybinder>=0.3.0
BUILDLINK_ABI_DEPENDS.keybinder?=	keybinder>=0.3.0nb4
BUILDLINK_PKGSRCDIR.keybinder?=		../../x11/keybinder

.include "../../devel/gobject-introspection/buildlink3.mk"
.include "../../x11/gtk2/buildlink3.mk"
.endif	# KEYBINDER_BUILDLINK3_MK

BUILDLINK_TREE+=	-keybinder
