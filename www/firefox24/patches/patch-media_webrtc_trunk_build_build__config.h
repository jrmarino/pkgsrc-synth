$NetBSD: patch-media_webrtc_trunk_build_build__config.h,v 1.1 2013/11/03 04:51:59 ryoon Exp $

--- media/webrtc/trunk/build/build_config.h.orig	2013-09-10 03:43:46.000000000 +0000
+++ media/webrtc/trunk/build/build_config.h
@@ -37,9 +37,15 @@
 #elif defined(_WIN32)
 #define OS_WIN 1
 #define TOOLKIT_VIEWS 1
-#elif defined(__FreeBSD__)
+#elif defined(__DragonFly__)
+#define OS_DRAGONFLY 1
+#define TOOLKIT_GTK
+#elif defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
 #define OS_FREEBSD 1
 #define TOOLKIT_GTK
+#elif defined(__NetBSD__)
+#define OS_NETBSD 1
+#define TOOLKIT_GTK
 #elif defined(__OpenBSD__)
 #define OS_OPENBSD 1
 #define TOOLKIT_GTK
@@ -56,15 +62,15 @@
 
 // For access to standard BSD features, use OS_BSD instead of a
 // more specific macro.
-#if defined(OS_FREEBSD) || defined(OS_OPENBSD)
+#if defined(OS_DRAGONFLY) || defined(OS_FREEBSD)	\
+  || defined(OS_NETBSD) || defined(OS_OPENBSD)
 #define OS_BSD 1
 #endif
 
 // For access to standard POSIXish features, use OS_POSIX instead of a
 // more specific macro.
-#if defined(OS_MACOSX) || defined(OS_LINUX) || defined(OS_FREEBSD) ||     \
-    defined(OS_OPENBSD) || defined(OS_SOLARIS) || defined(OS_ANDROID) ||  \
-    defined(OS_NACL)
+#if defined(OS_MACOSX) || defined(OS_LINUX) || defined(OS_BSD) ||	\
+    defined(OS_SOLARIS) || defined(OS_ANDROID) || defined(OS_NACL)
 #define OS_POSIX 1
 #endif
 
