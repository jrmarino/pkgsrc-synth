# $NetBSD: buildlink3.mk,v 1.14 2018/01/07 13:04:27 rillig Exp $

BUILDLINK_TREE+=	openh323

.if !defined(OPENH323_BUILDLINK3_MK)
OPENH323_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.openh323+=	openh323>=1.15.1
BUILDLINK_ABI_DEPENDS.openh323+=	openh323>=1.15.2nb6
BUILDLINK_PKGSRCDIR.openh323?=		../../net/openh323

.include "../../devel/pwlib/buildlink3.mk"
.endif # OPENH323_BUILDLINK3_MK

BUILDLINK_TREE+=	-openh323
