# $NetBSD: buildlink3.mk,v 1.5 2018/03/07 11:57:35 wiz Exp $

.include "../../mk/bsd.fast.prefs.mk"

BUILDLINK_TREE+=	libXcomposite

.if !defined(LIBXCOMPOSITE_BUILDLINK3_MK)
LIBXCOMPOSITE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libXcomposite+=	libXcomposite>=0.3.1
BUILDLINK_PKGSRCDIR.libXcomposite?=	../../x11/libXcomposite

.include "../../x11/xorgproto/buildlink3.mk"
.include "../../x11/libX11/buildlink3.mk"
.include "../../x11/libXext/buildlink3.mk"
.include "../../x11/libXfixes/buildlink3.mk"
.endif # LIBXCOMPOSITE_BUILDLINK3_MK

BUILDLINK_TREE+=	-libXcomposite
