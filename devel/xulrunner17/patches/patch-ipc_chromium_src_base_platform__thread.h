$NetBSD: patch-ipc_chromium_src_base_platform__thread.h,v 1.1 2013/01/10 16:17:10 ryoon Exp $

--- ipc/chromium/src/base/platform_thread.h.orig	2012-08-24 22:55:37.000000000 +0000
+++ ipc/chromium/src/base/platform_thread.h
@@ -22,9 +22,11 @@ typedef void* PlatformThreadHandle;  // 
 #elif defined(OS_POSIX)
 #include <pthread.h>
 typedef pthread_t PlatformThreadHandle;
-#if defined(OS_LINUX)
+#if defined(OS_LINUX) || defined(OS_OPENBSD)
 #include <unistd.h>
 typedef pid_t PlatformThreadId;
+#elif defined(OS_BSD)
+typedef lwpid_t PlatformThreadId;
 #elif defined(OS_MACOSX)
 #include <mach/mach.h>
 typedef mach_port_t PlatformThreadId;
