# $NetBSD: buildlink3.mk,v 1.10 2018/04/14 07:33:58 adam Exp $
#

BUILDLINK_TREE+=	libmateweather

.if !defined(LIBMATEWEATHER_BUILDLINK3_MK)
LIBMATEWEATHER_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libmateweather+=	libmateweather>=1.8.0
BUILDLINK_ABI_DEPENDS.libmateweather+=	libmateweather>=1.18.1nb5
BUILDLINK_PKGSRCDIR.libmateweather?=	../../misc/libmateweather

.include "../../textproc/libxml2/buildlink3.mk"
.include "../../net/libsoup/buildlink3.mk"
.endif	# LIBMATEWEATHER_BUILDLINK3_MK

BUILDLINK_TREE+=	-libmateweather
