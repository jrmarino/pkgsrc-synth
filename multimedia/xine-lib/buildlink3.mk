# $NetBSD: buildlink3.mk,v 1.37 2018/03/12 11:15:41 wiz Exp $

BUILDLINK_TREE+=	xine-lib

.if !defined(XINE_LIB_BUILDLINK3_MK)
XINE_LIB_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.xine-lib+=	xine-lib>=1rc3c
BUILDLINK_ABI_DEPENDS.xine-lib+=	xine-lib>=1.2.6nb11
BUILDLINK_PKGSRCDIR.xine-lib?=		../../multimedia/xine-lib

.include "../../multimedia/ffmpeg2/buildlink3.mk"
.endif # XINE_LIB_BUILDLINK3_MK

BUILDLINK_TREE+=	-xine-lib
