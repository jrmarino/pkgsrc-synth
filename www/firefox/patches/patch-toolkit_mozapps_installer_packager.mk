$NetBSD: patch-toolkit_mozapps_installer_packager.mk,v 1.2 2018/06/28 13:52:37 ryoon Exp $

* Symbolic link to lib/firefox/firefox causes 'Couldn't load XPCOM.' error.

--- toolkit/mozapps/installer/packager.mk.orig	2018-06-21 20:04:02.000000000 +0000
+++ toolkit/mozapps/installer/packager.mk
@@ -123,7 +123,7 @@ endif
 	  (cd $(DESTDIR)$(installdir) && tar -xf -)
 	$(NSINSTALL) -D $(DESTDIR)$(bindir)
 	$(RM) -f $(DESTDIR)$(bindir)/$(MOZ_APP_NAME)
-	ln -s $(installdir)/$(MOZ_APP_NAME) $(DESTDIR)$(bindir)
+	#ln -s $(installdir)/$(MOZ_APP_NAME) $(DESTDIR)$(bindir)
 
 upload:
 	$(PYTHON) -u $(MOZILLA_DIR)/build/upload.py --base-path $(DIST) $(UPLOAD_FILES)
