# $NetBSD: buildlink3.mk,v 1.13 2018/04/09 10:24:20 jaapb Exp $

BUILDLINK_TREE+=	ocaml-ipaddr

.if !defined(OCAML_IPADDR_BUILDLINK3_MK)
OCAML_IPADDR_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ocaml-ipaddr+=	ocaml-ipaddr>=2.0.0
BUILDLINK_ABI_DEPENDS.ocaml-ipaddr?=	ocaml-ipaddr>=2.8.0nb3
BUILDLINK_PKGSRCDIR.ocaml-ipaddr?=	../../net/ocaml-ipaddr
BUILDLINK_FILES.ocaml-ipaddr+=		lib/ocaml/site-lib/*

.include "../../lang/ocaml/buildlink3.mk"
.endif	# OCAML_IPADDR_BUILDLINK3_MK

BUILDLINK_TREE+=	-ocaml-ipaddr
