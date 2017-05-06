$NetBSD: patch-tools_tiffcp.c,v 1.2 2017/05/05 20:06:03 he Exp $

CVE-2017-5225
http://bugzilla.maptools.org/show_bug.cgi?id=2656
http://bugzilla.maptools.org/show_bug.cgi?id=2657
https://github.com/vadz/libtiff/commit/5c080298d59efa53264d7248bbe3a04660db6ef7

and

CVE-2016-10093
http://bugzilla.maptools.org/show_bug.cgi?id=2610
https://github.com/vadz/libtiff/commit/787c0ee906430b772f33ca50b97b8b5ca070faec

--- tools/tiffcp.c.orig	2016-10-12 01:45:17.000000000 +0000
+++ tools/tiffcp.c
@@ -592,7 +592,7 @@ static	copyFunc pickCopyFunc(TIFF*, TIFF
 static int
 tiffcp(TIFF* in, TIFF* out)
 {
-	uint16 bitspersample, samplesperpixel = 1;
+	uint16 bitspersample = 1, samplesperpixel = 1;
 	uint16 input_compression, input_photometric = PHOTOMETRIC_MINISBLACK;
 	copyFunc cf;
 	uint32 width, length;
@@ -1068,6 +1068,16 @@ DECLAREcpFunc(cpContig2SeparateByRow)
 	register uint32 n;
 	uint32 row;
 	tsample_t s;
+        uint16 bps = 0;
+
+        (void) TIFFGetField(in, TIFFTAG_BITSPERSAMPLE, &bps);
+        if( bps != 8 )
+        {
+            TIFFError(TIFFFileName(in),
+                      "Error, can only handle BitsPerSample=8 in %s",
+                      "cpContig2SeparateByRow");
+            return 0;
+        }
 
 	inbuf = _TIFFmalloc(scanlinesizein);
 	outbuf = _TIFFmalloc(scanlinesizeout);
@@ -1121,6 +1131,16 @@ DECLAREcpFunc(cpSeparate2ContigByRow)
 	register uint32 n;
 	uint32 row;
 	tsample_t s;
+        uint16 bps = 0;
+
+        (void) TIFFGetField(in, TIFFTAG_BITSPERSAMPLE, &bps);
+        if( bps != 8 )
+        {
+            TIFFError(TIFFFileName(in),
+                      "Error, can only handle BitsPerSample=8 in %s",
+                      "cpSeparate2ContigByRow");
+            return 0;
+        }
 
 	inbuf = _TIFFmalloc(scanlinesizein);
 	outbuf = _TIFFmalloc(scanlinesizeout);
@@ -1163,7 +1183,7 @@ bad:
 
 static void
 cpStripToTile(uint8* out, uint8* in,
-    uint32 rows, uint32 cols, int outskew, int inskew)
+    uint32 rows, uint32 cols, int outskew, int64 inskew)
 {
 	while (rows-- > 0) {
 		uint32 j = cols;
@@ -1320,7 +1340,7 @@ DECLAREreadFunc(readContigTilesIntoBuffe
 	tdata_t tilebuf;
 	uint32 imagew = TIFFScanlineSize(in);
 	uint32 tilew  = TIFFTileRowSize(in);
-	int iskew = imagew - tilew;
+	int64 iskew = (int64)imagew - (int64)tilew;
 	uint8* bufp = (uint8*) buf;
 	uint32 tw, tl;
 	uint32 row;
@@ -1348,7 +1368,7 @@ DECLAREreadFunc(readContigTilesIntoBuffe
 				status = 0;
 				goto done;
 			}
-			if (colb + tilew > imagew) {
+			if (colb > iskew) {
 				uint32 width = imagew - colb;
 				uint32 oskew = tilew - width;
 				cpStripToTile(bufp + colb,
@@ -1763,7 +1783,7 @@ pickCopyFunc(TIFF* in, TIFF* out, uint16
 	uint32 w, l, tw, tl;
 	int bychunk;
 
-	(void) TIFFGetField(in, TIFFTAG_PLANARCONFIG, &shortv);
+	(void) TIFFGetFieldDefaulted(in, TIFFTAG_PLANARCONFIG, &shortv);
 	if (shortv != config && bitspersample != 8 && samplesperpixel > 1) {
 		fprintf(stderr,
 		    "%s: Cannot handle different planar configuration w/ bits/sample != 8\n",
