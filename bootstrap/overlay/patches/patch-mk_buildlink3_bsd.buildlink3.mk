diff --git mk/buildlink3/bsd.buildlink3.mk mk/buildlink3/bsd.buildlink3.mk
index 2265a75..b3c15b0 100644
--- mk/buildlink3/bsd.buildlink3.mk
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
