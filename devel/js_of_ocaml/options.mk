# $NetBSD: options.mk,v 1.3 2018/04/13 12:59:41 jaapb Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.js_of_ocaml
PKG_SUPPORTED_OPTIONS=	ocaml-tyxml
PKG_SUGGESTED_OPTIONS=	ocaml-tyxml

.include "../../mk/bsd.prefs.mk"

.include "../../mk/bsd.options.mk"

PLIST_VARS+=	tyxml

###
### TyXML support
###
.if !empty(PKG_OPTIONS:Mocaml-tyxml)
.include "../../textproc/ocaml-tyxml/buildlink3.mk"
.include "../../devel/ocaml-reactiveData/buildlink3.mk"
PLIST.tyxml=	yes
JBUILDER_BUILD_PACKAGES+=	js_of_ocaml-tyxml
OPAM_INSTALL_FILES+=	js_of_ocaml-tyxml
.else
.endif
