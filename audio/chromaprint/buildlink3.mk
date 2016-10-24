# $NetBSD: buildlink3.mk,v 1.6 2016/08/17 00:06:39 ryoon Exp $

BUILDLINK_TREE+=	chromaprint

.if !defined(CHROMAPRINT_BUILDLINK3_MK)
CHROMAPRINT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.chromaprint+=	chromaprint>=1.1
BUILDLINK_ABI_DEPENDS.chromaprint?=	chromaprint>=1.3.2nb1
BUILDLINK_PKGSRCDIR.chromaprint?=	../../audio/chromaprint

.include "../../multimedia/ffmpeg2/buildlink3.mk"
.endif	# CHROMAPRINT_BUILDLINK3_MK

BUILDLINK_TREE+=	-chromaprint
