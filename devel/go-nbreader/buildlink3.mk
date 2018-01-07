# $NetBSD: buildlink3.mk,v 1.2 2018/01/07 13:04:02 rillig Exp $

BUILDLINK_TREE+=	go-nbreader

.if !defined(GO_NBREADER_BUILDLINK3_MK)
GO_NBREADER_BUILDLINK3_MK:=

BUILDLINK_CONTENTS_FILTER.go-nbreader=	${EGREP} gopkg/
BUILDLINK_DEPMETHOD.go-nbreader?=	build

BUILDLINK_API_DEPENDS.go-nbreader+=	go-nbreader>=0.0.20150201
BUILDLINK_PKGSRCDIR.go-nbreader?=	../../devel/go-nbreader
.endif	# GO_NBREADER_BUILDLINK3_MK

BUILDLINK_TREE+=	-go-nbreader
