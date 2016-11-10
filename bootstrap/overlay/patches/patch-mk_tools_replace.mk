--- mk/tools/replace.mk.orig	2016-04-08 13:12:33 UTC
+++ mk/tools/replace.mk
@@ -503,6 +503,21 @@ TOOLS_PATH.ident=		${LOCALBASE}/bin/iden
 .  endif
 .endif
 
+.if !defined(TOOLS_IGNORE.indexinfo) && !empty(_USE_TOOLS:Mindexinfo)
+.  if !empty(PKGPATH:Mprint/indexinfo)
+MAKEFLAGS+=			TOOLS_IGNORE.indexinfo=
+.  elif !empty(_TOOLS_USE_PKGSRC.indexinfo:M[yY][eE][sS])
+TOOLS_DEPENDS.indexinfo?=	indexinfo-[0-9]*:../../print/indexinfo
+TOOLS_CREATE+=			indexinfo
+TOOLS_PATH.indexinfo=		${LOCALBASE}/bin/indexinfo
+.  endif
+.endif
+#
+# Always create an indexinfo tool that is a "no operation" command, as
+# registration of info files is handled by the INSTALL script.
+#
+TOOLS_SCRIPT.indexinfo=	exit 0
+
 .if !defined(TOOLS_IGNORE.install-info) && !empty(_USE_TOOLS:Minstall-info)
 .  if !empty(PKGPATH:Mpkgtools/pkg_install-info)
 MAKEFLAGS+=			TOOLS_IGNORE.install-info=
