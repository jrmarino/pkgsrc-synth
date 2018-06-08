# $NetBSD: buildlink3.mk,v 1.1 2018/06/07 19:14:46 ryoon Exp $

BUILDLINK_TREE+=	mingw-w64-x86_64-headers

.if !defined(MINGW_W64_X86_64_HEADERS_BUILDLINK3_MK)
MINGW_W64_X86_64_HEADERS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.mingw-w64-x86_64-headers+=	mingw-w64-x86_64-headers>=5.0.4
BUILDLINK_PKGSRCDIR.mingw-w64-x86_64-headers?=	../../cross/mingw-w64-x86_64-headers
.endif	# MINGW_W64_X86_64_HEADERS_BUILDLINK3_MK

BUILDLINK_TREE+=	-mingw-w64-x86_64-headers
