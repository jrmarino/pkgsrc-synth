# $NetBSD: buildlink3.mk,v 1.11 2018/01/01 21:18:10 adam Exp $

BUILDLINK_TREE+=	liboauth

.if !defined(LIBOAUTH_BUILDLINK3_MK)
LIBOAUTH_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.liboauth+=	liboauth>=0.8.9
BUILDLINK_ABI_DEPENDS.liboauth?=	liboauth>=1.0.3nb6
BUILDLINK_PKGSRCDIR.liboauth?=	../../security/liboauth

.include "../../security/openssl/buildlink3.mk"
.include "../../www/curl/buildlink3.mk"
.endif	# LIBOAUTH_BUILDLINK3_MK

BUILDLINK_TREE+=	-liboauth
