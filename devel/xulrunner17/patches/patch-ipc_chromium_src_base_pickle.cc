$NetBSD: patch-ipc_chromium_src_base_pickle.cc,v 1.1 2013/07/16 22:27:45 joerg Exp $

--- ipc/chromium/src/base/pickle.cc.orig	2013-06-18 18:47:18.000000000 +0000
+++ ipc/chromium/src/base/pickle.cc
@@ -492,7 +492,7 @@ char* Pickle::BeginWriteData(int length)
     "There can only be one variable buffer in a Pickle";
 
   if (!WriteInt(length))
-    return false;
+    return NULL;
 
   char *data_ptr = BeginWrite(length, sizeof(uint32));
   if (!data_ptr)
