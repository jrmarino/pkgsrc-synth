$NetBSD: patch-kcal_icalformat_p.cpp,v 1.1 2018/04/26 07:55:21 markd Exp $

work with libical-3

--- kcal/icalformat_p.cpp.orig	2015-06-24 12:43:14.000000000 +0000
+++ kcal/icalformat_p.cpp
@@ -2087,7 +2087,6 @@ icaltimetype ICalFormatImpl::writeICalDa
   t.second = 0;
 
   t.is_date = 1;
-  t.is_utc = 0;
   t.zone = 0;
 
   return t;
@@ -2107,7 +2106,9 @@ icaltimetype ICalFormatImpl::writeICalDa
 
   t.is_date = 0;
   t.zone = 0;   // zone is NOT set
-  t.is_utc = datetime.isUtc() ? 1 : 0;
+  if (datetime.isUtc()) {
+    t = icaltime_convert_to_zone(t, icaltimezone_get_utc_timezone());
+  }
 
   // _dumpIcaltime( t );
 
@@ -2174,7 +2175,7 @@ icalproperty *ICalFormatImpl::writeICalD
   }
 
   KTimeZone ktz;
-  if ( !t.is_utc ) {
+  if ( !icaltime_is_utc(t) ) {
     ktz = dt.timeZone();
   }
 
@@ -2207,7 +2208,7 @@ KDateTime ICalFormatImpl::readICalDateTi
 //  _dumpIcaltime( t );
 
   KDateTime::Spec timeSpec;
-  if ( t.is_utc  ||  t.zone == icaltimezone_get_utc_timezone() ) {
+  if ( icaltime_is_utc(t)  ||  t.zone == icaltimezone_get_utc_timezone() ) {
     timeSpec = KDateTime::UTC;   // the time zone is UTC
     utc = false;    // no need to convert to UTC
   } else {
