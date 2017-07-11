# $NetBSD: buildlink3.mk,v 1.10 2017/07/11 12:34:22 jaapb Exp $

BUILDLINK_TREE+=	ocaml-cryptokit

.if !defined(OCAML_CRYPTOKIT_BUILDLINK3_MK)
OCAML_CRYPTOKIT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ocaml-cryptokit+=	ocaml-cryptokit>=1.5
BUILDLINK_ABI_DEPENDS.ocaml-cryptokit?=	ocaml-cryptokit>=1.11
BUILDLINK_PKGSRCDIR.ocaml-cryptokit?=	../../security/ocaml-cryptokit

.include "../../math/ocaml-zarith/buildlink3.mk"
.include "../../lang/ocaml/buildlink3.mk"
.endif # OCAML_CRYPTOKIT_BUILDLINK3_MK

BUILDLINK_TREE+=	-ocaml-cryptokit
