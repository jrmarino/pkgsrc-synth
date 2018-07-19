$NetBSD: patch-libupower-glib_up-client.c,v 1.1 2018/07/18 19:18:07 bsiegert Exp $

From 932a6a39e35754be571e1274aec4730fd42dba13 Mon Sep 17 00:00:00 2001
From: Martin Pitt <martin.pitt@ubuntu.com>
Date: Wed, 18 May 2016 09:22:43 +0200
Subject: [PATCH 1/9] lib: Add proper error and cancellable handling to
 UpClient constructor

A GObject's _init() should never fail or block, but this is currently the case
as up_client_init() connects to upowerd on D-Bus. Convert this to the GInitable
interface and provide a new constructor up_client_new_full() which accepts a
GCancellable and GError, so that clients can do proper error handling
and reporting.

This changes up_client_new() to return NULL when connecting to upowerd fails.
This provides a more well-defined behaviour in this case as clients can check
for this and our methods stop segfaulting as they have checks like

   g_return_val_if_fail (UP_IS_CLIENT (client), ...)

Previously we returned a valid object, but trying to call any method on it
segfaulted due to the NULL D-Bus proxy, so client code had no chance to check
whether the UpClient object was really valid.

https://bugs.freedesktop.org/show_bug.cgi?id=95350

--- libupower-glib/up-client.c
+++ libupower-glib/up-client.c
@@ -39,9 +39,10 @@
 #include "up-daemon-generated.h"
 #include "up-device.h"
 
-static void	up_client_class_init	(UpClientClass	*klass);
-static void	up_client_init		(UpClient	*client);
-static void	up_client_finalize	(GObject	*object);
+static void	up_client_class_init		(UpClientClass	*klass);
+static void	up_client_initable_iface_init	(GInitableIface *iface);
+static void	up_client_init			(UpClient	*client);
+static void	up_client_finalize		(GObject	*object);
 
 #define UP_CLIENT_GET_PRIVATE(o) (G_TYPE_INSTANCE_GET_PRIVATE ((o), UP_TYPE_CLIENT, UpClientPrivate))
 
@@ -73,7 +74,8 @@ enum {
 static guint signals [UP_CLIENT_LAST_SIGNAL] = { 0 };
 static gpointer up_client_object = NULL;
 
-G_DEFINE_TYPE (UpClient, up_client, G_TYPE_OBJECT)
+G_DEFINE_TYPE_WITH_CODE (UpClient, up_client, G_TYPE_OBJECT,
+                         G_IMPLEMENT_INTERFACE(G_TYPE_INITABLE, up_client_initable_iface_init))
 
 /**
  * up_client_get_devices:
@@ -434,11 +436,10 @@ up_client_class_init (UpClientClass *klass)
  * up_client_init:
  * @client: This class instance
  */
-static void
-up_client_init (UpClient *client)
+static gboolean
+up_client_initable_init (GInitable *initable, GCancellable *cancellable, GError **error)
 {
-	GError *error = NULL;
-
+	UpClient *client = UP_CLIENT (initable);
 	client->priv = UP_CLIENT_GET_PRIVATE (client);
 
 	/* connect to main interface */
@@ -446,13 +447,10 @@ up_client_init (UpClient *client)
 									 G_DBUS_PROXY_FLAGS_NONE,
 									 "org.freedesktop.UPower",
 									 "/org/freedesktop/UPower",
-									 NULL,
-									 &error);
-	if (client->priv->proxy == NULL) {
-		g_warning ("Couldn't connect to proxy: %s", error->message);
-		g_error_free (error);
-		return;
-	}
+									 cancellable,
+									 error);
+	if (client->priv->proxy == NULL)
+		return FALSE;
 
 	/* all callbacks */
 	g_signal_connect (client->priv->proxy, "device-added",
@@ -461,6 +459,23 @@ up_client_init (UpClient *client)
 			  G_CALLBACK (up_device_removed_cb), client);
 	g_signal_connect (client->priv->proxy, "notify",
 			  G_CALLBACK (up_client_notify_cb), client);
+
+	return TRUE;
+}
+
+static void
+up_client_initable_iface_init (GInitableIface *iface)
+{
+	iface->init = up_client_initable_init;
+}
+
+/*
+ * up_client_init:
+ * @client: This class instance
+ */
+static void
+up_client_init (UpClient *client)
+{
 }
 
 /*
@@ -482,23 +497,52 @@ up_client_finalize (GObject *object)
 }
 
 /**
- * up_client_new:
+ * up_client_new_full:
+ * @cancellable: (allow-none): A #GCancellable or %NULL.
+ * @error: Return location for error or %NULL.
  *
- * Creates a new #UpClient object.
+ * Creates a new #UpClient object. If connecting to upowerd on D-Bus fails,
+ % this returns %NULL and sets @error.
  *
- * Return value: a new UpClient object.
+ * Return value: a new UpClient object, or %NULL on failure.
  *
- * Since: 0.9.0
+ * Since: 0.99.5
  **/
 UpClient *
-up_client_new (void)
+up_client_new_full (GCancellable *cancellable, GError **error)
 {
 	if (up_client_object != NULL) {
 		g_object_ref (up_client_object);
 	} else {
-		up_client_object = g_object_new (UP_TYPE_CLIENT, NULL);
-		g_object_add_weak_pointer (up_client_object, &up_client_object);
+		up_client_object = g_initable_new (UP_TYPE_CLIENT, cancellable, error, NULL);
+		if (up_client_object)
+			g_object_add_weak_pointer (up_client_object, &up_client_object);
 	}
 	return UP_CLIENT (up_client_object);
 }
 
+/**
+ * up_client_new:
+ *
+ * Creates a new #UpClient object. If connecting to upowerd on D-Bus fails,
+ * this returns %NULL and prints out a warning with the error message.
+ * Consider using up_client_new_full() instead which allows you to handle errors
+ * and cancelling long operations yourself.
+ *
+ * Return value: a new UpClient object, or %NULL on failure.
+ *
+ * Since: 0.9.0
+ **/
+UpClient *
+up_client_new (void)
+{
+	GError *error = NULL;
+	UpClient *client;
+	client = up_client_new_full (NULL, &error);
+	if (client == NULL) {
+		g_warning ("Couldn't connect to proxy: %s", error->message);
+		g_error_free (error);
+	}
+	return client;
+}
+
