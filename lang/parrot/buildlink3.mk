# $NetBSD: buildlink3.mk,v 1.24 2017/11/30 16:45:04 adam Exp $

BUILDLINK_TREE+=	parrot

.if !defined(PARROT_BUILDLINK3_MK)
PARROT_BUILDLINK3_MK:=

.include "../../lang/parrot/version.mk"

BUILDLINK_API_DEPENDS.parrot+=		parrot>=0.4.0
BUILDLINK_ABI_DEPENDS.parrot+=		parrot>=5.7.0nb14
BUILDLINK_PKGSRCDIR.parrot?=		../../lang/parrot

.include "../../textproc/icu/buildlink3.mk"
.include "../../devel/gmp/buildlink3.mk"
.include "../../mk/readline.buildlink3.mk"
.endif # PARROT_BUILDLINK3_MK

BUILDLINK_TREE+=	-parrot
