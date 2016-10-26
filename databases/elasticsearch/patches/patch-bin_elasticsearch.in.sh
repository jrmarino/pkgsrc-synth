$NetBSD: patch-bin_elasticsearch.in.sh,v 1.7 2016/10/26 13:56:30 fhajny Exp $

Fix paths.

--- bin/elasticsearch.in.sh.orig	2015-10-21 08:41:12.000000000 +0000
+++ bin/elasticsearch.in.sh
@@ -10,7 +10,7 @@ EOF
     exit 1
 fi
 
-ES_CLASSPATH="$ES_HOME/lib/elasticsearch-2.4.1.jar:$ES_HOME/lib/*"
+ES_CLASSPATH="@ES_LIBDIR@/elasticsearch-2.4.1.jar:@ES_LIBDIR@/*"
 
 if [ "x$ES_MIN_MEM" = "x" ]; then
     ES_MIN_MEM=256m
