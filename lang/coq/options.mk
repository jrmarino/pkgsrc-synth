# $NetBSD: options.mk,v 1.4 2018/08/02 12:57:03 jaapb Exp $

PKG_OPTIONS_VAR= PKG_OPTIONS.coq
PKG_SUPPORTED_OPTIONS= doc coqide
PKG_SUGGESTED_OPTIONS= coqide

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mdoc)
BUILD_DEPENDS+= hevea>=1.10:../../textproc/hevea
CONFIGURE_ARGS+=	-with-doc yes
PLIST.doc=		yes
#BUILD_DEPENDS+=		tex-latex-bin-[0-9]*:../../print/tex-latex-bin
#BUILD_DEPENDS+=		makeindexk-[0-9]*:../../textproc/makeindexk
#BUILD_DEPENDS+=		dvipsk-[0-9]*:../../print/dvipsk
#BUILD_DEPENDS+=		tex-babel-[0-9]*:../../print/tex-babel
#BUILD_DEPENDS+=		tex-babel-english-[0-9]*:../../print/tex-babel-english
#BUILD_DEPENDS+=		tex-bibtex-[0-9]*:../../print/tex-bibtex
#BUILD_DEPENDS+=		tex-cm-super-[0-9]*:../../fonts/tex-cm-super
#BUILD_DEPENDS+=		tex-comment-[0-9]*:../../print/tex-comment
#BUILD_DEPENDS+=		tex-ec-[0-9]*:../../fonts/tex-ec
#BUILD_DEPENDS+=		tex-eepic-[0-9]*:../../graphics/tex-eepic
#BUILD_DEPENDS+=		tex-fancyhdr-[0-9]*:../../print/tex-fancyhdr
#BUILD_DEPENDS+=		tex-float-[0-9]*:../../print/tex-float
#BUILD_DEPENDS+=		tex-index-[0-9]*:../../print/tex-index
#BUILD_DEPENDS+=		tex-listings-[0-9]*:../../print/tex-listings
BUILD_DEPENDS+=		tex-moreverb-[0-9]*:../../print/tex-moreverb
#BUILD_DEPENDS+=		tex-multirow-[0-9]*:../../print/tex-multirow
BUILD_DEPENDS+=		tex-preprint-[0-9]*:../../print/tex-preprint
#BUILD_DEPENDS+=		tex-pslatex-[0-9]*:../../print/tex-pslatex
#BUILD_DEPENDS+=		tex-psnfss-[0-9]*:../../fonts/tex-psnfss
#BUILD_DEPENDS+=		tex-stmaryrd-[0-9]*:../../fonts/tex-stmaryrd
BUILD_DEPENDS+=		tex-ucs-[0-9]*:../../print/tex-ucs
#BUILD_DEPENDS+=		tex-xcolor-[0-9]*:../../print/tex-xcolor
#BUILD_DEPENDS+=		fig2dev-[0-9]*:../../print/fig2dev
#.include "../../graphics/ImageMagick/buildlink3.mk"
BUILD_DEPENDS+=		py[0-9]*-sphinx-[0-9]*:../../textproc/py-sphinx
BUILD_DEPENDS+=		py[0-9]*-sphinx-rtd-theme-[0-9]*:../../textproc/py-sphinx-rtd-theme
BUILD_DEPENDS+=		py[0-9]*-sphinxcontrib-bibtex-[0-9]*:../../textproc/py-sphinxcontrib-bibtex
BUILD_DEPENDS+=		py[0-9]*-pybtex-[0-9]*:../../textproc/py-pybtex
BUILD_DEPENDS+=		py[0-9]*-pybtex-docutils-[0-9]*:../../textproc/py-pybtex-docutils
BUILD_DEPENDS+=		py[0-9]*-pexpect-[0-9]*:../../devel/py-pexpect
BUILD_DEPENDS+=		py[0-9]*-antlr4-[0-9]*:../../textproc/py-antlr4
BUILD_DEPENDS+=		py[0-9]*-beautifulsoup4-[0-9]*:../../www/py-beautifulsoup4
.else
CONFIGURE_ARGS+= -with-doc no
.endif

.if !empty(PKG_OPTIONS:Mcoqide)
.include "../../x11/ocaml-lablgtk/buildlink3.mk"
.include "../../x11/gtk2/buildlink3.mk"
PLIST.coqide=		yes
.else
CONFIGURE_ARGS+= -coqide no
.endif
