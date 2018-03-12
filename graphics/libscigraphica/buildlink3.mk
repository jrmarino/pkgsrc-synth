# $NetBSD: buildlink3.mk,v 1.33 2018/03/12 11:15:37 wiz Exp $
#

BUILDLINK_TREE+=	libscigraphica

.if !defined(LIBSCIGRAPHICA_BUILDLINK3_MK)
LIBSCIGRAPHICA_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libscigraphica+=	libscigraphica>=2.1.1
BUILDLINK_ABI_DEPENDS.libscigraphica+=	libscigraphica>=2.1.1nb31
BUILDLINK_PKGSRCDIR.libscigraphica?=	../../graphics/libscigraphica

.include "../../graphics/libart/buildlink3.mk"
.include "../../math/py-numarray/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.include "../../x11/gtk2+extra/buildlink3.mk"
.include "../../x11/gtk2/buildlink3.mk"
.endif # LIBSCIGRAPHICA_BUILDLINK3_MK

BUILDLINK_TREE+=	-libscigraphica
