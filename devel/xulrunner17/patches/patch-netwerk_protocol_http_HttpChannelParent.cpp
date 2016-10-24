$NetBSD: patch-netwerk_protocol_http_HttpChannelParent.cpp,v 1.1 2013/01/10 16:17:10 ryoon Exp $

* Fix build with gcc<4.5, for example, DragonFly 3.0.1.
  See https://bugzilla.mozilla.org/show_bug.cgi?id=621446

--- netwerk/protocol/http/HttpChannelParent.cpp.orig	2012-08-24 22:55:58.000000000 +0000
+++ netwerk/protocol/http/HttpChannelParent.cpp
@@ -299,6 +299,13 @@ HttpChannelParent::RecvUpdateAssociatedC
   return true;
 }
 
+// Compiling with a version of GCC <= 4.4 fails with an internal compiler
+// error.
+#if !defined(__GNUC__) || \
+  (__GNUC__ >= 5) || (__GNUC__ == 4 && __GNUC_MINOR__ >= 5)
+#pragma GCC optimize ("O0")
+#endif
+
 bool
 HttpChannelParent::RecvRedirect2Verify(const nsresult& result, 
                                        const RequestHeaderTuples& changedHeaders)
