# $NetBSD: buildlink3.mk,v 1.2 2015/02/08 17:48:33 tnn Exp $

BUILDLINK_TREE+=	openjdk8

.if !defined(OPENJDK8_BUILDLINK3_MK)
OPENJDK8_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.openjdk8+=	openjdk8>=1.8.0
BUILDLINK_PKGSRCDIR.openjdk8?=		../../lang/openjdk8

.endif	# OPENJDK8_BUILDLINK3_MK

BUILDLINK_TREE+=	-openjdk8
