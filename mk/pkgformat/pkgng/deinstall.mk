# $NetBSD$

# Set the appropriate flags to pass to pkg_delete(1) based on the value
# of DEINSTALLDEPENDS (see pkgsrc/mk/install/deinstall.mk).
#
_INVOKE_AUTOREMOVE=	no

.if defined(DEINSTALLDEPENDS)
.  if empty(DEINSTALLDEPENDS:M[nN][oO])
_PKG_ARGS_DEINSTALL+=	--recursive
.    if !empty(DEINSTALLDEPENDS:M[aA][lL][lL])
_INVOKE_AUTOREMOVE=	yes
.    endif
.  endif
.endif

# _pkgformat-deinstall:
#	Removes a package from the system.
#
# See also:
#	deinstall
#
_pkgformat-deinstall: .PHONY
	${RUN}								\
	if [ x"${OLDNAME}" = x ]; then					\
		found=`${PKG_CMD} info --exists "${PKGNAME}" || ${TRUE}`;		\
	else								\
		found=${OLDNAME};					\
	fi;								\
	case "$$found" in						\
	"") found=`${_PKG_BEST_EXISTS} ${PKGWILDCARD:Q} || ${TRUE}`;;	\
	esac;								\
	if ${TEST} -n "$$found"; then					\
		${ECHO} "Running ${PKG_DELETE_CMD} ${_PKG_ARGS_DEINSTALL} $$found"; \
		${PKG_DELETE_CMD} --yes ${_PKG_ARGS_DEINSTALL} -f "$$found" || ${TRUE} ; \
	fi
.if ${_INVOKE_AUTOREMOVE:Myes}
	${PKG_CMD} autoremove --yes
.endif
