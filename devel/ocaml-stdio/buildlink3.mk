# $NetBSD: buildlink3.mk,v 1.6 2018/07/19 15:15:25 jaapb Exp $

BUILDLINK_TREE+=	ocaml-stdio

.if !defined(OCAML_STDIO_BUILDLINK3_MK)
OCAML_STDIO_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ocaml-stdio+=	ocaml-stdio>=0.9.0
BUILDLINK_ABI_DEPENDS.ocaml-stdio+=	ocaml-stdio>=0.11.0nb1
BUILDLINK_PKGSRCDIR.ocaml-stdio?=	../../devel/ocaml-stdio
.endif	# OCAML_STDIO_BUILDLINK3_MK

BUILDLINK_TREE+=	-ocaml-stdio
