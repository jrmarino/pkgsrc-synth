# $NetBSD: buildlink3.mk,v 1.9 2018/04/14 07:33:53 adam Exp $

BUILDLINK_TREE+=	kbookmarks

.if !defined(KBOOKMARKS_BUILDLINK3_MK)
KBOOKMARKS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.kbookmarks+=	kbookmarks>=5.19.0
BUILDLINK_ABI_DEPENDS.kbookmarks?=	kbookmarks>=5.44.0nb1
BUILDLINK_PKGSRCDIR.kbookmarks?=	../../devel/kbookmarks

.include "../../x11/kxmlgui/buildlink3.mk"
.include "../../x11/qt5-qtbase/buildlink3.mk"
.endif	# KBOOKMARKS_BUILDLINK3_MK

BUILDLINK_TREE+=	-kbookmarks
