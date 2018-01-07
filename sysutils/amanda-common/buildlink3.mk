# $NetBSD: buildlink3.mk,v 1.15 2018/01/07 13:04:31 rillig Exp $

BUILDLINK_TREE+=	amanda-common

.if !defined(AMANDA_COMMON_BUILDLINK3_MK)
AMANDA_COMMON_BUILDLINK3_MK:=

.include "version.mk"

BUILDLINK_API_DEPENDS.amanda-common+=	amanda-common>=${AMANDA_VERSION}
BUILDLINK_ABI_DEPENDS.amanda-common+=	amanda-common>=${AMANDA_VERSION}
BUILDLINK_PKGSRCDIR.amanda-common?=	../../sysutils/amanda-common

BUILDLINK_LIBDIRS.amanda-common=	lib/amanda

pkgbase := amanda-common
.include "../../mk/pkg-build-options.mk"
.if !empty(PKG_BUILD_OPTIONS.amanda-common:Mamanda-krb5)
CONFIGURE_ARGS+=	--with-krb5-security=${KRB5BASE}
.  include "../../mk/krb5.buildlink3.mk"
.endif
.endif # AMANDA_COMMON_BUILDLINK3_MK

BUILDLINK_TREE+=	-amanda-common
