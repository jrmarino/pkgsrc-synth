$NetBSD: patch-netwerk_srtp_src_crypto_hash_hmac.c,v 1.2 2016/10/30 01:10:10 kamil Exp $

Fix conflicting hmac symbol name with <stdlib.h> on NetBSD.

--- netwerk/srtp/src/crypto/hash/hmac.c.orig	2016-05-12 17:13:29.000000000 +0000
+++ netwerk/srtp/src/crypto/hash/hmac.c
@@ -55,7 +55,7 @@ debug_module_t mod_hmac = {
 
 err_status_t
 hmac_alloc(auth_t **a, int key_len, int out_len) {
-  extern auth_type_t hmac;
+  extern auth_type_t ffhmac;
   uint8_t *pointer;
 
   debug_print(mod_hmac, "allocating auth func with key length %d", key_len);
@@ -79,21 +79,21 @@ hmac_alloc(auth_t **a, int key_len, int 
 
   /* set pointers */
   *a = (auth_t *)pointer;
-  (*a)->type = &hmac;
+  (*a)->type = &ffhmac;
   (*a)->state = pointer + sizeof(auth_t);  
   (*a)->out_len = out_len;
   (*a)->key_len = key_len;
   (*a)->prefix_len = 0;
 
   /* increment global count of all hmac uses */
-  hmac.ref_count++;
+  ffhmac.ref_count++;
 
   return err_status_ok;
 }
 
 err_status_t
 hmac_dealloc(auth_t *a) {
-  extern auth_type_t hmac;
+  extern auth_type_t ffhmac;
   
   /* zeroize entire state*/
   octet_string_set_to_zero((uint8_t *)a, 
@@ -103,7 +103,7 @@ hmac_dealloc(auth_t *a) {
   crypto_free(a);
   
   /* decrement global count of all hmac uses */
-  hmac.ref_count--;
+  ffhmac.ref_count--;
 
   return err_status_ok;
 }
@@ -252,7 +252,7 @@ char hmac_description[] = "hmac sha-1 au
  */
 
 auth_type_t
-hmac  = {
+ffhmac  = {
   (auth_alloc_func)      hmac_alloc,
   (auth_dealloc_func)    hmac_dealloc,
   (auth_init_func)       hmac_init,
@@ -265,4 +265,3 @@ hmac  = {
   (debug_module_t *)    &mod_hmac,
   (auth_type_id_t)       HMAC_SHA1
 };
-
