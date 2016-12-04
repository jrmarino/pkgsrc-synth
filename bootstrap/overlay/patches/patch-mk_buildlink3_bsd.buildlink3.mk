--- mk/buildlink3/bsd.buildlink3.mk.orig	2016-12-04 02:16:34 UTC
+++ mk/buildlink3/bsd.buildlink3.mk
@@ -351,17 +351,34 @@ BUILDLINK_LIBDIRS.${_pkg_}?=	lib${LIBABI
 #
 # Set a default for _BLNK_PKG_DBDIR.<pkg>, which is the directory
 # containing the package metadata.
+# Note: Not true for pkgng(!).  What's the impact?
 #
 .  if !defined(_BLNK_PKG_DBDIR.${_pkg_})
 _BLNK_PKG_DBDIR.${_pkg_}?=	# empty
 .    for _depend_ in ${BUILDLINK_API_DEPENDS.${_pkg_}}
 .      if empty(_BLNK_PKG_DBDIR.${_pkg_}:M*not_found)
 _BLNK_PKG_DBDIR.${_pkg_}!=	\
-	pkg=`${PKG_INFO} -E "${_depend_}" || ${TRUE}`;			\
-	case "$$pkg" in							\
-	"")	dir="_BLNK_PKG_DBDIR.${_pkg_}_not_found" ;;		\
-	*)	dir="${_PKG_DBDIR}/$$pkg";				\
+	SEQPROG='{b=index($$0,"{")+1; p=substr($$0,1,b-2); n=split(substr($$0,b,length($$0)-b),a,","); for (j=1;j<=n;j++) {print p a[j] " "}}'; \
+	found=0;							\
+	case "${_depend_}" in						\
+	*{*})	list=$$(echo ${_depend_} | awk "$$SEQPROG");		\
+		for item in $$list; do					\
+			pkg=`${PKG_INFO} -E "$$item" || ${TRUE}`;	\
+			if [ -n "$$pkg" ]; then				\
+				dir="${_PKG_DBDIR}/$$pkg";		\
+				found=1;				\
+				break;					\
+			fi;						\
+		done;							\
+		;;							\
+	*)	pkg=`${PKG_INFO} -E "${_depend_}" || ${TRUE}`;		\
+		if [ -n "$$pkg" ]; then					\
+			dir="${_PKG_DBDIR}/$$pkg";			\
+			found=1;					\
+		fi;							\
+		;;							\
 	esac;								\
+	[ $$found -eq 0 ] && dir="_BLNK_PKG_DBDIR.${_pkg_}_not_found";	\
 	${ECHO} $$dir
 .      endif
 .    endfor
@@ -371,9 +388,11 @@ MAKEVARS+=	_BLNK_PKG_DBDIR.${_pkg_}
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
@@ -623,8 +642,8 @@ BUILDLINK_CONTENTS_FILTER.${_pkg_}?=
 	${EGREP} '(include.*/|\.h$$|\.idl$$|\.pc$$|/lib[^/]*\.[^/]*$$)'
 # XXX: Why not pkg_info -qL?
 BUILDLINK_FILES_CMD.${_pkg_}?=						\
-	${_BLNK_PKG_INFO.${_pkg_}} -f ${BUILDLINK_PKGNAME.${_pkg_}} |	\
-	${SED} -n '/File:/s/^[ 	]*File:[ 	]*//p' |		\
+	${_BLNK_PKG_INFO.${_pkg_}} -lq ${BUILDLINK_PKGNAME.${_pkg_}} |	\
+	${SED} 's|${PREFIX}/||' | \
 	${BUILDLINK_CONTENTS_FILTER.${_pkg_}} | ${CAT}
 
 # _BLNK_FILES_CMD.<pkg> combines BUILDLINK_FILES_CMD.<pkg> and
