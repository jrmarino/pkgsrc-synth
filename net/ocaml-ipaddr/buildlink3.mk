# $NetBSD: buildlink3.mk,v 1.15 2018/07/19 15:15:27 jaapb Exp $

BUILDLINK_TREE+=	ocaml-ipaddr

.if !defined(OCAML_IPADDR_BUILDLINK3_MK)
OCAML_IPADDR_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ocaml-ipaddr+=	ocaml-ipaddr>=2.0.0
BUILDLINK_ABI_DEPENDS.ocaml-ipaddr?=	ocaml-ipaddr>=2.8.0nb5
BUILDLINK_PKGSRCDIR.ocaml-ipaddr?=	../../net/ocaml-ipaddr
BUILDLINK_FILES.ocaml-ipaddr+=		lib/ocaml/site-lib/*

.include "../../lang/ocaml/buildlink3.mk"
.endif	# OCAML_IPADDR_BUILDLINK3_MK

BUILDLINK_TREE+=	-ocaml-ipaddr
