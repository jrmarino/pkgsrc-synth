# $NetBSD: buildlink3.mk,v 1.8 2018/06/08 19:25:39 nros Exp $
#

BUILDLINK_TREE+=	qore-mysql-module

.if !defined(QORE_MYSQL_MODULE_BUILDLINK3_MK)
QORE_MYSQL_MODULE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.qore-mysql-module+=	qore-mysql-module>=2.0.1
BUILDLINK_ABI_DEPENDS.qore-mysql-module?=	qore-mysql-module>=2.0.2.1
BUILDLINK_PKGSRCDIR.qore-mysql-module?=		../../databases/qore-mysql-module

.include "../../lang/qore/buildlink3.mk"
.endif	# QORE_MYSQL_MODULE_BUILDLINK3_MK

BUILDLINK_TREE+=	-qore-mysql-module
