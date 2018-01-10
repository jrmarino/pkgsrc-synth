$NetBSD: patch-src_netzip_netgzip.ml,v 1.3 2018/01/10 16:37:41 jaapb Exp $

Compile with ocaml 4.06 (patch from upstream reported issue)
--- src/netzip/netgzip.ml.orig	2017-12-06 20:20:53.000000000 +0000
+++ src/netzip/netgzip.ml
@@ -6,8 +6,7 @@ class input_gzip_rec gzip_ch : Netchanne
 object(self)
   val mutable closed = false
 
-  method input s p l = 
-    let s = Bytes.unsafe_to_string s in
+  method input s p l =
     let n = Gzip.input gzip_ch s p l in
     if n = 0 then raise End_of_file;
     n
@@ -27,7 +26,6 @@ class input_gzip gzip_ch =
 class output_gzip_rec gzip_ch : Netchannels.rec_out_channel =
 object(self)
   method output s p l =
-    let s = Bytes.unsafe_to_string s in
     Gzip.output gzip_ch s p l;
     l
   method close_out() =
@@ -156,24 +154,20 @@ let inflating_conv st incoming at_eof ou
 		          (fun out_buf out_pos out_len ->
 		             let (finished, used_in, used_out) =
 			       try
-                                 let in_buf = Bytes.unsafe_to_string in_buf in
-                                 let out_buf = Bytes.unsafe_to_string out_buf in
-			         Zlib.inflate 
-			           stream 
-                                   in_buf in_pos in_len out_buf out_pos out_len 
+			         Zlib.inflate
+			           stream
+                                   in_buf in_pos in_len out_buf out_pos out_len
 		                   Zlib.Z_SYNC_FLUSH
 			       with Zlib.Error(_, _) ->
-                                 dispose_in_ignore st; 
+                                 dispose_in_ignore st;
                                  gzip_error "error during decompression" in
-                             
-		       
+
+
                              st.in_size <-
 			       Int32.add st.in_size (Int32.of_int used_out);
 		             st.in_crc <-
-                               ( let out_buf = Bytes.unsafe_to_string out_buf in
-			         Zlib.update_crc st.in_crc out_buf out_pos used_out
-                               );
-		       
+			       Zlib.update_crc st.in_crc out_buf out_pos used_out;
+
 		             k := !k + used_in;
 
                              if finished then (
@@ -292,31 +286,27 @@ let deflating_conv st incoming at_eof ou
 		  (fun out_buf out_pos out_len ->
 		     let (finished, used_in, used_out) =
 		       try
-                         let in_buf = Bytes.unsafe_to_string in_buf in
-                         let out_buf = Bytes.unsafe_to_string out_buf in
-			 Zlib.deflate 
-			   stream in_buf 0 in_len out_buf out_pos out_len 
+			 Zlib.deflate
+			   stream in_buf 0 in_len out_buf out_pos out_len
 			   (if at_eof then Zlib.Z_FINISH else Zlib.Z_NO_FLUSH)
-		       with 
+		       with
 			 | Zlib.Error(_, "buffer error") ->
 			     (false, 0, 0)
 			 |Zlib.Error(_, msg) ->
 			    raise (Gzip.Error("error during compression")) in
-		     
+
 		     st.out_size <- Int32.add st.out_size (Int32.of_int used_in);
-		     st.out_crc <- (
-                       let in_buf = Bytes.unsafe_to_string in_buf in
-                       Zlib.update_crc st.out_crc in_buf 0 used_in
-                     );
-		     
+		     st.out_crc <-
+                       Zlib.update_crc st.out_crc in_buf 0 used_in;
+
 		     Netbuffer.delete incoming 0 used_in;
-		     
+
 		     if at_eof && finished then loop := false;
 		     used_out
 		  ) in
 	      if not at_eof then loop := false
 	    done;
-	    
+
 	    if at_eof then (
 	      write_int32 outgoing st.out_crc;
 	      write_int32 outgoing st.out_size;
