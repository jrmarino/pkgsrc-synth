# $NetBSD: options.mk,v 1.3 2018/01/10 22:09:02 wiz Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.texmaker
PKG_OPTIONS_REQUIRED_GROUPS= qt
PKG_OPTIONS_GROUP.qt = qt5
PKG_SUGGESTED_OPTIONS=	qt5
.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mqt5)
.include "../../x11/qt5-qtscript/buildlink3.mk"
.include "../../x11/qt5-qtwebkit/buildlink3.mk"
.include "../../print/poppler-qt5/buildlink3.mk"
.endif
