$NetBSD: patch-dom_media_AudioStream.h,v 1.1 2015/07/09 14:13:52 ryoon Exp $

--- dom/media/AudioStream.h.orig	2015-02-17 21:40:44.000000000 +0000
+++ dom/media/AudioStream.h
@@ -17,7 +17,7 @@
 #include "CubebUtils.h"
 
 namespace soundtouch {
-class SoundTouch;
+class MOZ_IMPORT_API SoundTouch;
 }
 
 namespace mozilla {
