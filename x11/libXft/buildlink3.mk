# $NetBSD: buildlink3.mk,v 1.15 2018/03/07 11:57:36 wiz Exp $

.include "../../mk/bsd.fast.prefs.mk"

.if ${X11_TYPE} != "modular" && \
    !exists(${X11BASE}/lib/pkgconfig/xft.pc) && \
    !exists(${X11BASE}/lib${LIBABISUFFIX}/pkgconfig/xft.pc)
.include "../../fonts/Xft2/buildlink3.mk"
.else

BUILDLINK_TREE+=	libXft

.  if !defined(LIBXFT_BUILDLINK3_MK)
LIBXFT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libXft+=	libXft>=2.1.10
BUILDLINK_ABI_DEPENDS.libXft+=	libXft>=2.3.1nb3
BUILDLINK_PKGSRCDIR.libXft?=	../../x11/libXft

.include "../../fonts/fontconfig/buildlink3.mk"
.include "../../graphics/freetype2/buildlink3.mk"
.include "../../x11/libXrender/buildlink3.mk"
.include "../../x11/libX11/buildlink3.mk"
.include "../../x11/xorgproto/buildlink3.mk"
.  endif # LIBXFT_BUILDLINK3_MK

BUILDLINK_TREE+=	-libXft

.endif
