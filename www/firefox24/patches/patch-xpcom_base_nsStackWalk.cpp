$NetBSD: patch-xpcom_base_nsStackWalk.cpp,v 1.1 2013/11/03 04:52:00 ryoon Exp $

--- xpcom/base/nsStackWalk.cpp.orig	2013-05-11 19:19:56.000000000 +0000
+++ xpcom/base/nsStackWalk.cpp
@@ -853,7 +853,7 @@ void DemangleSymbol(const char * aSymbol
 }
 
 
-#if NSSTACKWALK_SUPPORTS_SOLARIS
+#if notNSSTACKWALK_SUPPORTS_SOLARIS
 
 /*
  * Stack walking code for Solaris courtesy of Bart Smaalder's "memtrak".
