$NetBSD: patch-mozilla_media_mtransport_third__party_nrappkit_src_util_util.c,v 1.1 2014/07/27 05:36:07 ryoon Exp $

--- mozilla/media/mtransport/third_party/nrappkit/src/util/util.c.orig	2013-10-23 22:09:11.000000000 +0000
+++ mozilla/media/mtransport/third_party/nrappkit/src/util/util.c
@@ -45,6 +45,7 @@ static char *RCSSTRING __UNUSED__ ="$Id:
 #include <dirent.h>
 #endif
 #include <string.h>
+#include <errno.h>
 #include <ctype.h>
 #include <sys/stat.h>
 #ifdef OPENSSL
