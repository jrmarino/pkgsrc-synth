$NetBSD: patch-mozilla_dom_plugins_ipc_PluginModuleChild.h,v 1.1 2014/07/27 05:36:07 ryoon Exp $

--- mozilla/dom/plugins/ipc/PluginModuleChild.h.orig	2013-10-23 22:08:54.000000000 +0000
+++ mozilla/dom/plugins/ipc/PluginModuleChild.h
@@ -328,7 +328,7 @@ private:
 
     // we get this from the plugin
     NP_PLUGINSHUTDOWN mShutdownFunc;
-#if defined(OS_LINUX) || defined(OS_BSD)
+#if defined(OS_LINUX) || defined(OS_BSD) || defined(OS_SOLARIS)
     NP_PLUGINUNIXINIT mInitializeFunc;
 #elif defined(OS_WIN) || defined(OS_MACOSX)
     NP_PLUGININIT mInitializeFunc;
