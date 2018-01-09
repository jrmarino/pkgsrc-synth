$NetBSD: patch-libguile_loader.c,v 1.1 2018/01/08 22:37:08 joerg Exp $

--- libguile/loader.c.orig	2018-01-08 16:21:04.790894906 +0000
+++ libguile/loader.c
@@ -484,7 +484,7 @@ map_file_contents (int fd, size_t len, i
   char *data;
 
 #ifdef HAVE_SYS_MMAN_H
-  data = mmap (NULL, len, PROT_READ, MAP_PRIVATE, fd, 0);
+  data = mmap (NULL, len, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
   if (data == MAP_FAILED)
     SCM_SYSERROR;
   *is_read_only = 1;
