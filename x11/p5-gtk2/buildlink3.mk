# $NetBSD: buildlink3.mk,v 1.30 2018/04/16 14:34:01 wiz Exp $

BUILDLINK_TREE+=	p5-gtk2

.if !defined(P5_GTK2_BUILDLINK3_MK)
P5_GTK2_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.p5-gtk2+=	p5-gtk2>=1.182
BUILDLINK_ABI_DEPENDS.p5-gtk2+=	p5-gtk2>=1.24992nb2
BUILDLINK_PKGSRCDIR.p5-gtk2?=	../../x11/p5-gtk2

.include "../../devel/p5-glib2/buildlink3.mk"
.include "../../graphics/p5-cairo/buildlink3.mk"
.include "../../devel/p5-pango/buildlink3.mk"
.include "../../x11/gtk2/buildlink3.mk"
.endif # P5_GTK2_BUILDLINK3_MK

BUILDLINK_TREE+=	-p5-gtk2
