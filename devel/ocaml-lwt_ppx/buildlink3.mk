# $NetBSD: buildlink3.mk,v 1.2 2018/04/14 19:38:55 jaapb Exp $

BUILDLINK_TREE+=	ocaml-lwt_ppx

.if !defined(OCAML_LWT_PPX_BUILDLINK3_MK)
OCAML_LWT_PPX_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ocaml-lwt_ppx+=	ocaml-lwt_ppx>=1.1.0
BUILDLINK_ABI_DEPENDS.ocaml-lwt_ppx+=	ocaml-lwt_ppx>=1.2.0
BUILDLINK_PKGSRCDIR.ocaml-lwt_ppx?=	../../devel/ocaml-lwt_ppx

.include "../../devel/ocaml-lwt/buildlink3.mk"
.endif	# OCAML_LWT_PPX_BUILDLINK3_MK

BUILDLINK_TREE+=	-ocaml-lwt_ppx
