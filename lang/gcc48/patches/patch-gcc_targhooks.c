$NetBSD: patch-gcc_targhooks.c,v 1.1 2018/07/18 23:15:42 maya Exp $

PR pkg/53436
netbsd can't handle hidden reference to stack_chk_fail_local.
(note: this code is only happening if targeting i386)

--- gcc/targhooks.c.orig	2013-01-10 20:38:27.000000000 +0000
+++ gcc/targhooks.c
@@ -692,7 +692,7 @@ default_external_stack_protect_fail (voi
 tree
 default_hidden_stack_protect_fail (void)
 {
-#ifndef HAVE_GAS_HIDDEN
+#if !defined(HAVE_GAS_HIDDEN) || defined(__NetBSD__) || defined(__sun)                                                                       
   return default_external_stack_protect_fail ();
 #else
   tree t = stack_chk_fail_decl;
