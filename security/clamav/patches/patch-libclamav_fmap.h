$NetBSD: patch-libclamav_fmap.h,v 1.1 2017/07/24 09:39:42 maya Exp $

rename gets to my_gets to avoid conflict with fortify/ssp - they use
macros to override libc functions

--- libclamav/fmap.h.orig	2016-04-22 15:02:19.000000000 +0000
+++ libclamav/fmap.h
@@ -74,7 +74,7 @@ struct cl_fmap {
     void        (*unmap)(fmap_t*);
     const void* (*need)(fmap_t*, size_t at, size_t len, int lock);
     const void* (*need_offstr)(fmap_t*, size_t at, size_t len_hint);
-    const void* (*gets)(fmap_t*, char *dst, size_t *at, size_t max_len);
+    const void* (*my_gets)(fmap_t*, char *dst, size_t *at, size_t max_len);
     void        (*unneed_off)(fmap_t*, size_t at, size_t len);
 #ifdef _WIN32
     HANDLE fh;
@@ -156,7 +156,7 @@ static inline const void *fmap_need_offs
 }
 
 static inline const void *fmap_gets(fmap_t *m, char *dst, size_t *at, size_t max_len) {
-    return m->gets(m, dst, at, max_len);
+    return m->my_gets(m, dst, at, max_len);
 }
 
 static inline const void *fmap_need_off_once_len(fmap_t *m, size_t at, size_t len, size_t *lenout)
