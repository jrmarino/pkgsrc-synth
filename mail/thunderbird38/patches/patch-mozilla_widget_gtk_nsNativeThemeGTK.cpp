$NetBSD: patch-mozilla_widget_gtk_nsNativeThemeGTK.cpp,v 1.1 2016/04/17 18:22:21 ryoon Exp $

--- mozilla/widget/gtk/nsNativeThemeGTK.cpp.orig	2015-06-08 17:49:33.000000000 +0000
+++ mozilla/widget/gtk/nsNativeThemeGTK.cpp
@@ -761,6 +761,8 @@ nsNativeThemeGTK::GetExtraSizeForWidget(
         return false;
 
       gint gap_height = moz_gtk_get_tab_thickness();
+      if (!gap_height)
+        return false;
 
       int32_t extra = gap_height - GetTabMarginPixels(aFrame);
       if (extra <= 0)
@@ -1528,9 +1530,15 @@ nsNativeThemeGTK::GetWidgetTransparency(
   case NS_THEME_MENUPOPUP:
   case NS_THEME_WINDOW:
   case NS_THEME_DIALOG:
-  // Tooltips use gtk_paint_flat_box().
+    return eOpaque;
+  // Tooltips use gtk_paint_flat_box() on Gtk2
+  // but are shaped on Gtk3
   case NS_THEME_TOOLTIP:
+#if (MOZ_WIDGET_GTK == 2)
     return eOpaque;
+#else
+    return eTransparent;
+#endif
   }
 
   return eUnknownTransparency;
