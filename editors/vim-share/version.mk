# $NetBSD: version.mk,v 1.118 2018/07/28 08:27:35 morr Exp $

VIM_VERSION=		8.1
VIM_PATCHLEVEL=		0216
# Changelog: see http://ftp.vim.org/pub/vim/patches/8.1/
VIM_SUBDIR=		vim81

PRINT_PLIST_AWK+=	{ gsub(/${VIM_SUBDIR}/, "$${VIM_SUBDIR}"); print; next; }
