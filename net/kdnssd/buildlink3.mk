# $NetBSD: buildlink3.mk,v 1.11 2018/03/12 11:15:41 wiz Exp $

BUILDLINK_TREE+=	kdnssd

.if !defined(KDNSSD_BUILDLINK3_MK)
KDNSSD_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.kdnssd+=	kdnssd>=5.19.0
BUILDLINK_ABI_DEPENDS.kdnssd?=	kdnssd>=5.41.0nb3
BUILDLINK_PKGSRCDIR.kdnssd?=	../../net/kdnssd

.include "../../net/avahi/buildlink3.mk"
.include "../../x11/qt5-qtbase/buildlink3.mk"
.endif	# KDNSSD_BUILDLINK3_MK

BUILDLINK_TREE+=	-kdnssd
