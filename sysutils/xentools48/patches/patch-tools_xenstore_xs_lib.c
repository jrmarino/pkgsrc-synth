$NetBSD: patch-tools_xenstore_xs_lib.c,v 1.1 2018/03/13 15:15:01 bouyer Exp $

--- tools/xenstore/xs_lib.c.orig
+++ tools/xenstore/xs_lib.c
@@ -52,7 +52,7 @@ static const char *xs_daemon_path(void)
 const char *xs_daemon_tdb(void)
 {
 	static char buf[PATH_MAX];
-	snprintf(buf, sizeof(buf), "%s/tdb", xs_daemon_rootdir());
+	snprintf(buf, sizeof(buf), "%s/tdb", xs_daemon_rundir());
 	return buf;
 }
 
