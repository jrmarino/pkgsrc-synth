# $NetBSD: buildlink3.mk,v 1.14 2018/04/14 07:34:05 adam Exp $

BUILDLINK_TREE+=	kdelibs4support

.if !defined(KDELIBS4SUPPORT_BUILDLINK3_MK)
KDELIBS4SUPPORT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.kdelibs4support+=	kdelibs4support>=5.21.0
BUILDLINK_ABI_DEPENDS.kdelibs4support?=	kdelibs4support>=5.44.0nb1
BUILDLINK_PKGSRCDIR.kdelibs4support?=	../../x11/kdelibs4support

.include "../../misc/kemoticons/buildlink3.mk"
.include "../../devel/kitemmodels/buildlink3.mk"
.include "../../misc/kunitconversion/buildlink3.mk"
.include "../../devel/kparts/buildlink3.mk"
.include "../../x11/qt5-qtbase/buildlink3.mk"
.endif	# KDELIBS4SUPPORT_BUILDLINK3_MK

BUILDLINK_TREE+=	-kdelibs4support
