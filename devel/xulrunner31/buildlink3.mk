# $NetBSD: buildlink3.mk,v 1.5 2017/02/06 13:54:42 wiz Exp $

BUILDLINK_TREE+=	xulrunner31

.if !defined(XULRUNNER31_BUILDLINK3_MK)
XULRUNNER31_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.xulrunner31+=	xulrunner31>=31.2.0
BUILDLINK_ABI_DEPENDS.xulrunner31+=	xulrunner31>=31.8.0nb9
BUILDLINK_PKGSRCDIR.xulrunner31?=	../../devel/xulrunner31

BUILDLINK_INCDIRS.xulrunner31+=		lib/xulrunner31/include
BUILDLINK_INCDIRS.xulrunner31+=		include/xulrunner31
BUILDLINK_FILES.xulrunner31+=		lib/xulrunner31/include/*.h

BUILDLINK_LIBDIRS.xulrunner31+=		lib/xulrunner31/lib
BUILDLINK_FILES.xulrunner31+=		lib/xulrunner31/lib/*.so
BUILDLINK_FILES.xulrunner31+=		lib/xulrunner31/pkgconfig/*pc
BUILDLINK_FNAME_TRANSFORM.xulrunner31+=	-e "s|lib/xulrunner31/pkgconfig|lib/pkgconfig|"

pkgbase := xulrunner31
.include "../../mk/pkg-build-options.mk"
.if !empty(PKG_BUILD_OPTIONS.xulrunner31:Mgnome)
. include "../../devel/libgnomeui/buildlink3.mk"
. include "../../sysutils/gnome-vfs/buildlink3.mk"
.endif
.include "../../devel/nspr/buildlink3.mk"
.endif # XULRUNNER31_BUILDLINK3_MK

BUILDLINK_TREE+=	-xulrunner31
