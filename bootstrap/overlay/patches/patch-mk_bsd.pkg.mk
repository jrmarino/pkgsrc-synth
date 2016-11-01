--- mk/bsd.pkg.mk.orig	2016-08-26 16:51:56 UTC
+++ mk/bsd.pkg.mk
@@ -377,7 +377,7 @@ USE_TOOLS+=	file
 .endif
 
 # INSTALL/DEINSTALL script framework
-.include "pkginstall/bsd.pkginstall.mk"
+.include "pkginstall/bsd.pkgng-install.mk"
 
 # Locking
 .include "internal/locking.mk"
