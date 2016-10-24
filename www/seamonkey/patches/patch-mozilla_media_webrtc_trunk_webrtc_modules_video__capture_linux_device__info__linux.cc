$NetBSD: patch-mozilla_media_webrtc_trunk_webrtc_modules_video__capture_linux_device__info__linux.cc,v 1.6 2014/11/02 05:40:31 ryoon Exp $

--- mozilla/media/webrtc/trunk/webrtc/modules/video_capture/linux/device_info_linux.cc.orig	2014-10-14 06:36:31.000000000 +0000
+++ mozilla/media/webrtc/trunk/webrtc/modules/video_capture/linux/device_info_linux.cc
@@ -25,10 +25,21 @@
 #else
 #include <linux/videodev2.h>
 #endif
+#ifdef HAVE_LIBV4L2
+#include <libv4l2.h>
+#endif
 
 #include "webrtc/system_wrappers/interface/ref_count.h"
 #include "webrtc/system_wrappers/interface/trace.h"
 
+#ifdef HAVE_LIBV4L2
+#define open	v4l2_open
+#define close	v4l2_close
+#define dup	v4l2_dup
+#define ioctl	v4l2_ioctl
+#define mmap	v4l2_mmap
+#define munmap	v4l2_munmap
+#endif
 
 namespace webrtc
 {
@@ -136,6 +147,11 @@ int32_t DeviceInfoLinux::GetDeviceName(
     memset(deviceNameUTF8, 0, deviceNameLength);
     memcpy(cameraName, cap.card, sizeof(cap.card));
 
+    if (cameraName[0] == '\0')
+    {
+        sprintf(cameraName, "Camera at /dev/video%d", deviceNumber);
+    }
+
     if (deviceNameLength >= strlen(cameraName))
     {
         memcpy(deviceNameUTF8, cameraName, strlen(cameraName));
