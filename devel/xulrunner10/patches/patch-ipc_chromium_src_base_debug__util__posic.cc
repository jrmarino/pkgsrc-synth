$NetBSD: patch-ipc_chromium_src_base_debug__util__posic.cc,v 1.2 2013/01/10 12:32:00 ryoon Exp $

--- ipc/chromium/src/base/debug_util_posix.cc.orig	2013-01-03 17:43:14.000000000 +0000
+++ ipc/chromium/src/base/debug_util_posix.cc
@@ -5,7 +5,7 @@
 #include "build/build_config.h"
 #include "base/debug_util.h"
 
-#define MOZ_HAVE_EXECINFO_H (!defined(ANDROID) && !defined(__OpenBSD__))
+#define MOZ_HAVE_EXECINFO_H (defined(__linux__) && !defined(ANDROID))
 
 #include <errno.h>
 #include <fcntl.h>
@@ -17,8 +17,11 @@
 #include <unistd.h>
 #if MOZ_HAVE_EXECINFO_H
 #include <execinfo.h>
-#include <sys/sysctl.h>
 #endif
+#if defined(OS_DRAGONFLY)
+#include <sys/user.h>
+#endif
+#include <sys/sysctl.h>
 
 #include "base/basictypes.h"
 #include "base/eintr_wrapper.h"
@@ -32,7 +35,7 @@ bool DebugUtil::SpawnDebuggerOnProcess(u
   return false;
 }
 
-#if defined(OS_MACOSX)
+#if defined(OS_MACOSX) || defined(OS_BSD)
 
 // Based on Apple's recommended method as described in
 // http://developer.apple.com/qa/qa2004/qa1361.html
@@ -51,14 +54,22 @@ bool DebugUtil::BeingDebugged() {
   // we're looking for information about a specific process ID.
   int mib[] = {
     CTL_KERN,
+#if defined(OS_NETBSD)
+    KERN_PROC2,
+#else
     KERN_PROC,
+#endif
     KERN_PROC_PID,
     getpid()
   };
 
   // Caution: struct kinfo_proc is marked __APPLE_API_UNSTABLE.  The source and
   // binary interfaces may change.
+#if defined(OS_NETBSD)
+  struct kinfo_proc2 info;
+#else
   struct kinfo_proc info;
+#endif
   size_t info_size = sizeof(info);
 
   int sysctl_result = sysctl(mib, arraysize(mib), &info, &info_size, NULL, 0);
@@ -71,7 +82,17 @@ bool DebugUtil::BeingDebugged() {
 
   // This process is being debugged if the P_TRACED flag is set.
   is_set = true;
+#if defined(__DragonFly__)
+  being_debugged = (info.kp_flags & P_TRACED) != 0;
+#elif defined(OS_FREEBSD)
+  being_debugged = (info.ki_flag & P_TRACED) != 0;
+#elif defined(OS_OPENBSD)
+  being_debugged = (info.p_flag & P_TRACED) != 0;
+#elif defined(OS_NETBSD)
+  being_debugged = (info.p_flag & P_TRACED) != 0;
+#else
   being_debugged = (info.kp_proc.p_flag & P_TRACED) != 0;
+#endif
   return being_debugged;
 }
 
