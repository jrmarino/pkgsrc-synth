diff --git mk/license.mk mk/license.mk
index 5580d5b..883c13e 100644
--- mk/license.mk
+++ mk/license.mk
@@ -180,13 +180,9 @@ SKIP_LICENSE_CHECK?=	no
 _ACCEPTABLE_LICENSE=	skipped
 .else
 _ACCEPTABLE_LICENSE!=	\
-    if test `${PKG_ADMIN} -V` -lt 20090528; then \
-	echo outdated; \
-    else \
 	${PKGSRC_SETENV} PKGSRC_ACCEPTABLE_LICENSES=${ACCEPTABLE_LICENSES:Q} \
 	PKGSRC_DEFAULT_ACCEPTABLE_LICENSES=${DEFAULT_ACCEPTABLE_LICENSES:Q} \
-	${PKG_ADMIN} check-license ${LICENSE:Q} || echo failure; \
-    fi
+	${PKG_ADMIN} check-license ${LICENSE:Q} || echo failure
 .endif
 
 .if ${_ACCEPTABLE_LICENSE} == "no"
