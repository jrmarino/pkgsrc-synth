$NetBSD: patch-txgithub_scripts_create__token.py,v 1.2 2017/10/01 09:52:19 wiz Exp $

Fix for python-3.x.
https://github.com/tomprince/txgithub/issues/13

--- txgithub/scripts/create_token.py.orig	2017-09-30 20:46:53.750550950 +0000
+++ txgithub/scripts/create_token.py
@@ -34,7 +34,7 @@ def run(reactor, *argv):
     config = Options()
     try:
         config.parseOptions(argv[1:]) # When given no argument, parses sys.argv[1:]
-    except usage.UsageError, errortext:
+    except usage.UsageError as errortext:
         print('%s: %s' % (argv[0], errortext))
         print('%s: Try --help for usage details.' % (argv[0]))
         sys.exit(1)
