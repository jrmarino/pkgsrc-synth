$NetBSD: patch-config-scripts_cups-compiler.m4,v 1.2 2015/12/02 21:14:16 leot Exp $

Some builds of gcc seem to support this for compiling but then fail during
linking with undefined reference to `__stack_chk_fail_local'

--- config-scripts/cups-compiler.m4.orig	2015-06-23 14:48:53.000000000 +0000
+++ config-scripts/cups-compiler.m4
@@ -113,12 +113,13 @@ if test -n "$GCC"; then
 	AC_MSG_CHECKING(whether compiler supports -fstack-protector)
 	OLDCFLAGS="$CFLAGS"
 	CFLAGS="$CFLAGS -fstack-protector"
-	AC_TRY_LINK(,,
+	AC_TRY_LINK(, [return 0;],
 		if test "x$LSB_BUILD" = xy; then
 			# Can't use stack-protector with LSB binaries...
 			OPTIM="$OPTIM -fno-stack-protector"
 		else
 			OPTIM="$OPTIM -fstack-protector"
+			LIBS="$LIBS $LIBS_SSP"
 		fi
 		AC_MSG_RESULT(yes),
 		AC_MSG_RESULT(no))
