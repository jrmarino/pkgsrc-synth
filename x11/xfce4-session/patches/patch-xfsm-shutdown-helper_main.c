$NetBSD: patch-xfsm-shutdown-helper_main.c,v 1.3 2018/05/16 18:06:04 youri Exp $

Add NetBSD commands.
... and be careful to only SUSPEND or HIBERNATE when defined.

--- xfsm-shutdown-helper/main.c.orig	2014-08-28 15:52:27.000000000 +0000
+++ xfsm-shutdown-helper/main.c
@@ -91,7 +91,10 @@
 #define UP_BACKEND_SUSPEND_COMMAND	"/usr/sbin/zzz"
 #define UP_BACKEND_HIBERNATE_COMMAND "/usr/sbin/ZZZ"
 #endif
-
+#ifdef BACKEND_TYPE_NETBSD
+#define UP_BACKEND_SUSPEND_COMMAND      "/sbin/sysctl -w hw.acpi.sleep.state=1"
+#define UP_BACKEND_HIBERNATE_COMMAND    "/sbin/sysctl -w hw.acpi.sleep.state=4"
+#endif
 
 static gboolean
 run (const gchar *command)
@@ -217,22 +220,26 @@ main (int argc, char **argv)
     }
   else if(suspend)
     {
+#if defined(UP_BACKEND_SUSPEND_COMMAND)
       if (run (UP_BACKEND_SUSPEND_COMMAND))
           {
             return EXIT_CODE_SUCCESS;
           }
         else
+#endif
           {
             return EXIT_CODE_FAILED;
           }
     }
   else if(hibernate)
     {
+#if defined (UP_BACKEND_HIBERNATE_COMMAND)
       if (run (UP_BACKEND_HIBERNATE_COMMAND))
           {
             return EXIT_CODE_SUCCESS;
           }
         else
+#endif
           {
             return EXIT_CODE_FAILED;
           }
