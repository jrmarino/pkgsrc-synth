--- mk/compiler/gcc.mk.orig	2016-10-10 08:26:08 UTC
+++ mk/compiler/gcc.mk
@@ -742,12 +742,19 @@ _COMPILER_RPATH_FLAG=	-Wl,${_LINKER_RPAT
 # Ensure that the correct rpath is passed to the linker if we need to
 # link against gcc shared libs.
 #
+
+# This whole thing is ridiculous.  grep | grep | sed when a single awk would
+# do.  No wonder pkgsrc framework is so slow
+.if ${PKG_FORMAT:Mpkgng}
+_INFO_OPTIONS=	-qeg
+_GRAB_GCC_BASE=	${PKG_INFO} -lg ${_GCC_PKGBASE} |  ${AWK} -F '/bin/' '/\/bin\/gcc/ {n=split($$1,a,"/"); print a[n] "/"; exit 0}'
+.else
+_INFO_OPTIONS=	-qe
+_GRAB_GCC_BASE=	${PKG_INFO} -f ${_GCC_PKGBASE} | ${GREP} 'File:.*bin/gcc' | ${GREP} -v '/gcc[0-9][0-9]*-.*' | ${SED} -e 's/.*File: *//;s/bin\/gcc.*//;q'
+.endif
 _GCC_SUBPREFIX!=	\
-	if ${PKG_INFO} -qe ${_GCC_PKGBASE}; then			\
-		${PKG_INFO} -f ${_GCC_PKGBASE} |			\
-		${GREP} "File:.*bin/gcc" |				\
-		${GREP} -v "/gcc[0-9][0-9]*-.*" |			\
-		${SED} -e "s/.*File: *//;s/bin\/gcc.*//;q";		\
+	if ${PKG_INFO} ${_INFO_OPTIONS} ${_GCC_PKGBASE}; then		\
+		${_GRAB_GCC_BASE};					\
 	else								\
 		case ${_CC} in						\
 		${LOCALBASE}/*)						\
