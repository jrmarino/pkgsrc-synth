# $NetBSD: buildlink3.mk,v 1.7 2018/03/12 11:15:53 wiz Exp $

BUILDLINK_TREE+=	libkactivities4

.if !defined(LIBKACTIVITIES4_BUILDLINK3_MK)
LIBKACTIVITIES4_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libkactivities4+=	libkactivities4>=4.7.95
BUILDLINK_ABI_DEPENDS.libkactivities4+=	libkactivities4>=4.13.3nb6
BUILDLINK_PKGSRCDIR.libkactivities4?=	../../x11/libkactivities4

.include "../../x11/kdelibs4/buildlink3.mk"
.endif # LIBKACTIVITIES4_BUILDLINK3_MK

BUILDLINK_TREE+=	-libkactivities4
