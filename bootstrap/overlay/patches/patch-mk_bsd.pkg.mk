--- mk/bsd.pkg.mk.orig	2016-11-08 20:05:53 UTC
+++ mk/bsd.pkg.mk
@@ -377,7 +377,11 @@ USE_TOOLS+=	file
 .endif
 
 # INSTALL/DEINSTALL script framework
+.if ${PKG_FORMAT:Mpkgng}
+.include "pkginstall/bsd.pkgng-install.mk"
+.else
 .include "pkginstall/bsd.pkginstall.mk"
+.endif
 
 # Locking
 .include "internal/locking.mk"
