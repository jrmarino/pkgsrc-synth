# $NetBSD: buildlink3.mk,v 1.5 2018/04/04 09:56:56 jaapb Exp $

BUILDLINK_TREE+=	ocaml-jbuilder

.if !defined(OCAML_JBUILDER_BUILDLINK3_MK)
OCAML_JBUILDER_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ocaml-jbuilder+=	ocaml-jbuilder>=1.0_beta13nb1
BUILDLINK_ABI_DEPENDS.ocaml-jbuilder+=	ocaml-jbuilder>=1.0_beta19.1
BUILDLINK_PKGSRCDIR.ocaml-jbuilder?=	../../devel/ocaml-jbuilder
.endif	# OCAML_JBUILDER_BUILDLINK3_MK

BUILDLINK_TREE+=	-ocaml-jbuilder
