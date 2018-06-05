# $NetBSD: buildlink3.mk,v 1.1 2018/06/05 15:53:14 jaapb Exp $

BUILDLINK_TREE+=	ocaml-safepass

.if !defined(OCAML_SAFEPASS_BUILDLINK3_MK)
OCAML_SAFEPASS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ocaml-safepass+=	ocaml-safepass>=2.0
BUILDLINK_PKGSRCDIR.ocaml-safepass?=	../../security/ocaml-safepass
.endif	# OCAML_SAFEPASS_BUILDLINK3_MK

BUILDLINK_TREE+=	-ocaml-safepass
