# $NetBSD: buildlink3.mk,v 1.3 2018/01/07 13:04:02 rillig Exp $

BUILDLINK_TREE+=	go-sanitized_anchor_name

.if !defined(GO_SANITIZED_ANCHOR_NAME_BUILDLINK3_MK)
GO_SANITIZED_ANCHOR_NAME_BUILDLINK3_MK:=

BUILDLINK_CONTENTS_FILTER.go-sanitized_anchor_name=	${EGREP} gopkg/
BUILDLINK_DEPMETHOD.go-sanitized_anchor_name?=		build

BUILDLINK_API_DEPENDS.go-sanitized_anchor_name+=	go-sanitized_anchor_name>=0.0
BUILDLINK_PKGSRCDIR.go-sanitized_anchor_name?=		../../devel/go-sanitized_anchor_name

.endif  # GO_SANITIZED_ANCHOR_NAME_BUILDLINK3_MK

BUILDLINK_TREE+=	-go-sanitized_anchor_name
