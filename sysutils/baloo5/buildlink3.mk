# $NetBSD: buildlink3.mk,v 1.13 2018/01/28 20:10:38 wiz Exp $

BUILDLINK_TREE+=	baloo5

.if !defined(BALOO5_BUILDLINK3_MK)
BALOO5_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.baloo5+=	baloo5>=5.21.0
BUILDLINK_ABI_DEPENDS.baloo5?=	baloo5>=5.41.0nb2
BUILDLINK_PKGSRCDIR.baloo5?=	../../sysutils/baloo5

.include "../../databases/lmdb/buildlink3.mk"
.include "../../devel/kidletime/buildlink3.mk"
.include "../../devel/kio/buildlink3.mk"
#.include "../../devel/libinotify/buildlink3.mk"
.include "../../sysutils/kfilemetadata5/buildlink3.mk"
.include "../../x11/qt5-qtbase/buildlink3.mk"
.endif	# BALOO5_BUILDLINK3_MK

BUILDLINK_TREE+=	-baloo5
