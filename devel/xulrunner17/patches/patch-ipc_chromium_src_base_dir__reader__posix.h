$NetBSD: patch-ipc_chromium_src_base_dir__reader__posix.h,v 1.1 2013/01/10 16:17:10 ryoon Exp $

--- ipc/chromium/src/base/dir_reader_posix.h.orig	2012-08-24 22:55:37.000000000 +0000
+++ ipc/chromium/src/base/dir_reader_posix.h
@@ -18,16 +18,20 @@
 // seems worse than falling back to enumerating all file descriptors so we will
 // probably never implement this on the Mac.
 
-#if defined(OS_LINUX) && !defined(OS_OPENBSD)
+#if defined(OS_LINUX)
 #include "base/dir_reader_linux.h"
+#elif defined(OS_BSD)
+#include "base/dir_reader_bsd.h"
 #else
 #include "base/dir_reader_fallback.h"
 #endif
 
 namespace base {
 
-#if defined(OS_LINUX) && !defined(OS_OPENBSD)
+#if defined(OS_LINUX)
 typedef DirReaderLinux DirReaderPosix;
+#elif defined(OS_BSD)
+typedef DirReaderBSD DirReaderPosix;
 #else
 typedef DirReaderFallback DirReaderPosix;
 #endif
