$NetBSD: patch-settings_xfae-dialog.c,v 1.2 2018/06/01 14:15:47 youri Exp $

With xfce4-session built from git (after the gtk3
migration work), trying to add or edit an application
autostart entry results in a segmentation fault after a
"(xfce4-session-settings:9094): Gtk-CRITICAL **:
gtk_entry_get_text: assertion 'GTK_IS_ENTRY (entry)'
failed" message.

It appears that when the "notify::text" signal callbacks
for the "command_entry" and "name_entry" GtkEntry objects
are created, they are called immediately, before the second
GtkEntry object is created resulting in a failure in the
xfae_dialog_update() function to properly process the objects.
Thanks to ToZ for reporting and providing the fix.

diff --git a/settings/xfae-dialog.c b/settings/xfae-dialog.c
index af860b9..7442634 100644
--- settings/xfae-dialog.c
+++ settings/xfae-dialog.c
@@ -98,8 +98,7 @@ xfae_dialog_init (XfaeDialog *dialog)
   dialog->name_entry = g_object_new (GTK_TYPE_ENTRY,
                                      "activates-default", TRUE,
                                      NULL);
-  g_signal_connect_swapped (G_OBJECT (dialog->name_entry), "notify::text",
-                            G_CALLBACK (xfae_dialog_update), dialog);
+
   gtk_grid_attach (GTK_GRID (grid), dialog->name_entry, 1, 0, 1, 1);
   gtk_widget_show (dialog->name_entry);
 
@@ -132,11 +131,15 @@ xfae_dialog_init (XfaeDialog *dialog)
   dialog->command_entry = g_object_new (GTK_TYPE_ENTRY,
                                         "activates-default", TRUE,
                                         NULL);
-  g_signal_connect_swapped (G_OBJECT (dialog->command_entry), "notify::text",
-                            G_CALLBACK (xfae_dialog_update), dialog);
+
   gtk_box_pack_start (GTK_BOX (hbox), dialog->command_entry, TRUE, TRUE, 0);
   gtk_widget_show (dialog->command_entry);
 
+  g_signal_connect_swapped (G_OBJECT (dialog->name_entry), "notify::text",
+                            G_CALLBACK (xfae_dialog_update), dialog);
+  g_signal_connect_swapped (G_OBJECT (dialog->command_entry), "notify::text",
+                            G_CALLBACK (xfae_dialog_update), dialog);
+
   button = g_object_new (GTK_TYPE_BUTTON,
                          "can-default", FALSE,
                          NULL);
