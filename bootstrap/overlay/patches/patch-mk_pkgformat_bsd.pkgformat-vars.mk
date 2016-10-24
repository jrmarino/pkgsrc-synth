--- mk/pkgformat/bsd.pkgformat-vars.mk.orig	2011-10-15 00:23:09 UTC
+++ mk/pkgformat/bsd.pkgformat-vars.mk
@@ -6,6 +6,6 @@
 #
 
 # Default to the pkgsrc package format.
-PKG_FORMAT?=	pkg
+PKG_FORMAT?=	pkgng
 
 .sinclude "${PKG_FORMAT}/pkgformat-vars.mk"
