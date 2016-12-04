--- textproc/aspell/buildlink3.mk.orig	2011-04-22 13:41:59 UTC
+++ textproc/aspell/buildlink3.mk
@@ -6,7 +6,7 @@ BUILDLINK_TREE+=	aspell
 ASPELL_BUILDLINK3_MK:=
 
 BUILDLINK_API_DEPENDS.aspell+=	aspell>=0.50.3
-BUILDLINK_ABI_DEPENDS.aspell+=	aspell>=0.60.6nb3
+BUILDLINK_ABI_DEPENDS.aspell+=	aspell>=0.60.6.1
 BUILDLINK_PKGSRCDIR.aspell?=	../../textproc/aspell
 
 BUILDLINK_FILES.aspell=	bin/aspell bin/prezip-bin bin/word-list-compress
