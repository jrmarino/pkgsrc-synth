# $NetBSD: buildlink3.mk,v 1.3 2018/01/07 13:04:26 rillig Exp $

BUILDLINK_TREE+=	aws-sdk-go

.if !defined(AWS_SDK_GO_BUILDLINK3_MK)
AWS_SDK_GO_BUILDLINK3_MK:=

BUILDLINK_CONTENTS_FILTER.aws-sdk-go=	${EGREP} gopkg/
BUILDLINK_DEPMETHOD.aws-sdk-go?=	build

BUILDLINK_API_DEPENDS.aws-sdk-go+=	aws-sdk-go>=1.4.3
BUILDLINK_PKGSRCDIR.aws-sdk-go?=	../../net/aws-sdk-go

.endif	# AWS_SDK_GO_BUILDLINK3_MK

BUILDLINK_TREE+=	-aws-sdk-go
