# $NetBSD: buildlink3.mk,v 1.3 2018/05/09 14:51:35 jaapb Exp $

BUILDLINK_TREE+=	ocaml-configurator

.if !defined(OCAML_CONFIGURATOR_BUILDLINK3_MK)
OCAML_CONFIGURATOR_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ocaml-configurator+=	ocaml-configurator>=0.9.1
BUILDLINK_ABI_DEPENDS.ocaml-configurator+=	ocaml-configurator>=0.11.0
BUILDLINK_PKGSRCDIR.ocaml-configurator?=	../../devel/ocaml-configurator

.endif	# OCAML_CONFIGURATOR_BUILDLINK3_MK

BUILDLINK_TREE+=	-ocaml-configurator
