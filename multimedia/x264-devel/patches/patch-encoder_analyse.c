$NetBSD: patch-encoder_analyse.c,v 1.1 2017/06/16 05:39:23 adam Exp $

Use logf() instead of log2f.

--- encoder/analyse.c.orig	2017-06-15 20:45:03.000000000 +0000
+++ encoder/analyse.c
@@ -306,7 +306,7 @@ int x264_analyse_init_costs( x264_t *h )
 
     logs[0] = 0.718f;
     for( int i = 1; i <= 2*4*2048; i++ )
-        logs[i] = log2f( i+1 ) * 2.0f + 1.718f;
+        logs[i] = logf(i+1)*2.88539f + 1.718f;
 
     for( int qp = X264_MIN( h->param.rc.i_qp_min, QP_MAX_SPEC ); qp <= h->param.rc.i_qp_max; qp++ )
         if( init_costs( h, logs, qp ) )
