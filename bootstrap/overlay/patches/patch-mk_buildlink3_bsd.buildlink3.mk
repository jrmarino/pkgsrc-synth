--- mk/buildlink3/bsd.buildlink3.mk.orig	2016-11-04 19:08:48 UTC
+++ mk/buildlink3/bsd.buildlink3.mk
@@ -625,8 +625,8 @@ BUILDLINK_CONTENTS_FILTER.${_pkg_}?=
 	${EGREP} '(include.*/|\.h$$|\.idl$$|\.pc$$|/lib[^/]*\.[^/]*$$)'
 # XXX: Why not pkg_info -qL?
 BUILDLINK_FILES_CMD.${_pkg_}?=						\
-	${_BLNK_PKG_INFO.${_pkg_}} -f ${BUILDLINK_PKGNAME.${_pkg_}} |	\
-	${SED} -n '/File:/s/^[ 	]*File:[ 	]*//p' |		\
+	${_BLNK_PKG_INFO.${_pkg_}} -lq ${BUILDLINK_PKGNAME.${_pkg_}} |	\
+	${SED} 's|${PREFIX}/||' | \
 	${BUILDLINK_CONTENTS_FILTER.${_pkg_}} | ${CAT}
 
 # _BLNK_FILES_CMD.<pkg> combines BUILDLINK_FILES_CMD.<pkg> and
