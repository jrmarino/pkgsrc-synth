# $NetBSD: buildlink3.mk,v 1.4 2017/02/12 06:24:46 ryoon Exp $

BUILDLINK_TREE+=	attica-qt5

.if !defined(ATTICA_QT5_BUILDLINK3_MK)
ATTICA_QT5_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.attica-qt5+=	attica-qt5>=5.18.0
BUILDLINK_ABI_DEPENDS.attica-qt5?=	attica-qt5>=5.25.0nb3
BUILDLINK_PKGSRCDIR.attica-qt5?=	../../misc/attica-qt5

.include "../../x11/qt5-qtbase/buildlink3.mk"
.endif	# ATTICA_QT5_BUILDLINK3_MK

BUILDLINK_TREE+=	-attica-qt5
