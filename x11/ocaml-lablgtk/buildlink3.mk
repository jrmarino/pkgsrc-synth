# $NetBSD: buildlink3.mk,v 1.15 2017/04/22 21:03:20 adam Exp $

BUILDLINK_TREE+=	ocaml-lablgtk

.if !defined(OCAML_LABLGTK_BUILDLINK3_MK)
OCAML_LABLGTK_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ocaml-lablgtk+=	ocaml-lablgtk>=2.6.0nb3
BUILDLINK_ABI_DEPENDS.ocaml-lablgtk+=	ocaml-lablgtk>=2.18.5nb5
BUILDLINK_PKGSRCDIR.ocaml-lablgtk?=	../../x11/ocaml-lablgtk

# options must be exposed if and only if we built with them
pkgbase := ocaml-lablgtk
.include "../../mk/pkg-build-options.mk"

.if !empty(PKG_BUILD_OPTIONS.ocaml-lablgtk:Mgnomecanvas)
.  include "../../x11/gnome-panel/buildlink3.mk"
.endif

.if !empty(PKG_BUILD_OPTIONS.ocaml-lablgtk:Mgtksourceview)
.  include "../../x11/gtksourceview/buildlink3.mk"
.endif

.if !empty(PKG_BUILD_OPTIONS.ocaml-lablgtk:Mgtksourceview2)
.  include "../../x11/gtksourceview2/buildlink3.mk"
.endif

.endif # OCAML_LABLGTK_BUILDLINK3_MK

BUILDLINK_TREE+=	-ocaml-lablgtk
