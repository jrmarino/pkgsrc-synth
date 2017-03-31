# $NetBSD: buildlink3.mk,v 1.40 2017/03/31 10:32:15 wiz Exp $

BUILDLINK_TREE+=	totem-pl-parser

.if !defined(TOTEM_PL_PARSER_BUILDLINK3_MK)
TOTEM_PL_PARSER_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.totem-pl-parser+=	totem-pl-parser>=2.22.1
BUILDLINK_ABI_DEPENDS.totem-pl-parser+=	totem-pl-parser>=3.4.5nb6
BUILDLINK_PKGSRCDIR.totem-pl-parser?=	../../multimedia/totem-pl-parser

.include "../../devel/glib2/buildlink3.mk"
.include "../../mail/gmime/buildlink3.mk"
.include "../../net/libsoup/buildlink3.mk"
.include "../../security/libgcrypt/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.endif # TOTEM_PL_PARSER_BUILDLINK3_MK

BUILDLINK_TREE+=	-totem-pl-parser
