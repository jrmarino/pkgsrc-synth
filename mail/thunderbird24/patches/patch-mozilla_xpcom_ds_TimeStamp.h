$NetBSD: patch-mozilla_xpcom_ds_TimeStamp.h,v 1.1 2014/07/27 05:36:07 ryoon Exp $

--- mozilla/xpcom/ds/TimeStamp.h.orig	2013-10-23 22:09:21.000000000 +0000
+++ mozilla/xpcom/ds/TimeStamp.h
@@ -158,11 +158,11 @@ private:
     // NOTE: this MUST be a >= test, because int64_t(double(INT64_MAX))
     // overflows and gives INT64_MIN.
     if (aTicks >= double(INT64_MAX))
-      return TimeDuration::FromTicks(INT64_MAX);
+      return TimeDuration::FromTicks(int64_t(INT64_MAX));
 
     // This MUST be a <= test.
     if (aTicks <= double(INT64_MIN))
-      return TimeDuration::FromTicks(INT64_MIN);
+      return TimeDuration::FromTicks(int64_t(INT64_MIN));
 
     return TimeDuration::FromTicks(int64_t(aTicks));
   }
