$NetBSD: patch-ipc_chromium_src_base_message__loop.cc,v 1.1 2013/01/10 16:17:10 ryoon Exp $

--- ipc/chromium/src/base/message_loop.cc.orig	2012-08-24 22:55:37.000000000 +0000
+++ ipc/chromium/src/base/message_loop.cc
@@ -19,7 +19,7 @@
 #if defined(OS_POSIX)
 #include "base/message_pump_libevent.h"
 #endif
-#if defined(OS_LINUX)
+#if defined(OS_LINUX) || defined(OS_BSD)
 #ifdef MOZ_WIDGET_GTK2
 #include "base/message_pump_glib.h"
 #endif
@@ -119,7 +119,7 @@ MessageLoop::MessageLoop(Type type)
   if (type_ == TYPE_UI) {
 #if defined(OS_MACOSX)
     pump_ = base::MessagePumpMac::Create();
-#elif defined(OS_LINUX)
+#elif defined(OS_LINUX) || defined(OS_BSD)
     pump_ = new base::MessagePumpForUI();
 #endif  // OS_LINUX
   } else if (type_ == TYPE_IO) {
