--- mk/compiler/ccache.mk.orig	2015-03-20 17:53:14 UTC
+++ mk/compiler/ccache.mk
@@ -74,6 +74,7 @@ _USE_CCACHE=	yes
 # and thus cannot inversely depend on ccache.
 _CCACHE_CIRCULAR_DEPENDENCY_PACKAGES=	\
 	archivers/gzip			\
+	devel/bmake			\
 	devel/ccache			\
 	devel/distcc			\
 	devel/libtool-base		\
@@ -82,6 +83,7 @@ _CCACHE_CIRCULAR_DEPENDENCY_PACKAGES=	\
 	net/tnftp			\
 	pkgtools/cwrappers		\
 	pkgtools/digest			\
+	pkgtools/pkg			\
 	pkgtools/pkg_install-info	\
 	sysutils/checkperms
 
