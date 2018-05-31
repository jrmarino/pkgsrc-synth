# $NetBSD: buildlink3.mk,v 1.3 2018/05/31 11:22:04 jaapb Exp $

BUILDLINK_TREE+=	ocaml-opaline

.if !defined(OCAML_OPALINE_BUILDLINK3_MK)
OCAML_OPALINE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ocaml-opaline+=	ocaml-opaline>=0.3.1
BUILDLINK_PKGSRCDIR.ocaml-opaline?=	../../misc/ocaml-opaline

# We only need this to install
BUILDLINK_DEPMETHOD.ocaml-opaline?=     build

.endif	# OCAML_OPALINE_BUILDLINK3_MK

BUILDLINK_TREE+=	-ocaml-opaline
