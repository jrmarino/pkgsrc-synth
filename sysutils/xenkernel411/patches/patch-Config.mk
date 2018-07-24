$NetBSD: patch-Config.mk,v 1.1 2018/07/24 13:40:11 bouyer Exp $

--- Config.mk.orig	2018-04-17 19:21:31.000000000 +0200
+++ Config.mk	2018-04-23 13:29:47.000000000 +0200
@@ -32,6 +32,9 @@
 # Tools to run on system hosting the build
 HOSTCFLAGS  = -Wall -Werror -Wstrict-prototypes -O2 -fomit-frame-pointer
 HOSTCFLAGS += -fno-strict-aliasing
+HOSTCFLAGS += ${EXTRA_CFLAGS}
+CFLAGS     += ${EXTRA_CFLAGS}
+
 
 DISTDIR     ?= $(XEN_ROOT)/dist
 DESTDIR     ?= /
