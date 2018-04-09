$NetBSD: patch-Source_WTF_wtf_dtoa_utils.h,v 1.1 2018/04/09 08:33:48 wiz Exp $

Add support for sparc64.

From OpenBSD ports.

--- Source/WTF/wtf/dtoa/utils.h.orig	Wed Mar  4 15:25:16 2015
+++ Source/WTF/wtf/dtoa/utils.h	Fri Mar 27 10:18:18 2015
@@ -49,7 +49,7 @@
 defined(__ARMEL__) || \
 defined(_MIPS_ARCH_MIPS32R2)
 #define DOUBLE_CONVERSION_CORRECT_DOUBLE_OPERATIONS 1
-#elif CPU(MIPS) || CPU(MIPS64) || CPU(PPC) || CPU(PPC64) || CPU(PPC64LE) || CPU(SH4) || CPU(S390) || CPU(S390X) || CPU(IA64) || CPU(ALPHA) || CPU(ARM64) || CPU(HPPA)
+#elif CPU(MIPS) || CPU(MIPS64) || CPU(PPC) || CPU(PPC64) || CPU(PPC64LE) || CPU(SH4) || CPU(S390) || CPU(S390X) || CPU(IA64) || CPU(ALPHA) || CPU(ARM64) || CPU(HPPA) || CPU(SPARC64)
 #define DOUBLE_CONVERSION_CORRECT_DOUBLE_OPERATIONS 1
 #elif defined(_M_IX86) || defined(__i386__)
 #if defined(_WIN32)
