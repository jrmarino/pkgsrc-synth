$NetBSD: patch-bin_tests_system_metadata_tests.sh,v 1.2 2018/07/14 03:56:27 taca Exp $

* Avoid using "==" for argument of test(1).

--- bin/tests/system/metadata/tests.sh.orig	2018-07-03 05:28:20.000000000 +0000
+++ bin/tests/system/metadata/tests.sh
@@ -144,7 +144,7 @@ status=`expr $status + $ret`
 
 echo_i "checking warning about permissions change on key with dnssec-settime ($n)"
 uname=`uname -o 2> /dev/null`
-if [ Cygwin == "$uname"  ]; then
+if [ Cygwin = "$uname"  ]; then
 	echo_i "Cygwin detected, skipping"
 else
 	ret=0
