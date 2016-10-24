$NetBSD: patch-mozilla_gfx_skia_generate__mozbuild.py,v 1.3 2015/12/03 12:22:27 ryoon Exp $

--- mozilla/gfx/skia/generate_mozbuild.py.orig	2015-11-04 01:55:27.000000000 +0000
+++ mozilla/gfx/skia/generate_mozbuild.py
@@ -147,6 +147,12 @@ if CONFIG['GNU_CXX']:
     if CONFIG['CPU_ARCH'] == 'arm':
         SOURCES['skia/src/opts/SkBlitRow_opts_arm.cpp'].flags += ['-fomit-frame-pointer']
 
+if CONFIG['MOZ_NATIVE_HARFBUZZ']:
+    CXXFLAGS += CONFIG['MOZ_HARFBUZZ_CFLAGS']
+
+if CONFIG['MOZ_NATIVE_HARFBUZZ']:
+    CXXFLAGS += CONFIG['MOZ_HARFBUZZ_CFLAGS']
+
 if CONFIG['MOZ_WIDGET_TOOLKIT'] in ('gtk2', 'gtk3', 'android', 'gonk', 'qt'):
     CXXFLAGS += CONFIG['MOZ_CAIRO_CFLAGS']
     CXXFLAGS += CONFIG['CAIRO_FT_CFLAGS']
