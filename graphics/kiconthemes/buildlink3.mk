# $NetBSD: buildlink3.mk,v 1.3 2017/02/06 13:54:44 wiz Exp $

BUILDLINK_TREE+=	kiconthemes

.if !defined(KICONTHEMES_BUILDLINK3_MK)
KICONTHEMES_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.kiconthemes+=	kiconthemes>=5.19.0
BUILDLINK_ABI_DEPENDS.kiconthemes?=	kiconthemes>=5.25.0nb2
BUILDLINK_PKGSRCDIR.kiconthemes?=	../../graphics/kiconthemes

.include "../../x11/kconfigwidgets/buildlink3.mk"
.include "../../x11/kitemviews/buildlink3.mk"
.include "../../x11/qt5-qtbase/buildlink3.mk"
.include "../../x11/qt5-qtsvg/buildlink3.mk"
.endif	# KICONTHEMES_BUILDLINK3_MK

BUILDLINK_TREE+=	-kiconthemes
