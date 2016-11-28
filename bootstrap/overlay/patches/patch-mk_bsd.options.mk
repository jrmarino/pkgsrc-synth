--- mk/bsd.options.mk.orig	2016-11-28 04:23:03 UTC
+++ mk/bsd.options.mk
@@ -158,6 +158,7 @@ _PKG_VARS.options=	PKG_SUPPORTED_OPTIONS
 	PKG_OPTIONS_NONEMPTY_SETS PKG_SUGGESTED_OPTIONS			\
 	PKG_OPTIONS_LEGACY_VARS PKG_OPTIONS_LEGACY_OPTS			\
 	PKG_LEGACY_OPTIONS PKG_OPTIONS_DEPRECATED_WARNINGS
+_PKG_VARS.options+=	PKG_DESELECTED_OPTIONS
 _SYS_VARS.options=	PKG_OPTIONS
 
 .include "bsd.prefs.mk"
@@ -216,6 +217,8 @@ _PKG_OPTIONS_ALL_SETS+=	${_opt_}
 .  endfor
 .endfor
 
+PKG_DESELECTED_OPTIONS:=	${PKG_SUPPORTED_OPTIONS:O:u}
+
 #
 # include deprecated variable to options mapping
 #
@@ -360,6 +363,10 @@ PKG_FAIL_REASON+=	"[bsd.options.mk] The
 .undef _OPTIONS_DEFAULT_SUPPORTED
 PKG_OPTIONS:=	${PKG_OPTIONS:O:u}
 
+.for _opt_ in ${PKG_OPTIONS}
+PKG_DESELECTED_OPTIONS:=	${PKG_DESELECTED_OPTIONS:N${_opt_}}
+.endfor
+
 _PKG_OPTIONS_WORDWRAP_FILTER=						\
 	${XARGS} -n 1 |							\
 	${AWK} '							\
