--- mk/alternatives.mk.orig	2015-11-25 13:05:47 UTC
+++ mk/alternatives.mk
@@ -40,13 +40,17 @@ ALTERNATIVES_SRC?=	# none
 
 .if !empty(ALTERNATIVES_SRC)
 
+# pkgsrc-synth hack, this needs USE_TOOLS+=pkg_alternatives:run
+DEPENDS+=	pkg_alternatives-[0-9]*:../../pkgtools/pkg_alternatives
+
 ${WRKDIR}/.altinstall: ${ALTERNATIVES_SRC}
 	@{ ${ECHO} 'if ${TEST} $${STAGE} = "POST-INSTALL"; then'; \
-	${ECHO} '${CAT} >./+ALTERNATIVES <<EOF'; \
+	${ECHO} 'if ${TEST} -x ${PKG_ALTERNATIVES}; then'; \
+	${ECHO} '${CAT} >/tmp/${PKGBASE}_ALTERNATIVES <<EOF'; \
 	${SED} ${FILES_SUBST_SED} <${ALTERNATIVES_SRC}; \
 	${ECHO} 'EOF'; \
-	${ECHO} 'if ${TEST} -x ${PKG_ALTERNATIVES}; then'; \
-	${ECHO} '${PKG_ALTERNATIVES} -gs register ./+ALTERNATIVES'; \
+	${ECHO} '${PKG_ALTERNATIVES} -gs register /tmp/${PKGBASE}_ALTERNATIVES'; \
+	${ECHO} '${RM} -f /tmp/${PKGBASE}_ALTERNATIVES'; \
 	${ECHO} 'fi'; \
 	${ECHO} 'fi'; \
 	} >${WRKDIR}/.altinstall
@@ -54,9 +58,12 @@ ${WRKDIR}/.altinstall: ${ALTERNATIVES_SR
 ${WRKDIR}/.altdeinstall: ${ALTERNATIVES_SRC}
 	@{ ${ECHO} 'if ${TEST} $${STAGE} = "DEINSTALL"; then'; \
 	${ECHO} 'if ${TEST} -x ${PKG_ALTERNATIVES}; then'; \
-	${ECHO} '${PKG_ALTERNATIVES} -gs unregister ./+ALTERNATIVES'; \
+	${ECHO} '${CAT} >/tmp/${PKGBASE}_ALTERNATIVES <<EOF'; \
+	${SED} ${FILES_SUBST_SED} <${ALTERNATIVES_SRC}; \
+	${ECHO} 'EOF'; \
+	${ECHO} '${PKG_ALTERNATIVES} -gs unregister /tmp/${PKGBASE}_ALTERNATIVES'; \
+	${ECHO} '${RM} -f /tmp/${PKGBASE}_ALTERNATIVES'; \
 	${ECHO} 'fi'; \
-	${ECHO} '${RM} -f ./+ALTERNATIVES'; \
 	${ECHO} 'fi'; \
 	} >${WRKDIR}/.altdeinstall
 
