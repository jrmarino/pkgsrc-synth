# $NetBSD: buildlink3.mk,v 1.3 2015/04/25 14:23:18 tnn Exp $

BUILDLINK_TREE+=	py-cairo

.if !defined(PY_CAIRO_BUILDLINK3_MK)
PY_CAIRO_BUILDLINK3_MK:=

.  include "../../lang/python/pyversion.mk"

BUILDLINK_API_DEPENDS.py-cairo+=	${PYPKGPREFIX}-cairo>=1.10.0
BUILDLINK_ABI_DEPENDS.py-cairo?=	${PYPKGPREFIX}-cairo>=1.10.0nb3
BUILDLINK_PKGSRCDIR.py-cairo?=	../../graphics/py-cairo3

.include "../../graphics/cairo/buildlink3.mk"
.endif	# PY_CAIRO_BUILDLINK3_MK

BUILDLINK_TREE+=	-py-cairo
