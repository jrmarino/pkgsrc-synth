--- mk/platform/DragonFly.mk.orig	2016-10-26 01:00:31 UTC
+++ mk/platform/DragonFly.mk
@@ -24,6 +24,12 @@ ULIMIT_CMD_datasize?=	ulimit -d `ulimit
 ULIMIT_CMD_stacksize?=	ulimit -s `ulimit -H -s`
 ULIMIT_CMD_memorysize?=	ulimit -m `ulimit -H -m`
 ULIMIT_CMD_cputime?=	ulimit -t `ulimit -H -t`
+USE_BUILTIN.termcap=	NO
+USE_BUILTIN.curses=	NO
+USE_BUILTIN.ncurses=	NO
+USE_BUILTIN.readline=	NO
+CURSES_DEFAULT=		ncurses
+READLINE_DEFAULT=	readline
 
 _OPSYS_EMULDIR.linux=	/compat/linux
 
