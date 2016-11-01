# $NetBSD: hacks.mk,v 1.5 2016/10/31 13:30:07 hauke Exp $

.if !defined(XEMACS_HACKS_MK)
XEMACS_HACKS_MK=	defined

.include "../../mk/compiler.mk"

### [Fri Oct 28 10:00:00 UTC 2016 : hauke]
### gcc 5 builtins collide with src/gmalloc.c's calloc(), which
### results in 'xemacs -vanilla' busy-looping during the build.
###
.if !empty(PKGSRC_COMPILER:Mgcc) && !empty(CC_VERSION:Mgcc-5.[0-9]*)
PKG_HACKS+=		gcc5-malloc-builtin-conflict
CFLAGS+=		-fno-builtin
.endif

.endif  # XEMACS_HACKS_MK
