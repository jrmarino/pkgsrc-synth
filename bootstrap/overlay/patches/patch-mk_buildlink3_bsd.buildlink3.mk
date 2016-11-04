--- mk/buildlink3/bsd.buildlink3.mk.orig	2016-11-04 20:49:07 UTC
+++ mk/buildlink3/bsd.buildlink3.mk
@@ -371,9 +371,11 @@ MAKEVARS+=	_BLNK_PKG_DBDIR.${_pkg_}
 .  endif
 
 .  if empty(_BLNK_PKG_DBDIR.${_pkg_}:M*not_found)
-_BLNK_PKG_INFO.${_pkg_}?=	${PKG_INFO_CMD} -K ${_BLNK_PKG_DBDIR.${_pkg_}:H}
+_BLNK_PKG_INFO.${_pkg_}?=	${PKGSRC_SETENV} PKG_DBDIR="${_BLNK_PKG_DBDIR.${_pkg_}:H}" \
+				${PKG_INFO_CMD}
 .  else
-_BLNK_PKG_INFO.${_pkg_}?=	${PKG_INFO_CMD} -K ${_PKG_DBDIR}
+_BLNK_PKG_INFO.${_pkg_}?=	${PKGSRC_SETENV} PKG_DBDIR="${_PKG_DBDIR}" \
+				${PKG_INFO_CMD}
 .  endif
 
 BUILDLINK_PKGNAME.${_pkg_}?=	${_BLNK_PKG_DBDIR.${_pkg_}:T}
@@ -623,8 +625,8 @@ BUILDLINK_CONTENTS_FILTER.${_pkg_}?=
 	${EGREP} '(include.*/|\.h$$|\.idl$$|\.pc$$|/lib[^/]*\.[^/]*$$)'
 # XXX: Why not pkg_info -qL?
 BUILDLINK_FILES_CMD.${_pkg_}?=						\
-	${_BLNK_PKG_INFO.${_pkg_}} -f ${BUILDLINK_PKGNAME.${_pkg_}} |	\
-	${SED} -n '/File:/s/^[ 	]*File:[ 	]*//p' |		\
+	${_BLNK_PKG_INFO.${_pkg_}} -lq ${BUILDLINK_PKGNAME.${_pkg_}} |	\
+	${SED} 's|${PREFIX}/||' | \
 	${BUILDLINK_CONTENTS_FILTER.${_pkg_}} | ${CAT}
 
 # _BLNK_FILES_CMD.<pkg> combines BUILDLINK_FILES_CMD.<pkg> and
