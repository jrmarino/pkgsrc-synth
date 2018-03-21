$NetBSD: patch-src_devices_dev__pvr.cc,v 1.1 2018/03/21 17:39:42 kamil Exp $

Fix C++11 literals.

--- src/devices/dev_pvr.cc.orig	2014-08-17 08:45:12.000000000 +0000
+++ src/devices/dev_pvr.cc
@@ -1595,11 +1595,11 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_OB_ADDR:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: OB_ADDR set to 0x%08"PRIx32" ]\n",
+			debug("[ pvr: OB_ADDR set to 0x%08" PRIx32 " ]\n",
 			    (uint32_t)(idata & PVR_OB_ADDR_MASK));
 			if (idata & ~PVR_OB_ADDR_MASK) {
 				fatal("[ pvr: OB_ADDR: Fatal error: Unknown"
-				    " bits set: 0x%08"PRIx32" ]\n",
+				    " bits set: 0x%08" PRIx32 " ]\n",
 				    (uint32_t)(idata & ~PVR_OB_ADDR_MASK));
 				exit(1);
 			}
@@ -1610,11 +1610,11 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_TILEBUF_ADDR:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: TILEBUF_ADDR set to 0x%08"PRIx32" ]\n",
+			debug("[ pvr: TILEBUF_ADDR set to 0x%08" PRIx32 " ]\n",
 			    (uint32_t)(idata & PVR_TILEBUF_ADDR_MASK));
 			if (idata & ~PVR_TILEBUF_ADDR_MASK) {
 				fatal("[ pvr: TILEBUF_ADDR: Unknown"
-				    " bits set: 0x%08"PRIx32" ]\n",
+				    " bits set: 0x%08" PRIx32 " ]\n",
 				    (uint32_t)(idata & ~PVR_TILEBUF_ADDR_MASK));
 				exit(1);
 			}
@@ -1640,7 +1640,7 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_BRDCOLR:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: BRDCOLR set to 0x%06"PRIx32" ]\n",
+			debug("[ pvr: BRDCOLR set to 0x%06" PRIx32 " ]\n",
 			    (int)idata);
 			DEFAULT_WRITE;
 			d->border_updated = 1;
@@ -1701,7 +1701,7 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_FB_RENDER_ADDR1:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: FB_RENDER_ADDR1 set to 0x%08"PRIx32
+			debug("[ pvr: FB_RENDER_ADDR1 set to 0x%08" PRIx32
 			    " ]\n", (int) idata);
 			DEFAULT_WRITE;
 		}
@@ -1709,7 +1709,7 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_FB_RENDER_ADDR2:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: FB_RENDER_ADDR2 set to 0x%08"PRIx32
+			debug("[ pvr: FB_RENDER_ADDR2 set to 0x%08" PRIx32
 			    " ]\n", (int) idata);
 			DEFAULT_WRITE;
 		}
@@ -1802,10 +1802,10 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_VRAM_CFG1:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: VRAM_CFG1 set to 0x%08"PRIx32,
+			debug("[ pvr: VRAM_CFG1 set to 0x%08" PRIx32,
 			    (int) idata);
 			if (idata != VRAM_CFG1_GOOD_REFRESH_VALUE)
-				fatal("{ VRAM_CFG1 = 0x%08"PRIx32" is not "
+				fatal("{ VRAM_CFG1 = 0x%08" PRIx32 " is not "
 				    "yet implemented! }", (int) idata);
 			debug(" ]\n");
 			DEFAULT_WRITE;
@@ -1814,10 +1814,10 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_VRAM_CFG2:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: VRAM_CFG2 set to 0x%08"PRIx32,
+			debug("[ pvr: VRAM_CFG2 set to 0x%08" PRIx32,
 			    (int) idata);
 			if (idata != VRAM_CFG2_UNKNOWN_MAGIC)
-				fatal("{ VRAM_CFG2 = 0x%08"PRIx32" is not "
+				fatal("{ VRAM_CFG2 = 0x%08" PRIx32 " is not "
 				    "yet implemented! }", (int) idata);
 			debug(" ]\n");
 			DEFAULT_WRITE;
@@ -1826,10 +1826,10 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_VRAM_CFG3:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: VRAM_CFG3 set to 0x%08"PRIx32,
+			debug("[ pvr: VRAM_CFG3 set to 0x%08" PRIx32,
 			    (int) idata);
 			if (idata != VRAM_CFG3_UNKNOWN_MAGIC)
-				fatal("{ VRAM_CFG3 = 0x%08"PRIx32" is not "
+				fatal("{ VRAM_CFG3 = 0x%08" PRIx32 " is not "
 				    "yet implemented! }", (int) idata);
 			debug(" ]\n");
 			DEFAULT_WRITE;
@@ -1838,7 +1838,7 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_FOG_TABLE_COL:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: FOG_TABLE_COL set to 0x%06"PRIx32" ]\n",
+			debug("[ pvr: FOG_TABLE_COL set to 0x%06" PRIx32 " ]\n",
 			    (int) idata);
 			DEFAULT_WRITE;
 		}
@@ -1846,7 +1846,7 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_FOG_VERTEX_COL:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: FOG_VERTEX_COL set to 0x%06"PRIx32" ]\n",
+			debug("[ pvr: FOG_VERTEX_COL set to 0x%06" PRIx32 " ]\n",
 			    (int) idata);
 			DEFAULT_WRITE;
 		}
@@ -1854,7 +1854,7 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_FOG_DENSITY:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: FOG_DENSITY set to 0x%08"PRIx32" ]\n",
+			debug("[ pvr: FOG_DENSITY set to 0x%08" PRIx32 " ]\n",
 			    (int) idata);
 			DEFAULT_WRITE;
 		}
@@ -1862,7 +1862,7 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_CLAMP_MAX:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: CLAMP_MAX set to 0x%06"PRIx32" ]\n",
+			debug("[ pvr: CLAMP_MAX set to 0x%06" PRIx32 " ]\n",
 			    (int) idata);
 			DEFAULT_WRITE;
 		}
@@ -1870,7 +1870,7 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_CLAMP_MIN:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: CLAMP_MIN set to 0x%06"PRIx32" ]\n",
+			debug("[ pvr: CLAMP_MIN set to 0x%06" PRIx32 " ]\n",
 			    (int) idata);
 			DEFAULT_WRITE;
 		}
@@ -1896,7 +1896,7 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_DIWADDRL:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: DIWADDRL set to 0x%08"PRIx32" ]\n",
+			debug("[ pvr: DIWADDRL set to 0x%08" PRIx32 " ]\n",
 			    (int) idata);
 			pvr_fb_invalidate(d, -1, -1);
 			DEFAULT_WRITE;
@@ -1905,7 +1905,7 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_DIWADDRS:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: DIWADDRS set to 0x%08"PRIx32" ]\n",
+			debug("[ pvr: DIWADDRS set to 0x%08" PRIx32 " ]\n",
 			    (int) idata);
 			pvr_fb_invalidate(d, -1, -1);
 			DEFAULT_WRITE;
@@ -2056,10 +2056,10 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_MAGIC_110:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: MAGIC_110 set to 0x%08"PRIx32,
+			debug("[ pvr: MAGIC_110 set to 0x%08" PRIx32,
 			    (int) idata);
 			if (idata != MAGIC_110_VALUE)
-				fatal("{ MAGIC_110 = 0x%08"PRIx32" is not "
+				fatal("{ MAGIC_110 = 0x%08" PRIx32 " is not "
 				    "yet implemented! }", (int) idata);
 			debug(" ]\n");
 			DEFAULT_WRITE;
@@ -2068,7 +2068,7 @@ DEVICE_ACCESS(pvr)
 
 	case PVRREG_TA_LUMINANCE:
 		if (writeflag == MEM_WRITE) {
-			debug("[ pvr: TA_LUMINANCE set to 0x%08"PRIx32" ]\n",
+			debug("[ pvr: TA_LUMINANCE set to 0x%08" PRIx32 " ]\n",
 			    (int) idata);
 			DEFAULT_WRITE;
 		}
@@ -2175,7 +2175,7 @@ DEVICE_ACCESS(pvr)
 				pvr_ta_init(cpu, d);
 
 			if (idata != PVR_TA_INIT && idata != 0)
-				fatal("{ TA_INIT = 0x%08"PRIx32" is not "
+				fatal("{ TA_INIT = 0x%08" PRIx32 " is not "
 				    "yet implemented! }", (int) idata);
 
 			/*  Always reset to 0.  */
@@ -2558,4 +2558,3 @@ DEVINIT(pvr)
 
 	return 1;
 }
-
