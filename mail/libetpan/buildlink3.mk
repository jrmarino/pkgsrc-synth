# $NetBSD: buildlink3.mk,v 1.35 2018/01/01 21:18:09 adam Exp $

BUILDLINK_TREE+=	libetpan

.if !defined(LIBETPAN_BUILDLINK3_MK)
LIBETPAN_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libetpan+=	libetpan>=1.0
BUILDLINK_ABI_DEPENDS.libetpan+=	libetpan>=1.8nb2
BUILDLINK_PKGSRCDIR.libetpan?=	../../mail/libetpan

BDB_ACCEPTED?=	db4 db5 db6
.include "../../converters/libiconv/buildlink3.mk"
.include "../../security/cyrus-sasl/buildlink3.mk"
.include "../../security/openssl/buildlink3.mk"
.include "../../textproc/expat/buildlink3.mk"
.include "../../www/curl/buildlink3.mk"
.include "../../mk/bdb.buildlink3.mk"
.include "../../mk/pthread.buildlink3.mk"
.endif # LIBETPAN_BUILDLINK3_MK

BUILDLINK_TREE+=	-libetpan
