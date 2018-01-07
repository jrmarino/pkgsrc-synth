# $NetBSD: buildlink3.mk,v 1.4 2018/01/07 13:04:44 rillig Exp $

BUILDLINK_TREE+=	xproxymanagementprotocol

.if !defined(XPROXYMANAGEMENTPROTOCOL_BUILDLINK3_MK)
XPROXYMANAGEMENTPROTOCOL_BUILDLINK3_MK:=

BUILDLINK_DEPMETHOD.xproxymanagementprotocol?=	build

BUILDLINK_API_DEPENDS.xproxymanagementprotocol+=	xproxymanagementprotocol>=1.0.2
BUILDLINK_PKGSRCDIR.xproxymanagementprotocol?=		../../x11/xproxymanagementprotocol
.endif # XPROXYMANAGEMENTPROTOCOL_BUILDLINK3_MK

BUILDLINK_TREE+=	-xproxymanagementprotocol
