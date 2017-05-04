$NetBSD: patch-libtiff_tif_read.c,v 1.1 2017/05/03 23:00:59 sevan Exp $

CVE-2017-7593
http://bugzilla.maptools.org/show_bug.cgi?id=2651
https://github.com/vadz/libtiff/commit/d60332057b95

CVE-2017-7602
https://github.com/vadz/libtiff/commit/66e7bd59520996740e4df5495a830b42fae48bc4

--- libtiff/tif_read.c.orig	2017-05-03 22:31:30.000000000 +0000
+++ libtiff/tif_read.c
@@ -420,16 +420,25 @@ TIFFReadRawStrip1(TIFF* tif, uint32 stri
 			return ((tmsize_t)(-1));
 		}
 	} else {
-		tmsize_t ma,mb;
+		tmsize_t ma;
 		tmsize_t n;
-		ma=(tmsize_t)td->td_stripoffset[strip];
-		mb=ma+size;
-		if ((td->td_stripoffset[strip] > (uint64)TIFF_TMSIZE_T_MAX)||(ma>tif->tif_size))
-			n=0;
-		else if ((mb<ma)||(mb<size)||(mb>tif->tif_size))
-			n=tif->tif_size-ma;
-		else
-			n=size;
+		if ((td->td_stripoffset[strip] > (uint64)TIFF_TMSIZE_T_MAX)||
+                    ((ma=(tmsize_t)td->td_stripoffset[strip])>tif->tif_size))
+                {
+                    n=0;
+                }
+                else if( ma > TIFF_TMSIZE_T_MAX - size )
+                {
+                    n=0;
+                }
+                else
+                {
+                    tmsize_t mb=ma+size;
+                    if (mb>tif->tif_size)
+                            n=tif->tif_size-ma;
+                    else
+                            n=size;
+                }
 		if (n!=size) {
 #if defined(__WIN32__) && (defined(_MSC_VER) || defined(__MINGW32__))
 			TIFFErrorExt(tif->tif_clientdata, module,
@@ -976,7 +985,9 @@ TIFFReadBufferSetup(TIFF* tif, void* bp,
 				 "Invalid buffer size");
 		    return (0);
 		}
-		tif->tif_rawdata = (uint8*) _TIFFmalloc(tif->tif_rawdatasize);
+		/* Initialize to zero to avoid uninitialized buffers in case of */
+                /* short reads (http://bugzilla.maptools.org/show_bug.cgi?id=2651) */
+		tif->tif_rawdata = (uint8*) _TIFFcalloc(1, tif->tif_rawdatasize);
 		tif->tif_flags |= TIFF_MYBUFFER;
 	}
 	if (tif->tif_rawdata == NULL) {
