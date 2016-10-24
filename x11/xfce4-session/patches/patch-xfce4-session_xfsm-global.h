$NetBSD: patch-xfce4-session_xfsm-global.h,v 1.1 2015/07/07 14:04:22 youri Exp $

Make verbose logging optional.
--- xfce4-session/xfsm-global.h.orig	2014-09-28 14:51:01.000000000 +0000
+++ xfce4-session/xfsm-global.h
@@ -49,7 +49,10 @@ extern XfsmSplashScreen *splash_screen;
 #if defined(G_HAVE_ISO_VARARGS)
 
 #define xfsm_verbose(...)\
-    xfsm_verbose_real (__func__, __FILE__, __LINE__, __VA_ARGS__)
+G_STMT_START{	\
+	if (G_UNLIKELY (verbose))	\
+    		xfsm_verbose_real (__func__, __FILE__, __LINE__, __VA_ARGS__);\
+}G_STMT_END
 
 #else
 
