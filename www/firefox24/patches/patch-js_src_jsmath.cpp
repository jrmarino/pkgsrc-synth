$NetBSD: patch-js_src_jsmath.cpp,v 1.1 2013/11/03 04:51:59 ryoon Exp $

--- js/src/jsmath.cpp.orig	2013-09-10 03:43:36.000000000 +0000
+++ js/src/jsmath.cpp
@@ -244,7 +244,7 @@ js::ecmaAtan2(double y, double x)
     }
 #endif
 
-#if defined(SOLARIS) && defined(__GNUC__)
+#if defined(notSOLARIS) && defined(__GNUC__)
     if (y == 0) {
         if (IsNegativeZero(x))
             return js_copysign(M_PI, y);
