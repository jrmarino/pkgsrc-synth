# $NetBSD: buildlink3.mk,v 1.22 2018/01/10 16:44:16 jaapb Exp $

BUILDLINK_TREE+=	ocaml-ssl

.if !defined(OCAML_SSL_BUILDLINK3_MK)
OCAML_SSL_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ocaml-ssl+=	ocaml-ssl>=0.4.0
BUILDLINK_ABI_DEPENDS.ocaml-ssl+=	ocaml-ssl>=0.5.5
BUILDLINK_PKGSRCDIR.ocaml-ssl?=		../../security/ocaml-ssl

.include "../../lang/ocaml/buildlink3.mk"
.include "../../security/openssl/buildlink3.mk"
.endif # OCAML_SSL_BUILDLINK3_MK

BUILDLINK_TREE+=	-ocaml-ssl
