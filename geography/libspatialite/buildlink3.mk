# $NetBSD: buildlink3.mk,v 1.7 2018/03/02 01:14:15 gdt Exp $

BUILDLINK_TREE+=	libspatialite

.if !defined(LIBSPATIALITE_BUILDLINK3_MK)
LIBSPATIALITE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libspatialite+=	libspatialite>=4.3.0a
BUILDLINK_ABI_DEPENDS.libspatialite?=	libspatialite>=4.3.0anb6
BUILDLINK_PKGSRCDIR.libspatialite?=	../../geography/libspatialite

.include "../../converters/libiconv/buildlink3.mk"
.include "../../databases/sqlite3/buildlink3.mk"
.include "../../geography/geos/buildlink3.mk"
.include "../../geography/proj/buildlink3.mk"
.include "../../textproc/freexl/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.endif	# LIBSPATIALITE_BUILDLINK3_MK

BUILDLINK_TREE+=	-libspatialite
