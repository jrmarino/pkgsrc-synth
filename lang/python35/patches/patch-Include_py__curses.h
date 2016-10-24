$NetBSD: patch-Include_py__curses.h,v 1.1 2015/12/05 17:12:13 adam Exp $

* On NetBSD, [n]curses.h and stdlib.h/wchar.h use different guards
  against multiple definition of wchar_t and wint_t.
http://bugs.python.org/issue21457

--- Include/py_curses.h.orig	2009-09-06 21:26:46.000000000 +0000
+++ Include/py_curses.h
@@ -44,6 +44,21 @@
 #endif
 #endif
 
+#ifdef __NetBSD__
+/*
+** On NetBSD, [n]curses.h and stdlib.h/wchar.h use different guards
+** against multiple definition of wchar_t and wint_t.
+*/
+#ifdef	_XOPEN_SOURCE_EXTENDED
+#ifndef _WCHAR_T
+#define _WCHAR_T
+#endif
+#ifndef _WINT_T
+#define _WINT_T
+#endif
+#endif
+#endif
+
 #ifdef HAVE_NCURSES_H
 #include <ncurses.h>
 #else
