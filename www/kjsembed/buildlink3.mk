# $NetBSD: buildlink3.mk,v 1.11 2018/01/07 13:04:37 rillig Exp $

BUILDLINK_TREE+=	kjsembed

.if !defined(KJSEMBED_BUILDLINK3_MK)
KJSEMBED_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.kjsembed+=	kjsembed>=5.21.0
BUILDLINK_ABI_DEPENDS.kjsembed?=	kjsembed>=5.25.0nb10
BUILDLINK_PKGSRCDIR.kjsembed?=		../../www/kjsembed

.include "../../devel/ki18n/buildlink3.mk"
.include "../../www/kjs/buildlink3.mk"
.include "../../x11/qt5-qtbase/buildlink3.mk"
.include "../../x11/qt5-qtsvg/buildlink3.mk"
.include "../../x11/qt5-qttools/buildlink3.mk"
.endif	# KJSEMBED_BUILDLINK3_MK

BUILDLINK_TREE+=	-kjsembed
