--- mk/bsd.pkg.mk.orig	2017-06-07 21:47:51 UTC
+++ mk/bsd.pkg.mk
@@ -381,7 +381,11 @@ USE_TOOLS+=	expr
 .include "pkgtasks/bsd.pkgtasks.mk"
 .else
 # INSTALL/DEINSTALL script framework
+. if ${PKG_FORMAT:Mpkgng}
+.include "pkginstall/bsd.pkgng-install.mk"
+. else
 .include "pkginstall/bsd.pkginstall.mk"
+. endif
 .endif
 
 # Locking
