# $NetBSD: buildlink3.mk,v 1.35 2018/03/12 11:15:41 wiz Exp $

BUILDLINK_TREE+=	gtk-vnc

.if !defined(GTK_VNC_BUILDLINK3_MK)
GTK_VNC_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.gtk-vnc+=	gtk-vnc>=0.5.1
BUILDLINK_ABI_DEPENDS.gtk-vnc+=	gtk-vnc>=0.5.2nb21
BUILDLINK_PKGSRCDIR.gtk-vnc?=	../../net/gtk-vnc

pkgbase := gtk-vnc
.include "../../mk/pkg-build-options.mk"
.if !empty(PKG_BUILD_OPTIONS.gtk-vnc:Mvnc-sasl)
.include "../../security/cyrus-sasl/buildlink3.mk"
.endif

.include "../../devel/glib2/buildlink3.mk"
.include "../../devel/zlib/buildlink3.mk"
.include "../../security/gnutls/buildlink3.mk"
.include "../../x11/gtk3/buildlink3.mk"
.endif # GTK_VNC_BUILDLINK3_MK

BUILDLINK_TREE+=	-gtk-vnc
