# $NetBSD: Makefile,v 1.11 2018/05/06 11:42:59 markd Exp $

DISTNAME=	hyphen-german
PKGNAME=	tex-${DISTNAME}-2018
TEXLIVE_REV=	47375

MAINTAINER=	minskim@NetBSD.org
#HOMEPAGE=	http://ctan.org/pkg/hyphen-german
COMMENT=	Hyphenation patterns for German
LICENSE=	lppl-1.3c

DEPENDS+=	tex-hyphen-base-[0-9]*:../../print/tex-hyphen-base
DEPENDS+=	tex-hyph-utf8-[0-9]*:../../print/tex-hyph-utf8

TEX_HYPHEN_DAT+=	german loadhyph-de-1901.tex
TEX_HYPHEN_DAT+=	ngerman loadhyph-de-1996.tex
TEX_HYPHEN_DAT+=	swissgerman loadhyph-de-ch-1901.tex
TEX_HYPHEN_DEF+=	\\addlanguage{german}{loadhyph-de-1901.tex}{}{2}{2}
TEX_HYPHEN_DEF+=	\\addlanguage{ngerman}{loadhyph-de-1996.tex}{}{2}{2}
TEX_HYPHEN_DEF+=	\\addlanguage{swissgerman}{loadhyph-de-ch-1901.tex}{}{2}{2}

TEX_HYPHEN_LUA+=	['german']={ \
			  loader='loadhyph-de-1901.tex', \
			  lefthyphenmin=2, \
			  righthyphenmin=2, \
			  synonyms={}, \
			  patterns='hyph-de-1901.pat.txt', \
			  hyphenation='', \
			},
TEX_HYPHEN_LUA+=	['ngerman']={ \
			  loader='loadhyph-de-1996.tex', \
			  lefthyphenmin=2, \
			  righthyphenmin=2, \
			  synonyms={}, \
			  patterns='hyph-de-1996.pat.txt', \
			  hyphenation='', \
			},
TEX_HYPHEN_LUA+=	['swissgerman']={ \
			  loader='loadhyph-de-ch-1901.tex', \
			  lefthyphenmin=2, \
			  righthyphenmin=2, \
			  synonyms={}, \
			  patterns='hyph-de-ch-1901.pat.txt', \
			  hyphenation='', \
			},

.include "../../print/texlive/package.mk"
.include "../../mk/bsd.pkg.mk"
