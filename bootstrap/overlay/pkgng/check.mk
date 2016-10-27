# $NetBSD$
#
# _pkgformat-check-vulnerable:
#	Checks for known vulnerabilities in the package if a vulnerability
#	file exists.
#
# TODO: create service to convert pkg-vulnerabilities to VULNXML format
#       and update pkg to point there by default
#       Until then, pkg-audit is either going to malfunction or not work
#       at all since it's using FreeBSD data

.if defined(NO_PKGTOOLS_REQD_CHECK)
_pkgformat-check-vulnerable: .PHONY
	${RUN}${DO_NADA}
.else

_pkgformat-check-vulnerable: .PHONY
.  if ! defined(ALLOW_VULNERABLE_PACKAGES)
	${RUN}\
	vulnfile=${PKG_DBDIR}/vuln.xml; \
	if ${TEST} ! -f "$$vulnfile"; then \
		${PHASE_MSG} "Skipping vulnerability checks"; \
		${WARNING_MSG} "No '$$vulnfile' file found."; \
		${WARNING_MSG} "To fix, run: 'pkg audit --fetch'"; \
		exit 0; \
	fi; \
	${PHASE_MSG} "Checking for vulnerabilities in ${PKGNAME}"; \
	${PKG_AUDIT_CMD} ${_AUDIT_PACKAGES_CMD} --recursive ${PKGNAME} \
	|| ${FAIL_MSG} "Define ALLOW_VULNERABLE_PACKAGES in mk.conf if this package is absolutely essential."
.  endif
.endif
