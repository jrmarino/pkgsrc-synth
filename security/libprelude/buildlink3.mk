# $NetBSD: buildlink3.mk,v 1.19 2018/04/17 22:29:34 wiz Exp $

BUILDLINK_TREE+=	libprelude

.if !defined(LIBPRELUDE_BUILDLINK3_MK)
LIBPRELUDE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libprelude+=	libprelude>=0.9.0
BUILDLINK_ABI_DEPENDS.libprelude+=	libprelude>=0.9.24.1nb15
BUILDLINK_PKGSRCDIR.libprelude?=	../../security/libprelude

.include "../../security/gnutls/buildlink3.mk"
.include "../../security/libgcrypt/buildlink3.mk"
.endif # LIBPRELUDE_BUILDLINK3_MK

BUILDLINK_TREE+=	-libprelude
