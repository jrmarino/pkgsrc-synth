$NetBSD: patch-mozilla_media_libcubeb_src_cubeb.c,v 1.1 2016/04/17 18:22:21 ryoon Exp $

--- mozilla/media/libcubeb/src/cubeb.c.orig	2015-06-08 17:49:22.000000000 +0000
+++ mozilla/media/libcubeb/src/cubeb.c
@@ -56,6 +56,9 @@ int opensl_init(cubeb ** context, char c
 #if defined(USE_AUDIOTRACK)
 int audiotrack_init(cubeb ** context, char const * context_name);
 #endif
+#if defined(USE_OSS)
+int oss_init(cubeb ** context, char const * context_name);
+#endif
 
 int
 validate_stream_params(cubeb_stream_params stream_params)
@@ -122,6 +125,9 @@ cubeb_init(cubeb ** context, char const 
 #if defined(USE_AUDIOTRACK)
     audiotrack_init,
 #endif
+#if defined(USE_OSS)
+    oss_init,
+#endif
   };
   int i;
 
