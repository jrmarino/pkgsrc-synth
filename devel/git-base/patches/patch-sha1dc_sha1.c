$NetBSD: patch-sha1dc_sha1.c,v 1.4 2017/06/08 09:08:51 wiz Exp $

Fix endianness issue using upstream commit
https://github.com/git/git/commit/6b851e536b05e0c8c61f77b9e4c3e7cedea39ff8

--- sha1dc/sha1.c.orig	2017-06-05 01:08:11.000000000 +0000
+++ sha1dc/sha1.c
@@ -35,15 +35,33 @@
 #ifdef SHA1DC_BIGENDIAN
 #undef SHA1DC_BIGENDIAN
 #endif
-#if (!defined SHA1DC_FORCE_LITTLEENDIAN) && \
-    ((defined(__BYTE_ORDER) && (__BYTE_ORDER == __BIG_ENDIAN)) || \
-    (defined(__BYTE_ORDER__) && (__BYTE_ORDER__ == __BIG_ENDIAN__)) || \
-    defined(_BIG_ENDIAN) || defined(__BIG_ENDIAN__) || defined(__ARMEB__) || defined(__THUMBEB__) ||  defined(__AARCH64EB__) || \
-    defined(_MIPSEB) || defined(__MIPSEB) || defined(__MIPSEB__) || defined(SHA1DC_FORCE_BIGENDIAN))
 
+#if (defined(_BYTE_ORDER) || defined(__BYTE_ORDER) || defined(__BYTE_ORDER__))
+
+#if ((defined(_BYTE_ORDER) && (_BYTE_ORDER == _BIG_ENDIAN)) || \
+     (defined(__BYTE_ORDER) && (__BYTE_ORDER == __BIG_ENDIAN)) || \
+     (defined(__BYTE_ORDER__) && (__BYTE_ORDER__ == __BIG_ENDIAN__)) )
 #define SHA1DC_BIGENDIAN
+#endif
+
+#else
+
+#if (defined(_BIG_ENDIAN) || defined(__BIG_ENDIAN) || defined(__BIG_ENDIAN__) || \
+     defined(__ARMEB__) || defined(__THUMBEB__) || defined(__AARCH64EB__) || \
+     defined(__MIPSEB__) || defined(__MIPSEB) || defined(_MIPSEB) || \
+     defined(__sparc))
+#define SHA1DC_BIGENDIAN
+#endif
 
-#endif /*ENDIANNESS SELECTION*/
+#endif
+
+#if (defined(SHA1DC_FORCE_LITTLEENDIAN) && defined(SHA1DC_BIGENDIAN))
+#undef SHA1DC_BIGENDIAN
+#endif
+#if (defined(SHA1DC_FORCE_BIGENDIAN) && !defined(SHA1DC_BIGENDIAN))
+#define SHA1DC_BIGENDIAN
+#endif
+/*ENDIANNESS SELECTION*/
 
 #if (defined SHA1DC_FORCE_UNALIGNED_ACCESS || \
      defined(__amd64__) || defined(__amd64) || defined(__x86_64__) || defined(__x86_64) || \
