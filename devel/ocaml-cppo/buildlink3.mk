# $NetBSD: buildlink3.mk,v 1.6 2018/07/19 15:15:22 jaapb Exp $

BUILDLINK_TREE+=	ocaml-cppo

.if !defined(OCAML_CPPO_BUILDLINK3_MK)
OCAML_CPPO_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ocaml-cppo+=	ocaml-cppo>=1.3.1
BUILDLINK_ABI_DEPENDS.ocaml-cppo+=	ocaml-cppo>=1.6.4nb1
BUILDLINK_PKGSRCDIR.ocaml-cppo?=	../../devel/ocaml-cppo
.endif	# OCAML_CPPO_BUILDLINK3_MK

BUILDLINK_TREE+=	-ocaml-cppo
