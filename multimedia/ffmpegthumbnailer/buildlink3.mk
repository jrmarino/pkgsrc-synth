# $NetBSD: buildlink3.mk,v 1.5 2018/01/07 13:04:24 rillig Exp $

BUILDLINK_TREE+=	ffmpegthumbnailer

.if !defined(FFMPEGTHUMBNAILER_BUILDLINK3_MK)
FFMPEGTHUMBNAILER_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ffmpegthumbnailer+=	ffmpegthumbnailer>=2.0.6nb1
BUILDLINK_ABI_DEPENDS.ffmpegthumbnailer?=	ffmpegthumbnailer>=2.0.8nb1
BUILDLINK_PKGSRCDIR.ffmpegthumbnailer?=		../../multimedia/ffmpegthumbnailer

#.include "../../graphics/png/buildlink3.mk"
#.include "../../multimedia/ffmpeg1/buildlink3.mk"
.endif	# FFMPEGTHUMBNAILER_BUILDLINK3_MK

BUILDLINK_TREE+=	-ffmpegthumbnailer
