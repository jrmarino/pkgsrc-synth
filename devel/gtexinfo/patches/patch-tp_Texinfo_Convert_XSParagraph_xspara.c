$NetBSD: patch-tp_Texinfo_Convert_XSParagraph_xspara.c,v 1.3 2018/08/30 11:27:48 tnn Exp $

>From 9031aefb7f180f718db83aec5e2782079455a32f Mon Sep 17 00:00:00 2001
From: Niko Tyni <address@hidden>
Date: Sat, 30 Jun 2018 16:51:13 +0100
Subject: [PATCH] Update locale handling for Perl 5.28

Perl 5.28 introduced thread-safe locales, where setlocale()
only affects the locale of the current thread. External code
like mbrtowc(3) isn't aware of this thread specific locale,
so we need to explicitly modify the global one instead.

Without this we could enter a busy loop in xspara__add_next()
(Texinfo::Convert::XSParagraph) for UTF-8 documents when mbrtowc(3)
returned -1.
---
 tp/Texinfo/Convert/XSParagraph/xspara.c | 9 +++++++++
 1 file changed, 9 insertions(+)

--- tp/Texinfo/Convert/XSParagraph/xspara.c.orig	2017-06-18 15:38:01.000000000 +0000
+++ tp/Texinfo/Convert/XSParagraph/xspara.c
@@ -248,6 +248,11 @@ xspara_init (void)
 
   dTHX;
 
+#if PERL_VERSION > 27 || (PERL_VERSION == 27 && PERL_SUBVERSION > 8)
+  /* needed due to thread-safe locale handling in newer perls */
+  switch_to_global_locale();
+#endif
+
   if (setlocale (LC_CTYPE, "en_US.UTF-8")
       || setlocale (LC_CTYPE, "en_US.utf8"))
     goto success;
@@ -320,6 +325,10 @@ failure:
     {
 success: ;
       free (utf8_locale);
+#if PERL_VERSION > 27 || (PERL_VERSION == 27 && PERL_SUBVERSION > 8)
+      /* needed due to thread-safe locale handling in newer perls */
+      sync_locale();
+#endif
       /*
       fprintf (stderr, "tried to set LC_CTYPE to UTF-8.\n");
       fprintf (stderr, "character encoding is: %s\n",
