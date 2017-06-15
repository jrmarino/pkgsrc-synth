# $NetBSD: buildlink3.mk,v 1.1 2017/06/14 21:19:58 wiz Exp $

BUILDLINK_TREE+=        cups-filters

.if !defined(CUPS_FILTERS_BUILDLINK3_MK)
CUPS_FILTERS_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.cups-filters+=    cups-filters>=1.8.2
BUILDLINK_PKGSRCDIR.cups-filters?=      ../../print/cups-filters

.include "../../print/cups/buildlink3.mk"
.endif # CUPS_FILTERS_BUILDLINK3_MK

BUILDLINK_TREE+=	-cups-filters
