$NetBSD: patch-media_libcubeb_update.sh,v 1.2 2017/04/27 01:49:47 ryoon Exp $

--- media/libcubeb/update.sh.orig	2017-04-11 04:15:21.000000000 +0000
+++ media/libcubeb/update.sh
@@ -17,6 +17,7 @@ cp $1/src/cubeb_audiounit.cpp src
 cp $1/src/cubeb_osx_run_loop.h src
 cp $1/src/cubeb_jack.cpp src
 cp $1/src/cubeb_opensl.c src
+cp $1/src/cubeb_oss.c src
 cp $1/src/cubeb_array_queue.h src
 cp $1/src/cubeb_panner.cpp src
 cp $1/src/cubeb_panner.h src
