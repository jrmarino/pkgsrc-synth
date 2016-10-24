# $NetBSD: options.mk,v 1.8 2016/10/04 14:50:07 kamil Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.py-anita
PKG_SUPPORTED_OPTIONS=		xen
PKG_OPTIONS_OPTIONAL_GROUPS=	qemu
PKG_OPTIONS_GROUP.qemu=		qemu
PKG_SUGGESTED_OPTIONS=

# To run (but not to build), anita needs some way to run a virtual
# machine.  The standard approach is qemu-0, because it is known to
# work.  Newer qemu is problematic.  xen also works, but is less well
# tested.  See anita(1) for details of the above.

# By default, py-anita does not depend on any of these, because a
# hypervisor one doesn't want to use is a large burden (qemu in
# particular is very large).  While these options can be enabled, they
# also serve to document ways to fulfill the hypervisor requirement.

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mqemu)
# Some versions of qemu1/2 do not work reliably, see the anita(1)
# man page.  Version 2.0.0nb4 or newer should work.
DEPENDS+=	qemu>=1.0:../../emulators/qemu
.endif

.if !empty(PKG_OPTIONS:Mxen)
# Choose 4.1 because that has been tested (with --vmm xm) and is
# arguably a reasonable version to recommend to people wanting to
# install xen to run anita.  (A good case can be made for 4.2, and
# anyone who has tested it with anita is welcome to change this to
# 4.2.)
DEPENDS+=	xenkernel41>=4.1:../../sysutils/xenkernel41
DEPENDS+=	xentools41>=4.1:../../sysutils/xentools41
.endif
