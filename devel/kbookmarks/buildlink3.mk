# $NetBSD: buildlink3.mk,v 1.6 2017/09/18 09:52:58 maya Exp $

BUILDLINK_TREE+=	kbookmarks

.if !defined(KBOOKMARKS_BUILDLINK3_MK)
KBOOKMARKS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.kbookmarks+=	kbookmarks>=5.19.0
BUILDLINK_ABI_DEPENDS.kbookmarks?=	kbookmarks>=5.25.0nb9
BUILDLINK_PKGSRCDIR.kbookmarks?=	../../devel/kbookmarks

.include "../../x11/kxmlgui/buildlink3.mk"
.include "../../x11/qt5-qtbase/buildlink3.mk"
.endif	# KBOOKMARKS_BUILDLINK3_MK

BUILDLINK_TREE+=	-kbookmarks
