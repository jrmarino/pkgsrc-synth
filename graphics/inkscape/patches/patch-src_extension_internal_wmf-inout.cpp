$NetBSD: patch-src_extension_internal_wmf-inout.cpp,v 1.1 2018/06/28 11:18:59 jperkin Exp $

Avoid ambiguous function calls.

--- src/extension/internal/wmf-inout.cpp.orig	2017-08-06 20:44:00.000000000 +0000
+++ src/extension/internal/wmf-inout.cpp
@@ -59,6 +59,8 @@
 #define U_PS_JOIN_MASK (U_PS_JOIN_BEVEL|U_PS_JOIN_MITER|U_PS_JOIN_ROUND)
 #endif
 
+using std::sqrt;
+
 namespace Inkscape {
 namespace Extension {
 namespace Internal {
