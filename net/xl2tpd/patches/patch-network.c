$NetBSD: patch-network.c,v 1.4 2015/02/19 22:27:59 joerg Exp $

Handle not having IP_PKTINFO
Handle not having SO_NO_CHECK
Don't set control buf if controllen == 0
Avoid pointer aliasing issue and fix test that was done in the wrong
byte order

--- network.c.orig	2014-01-16 22:02:04.000000000 +0000
+++ network.c
@@ -85,24 +85,26 @@ int init_network (void)
 
 	    gconfig.ipsecsaref=0;
     }
-    
-    arg=1;
-    if(setsockopt(server_socket, IPPROTO_IP, IP_PKTINFO, (char*)&arg, sizeof(arg)) != 0) {
-	    l2tp_log(LOG_CRIT, "setsockopt IP_PKTINFO: %s\n", strerror(errno));
-    }
 #else
     {
 	l2tp_log(LOG_INFO, "No attempt being made to use IPsec SAref's since we're not on a Linux machine.\n");
     }
-
+#endif
+#ifdef IP_PKTINFO    
+    arg=1;
+    if(setsockopt(server_socket, IPPROTO_IP, IP_PKTINFO, (char*)&arg, sizeof(arg)) != 0) {
+	    l2tp_log(LOG_CRIT, "setsockopt IP_PKTINFO: %s\n", strerror(errno));
+    }
 #endif
 
     /* turn off UDP checksums */
+#ifdef SO_NO_CHECK
     arg=1;
     if (setsockopt(server_socket, SOL_SOCKET, SO_NO_CHECK , (void*)&arg,
                    sizeof(arg)) ==-1) {
       l2tp_log(LOG_INFO, "unable to turn off UDP checksums");
     }
+#endif
 
 #ifdef USE_KERNEL
     if (gconfig.forceuserspace)
@@ -135,7 +137,7 @@ int init_network (void)
     return 0;
 }
 
-inline void extract (void *buf, int *tunnel, int *call)
+static inline void extract (void *buf, int *tunnel, int *call)
 {
     /*
      * Extract the tunnel and call #'s, and fix the order of the 
@@ -155,15 +157,13 @@ inline void extract (void *buf, int *tun
     }
 }
 
-inline void fix_hdr (void *buf)
+static inline void fix_hdr (void *buf)
 {
     /*
      * Fix the byte order of the header
      */
-
-    struct payload_hdr *p = (struct payload_hdr *) buf;
-    _u16 ver = ntohs (p->ver);
-    if (CTBIT (p->ver))
+    _u16 ver = ntohs (*(_u16 *)buf);
+    if (CTBIT (ver))
     {
         /*
          * Control headers are always
@@ -280,12 +280,18 @@ void control_xmit (void *b)
 void udp_xmit (struct buffer *buf, struct tunnel *t)
 {
     struct cmsghdr *cmsg;
-    char cbuf[CMSG_SPACE(sizeof (unsigned int) + sizeof (struct in_pktinfo))];
+    char cbuf[CMSG_SPACE(sizeof (unsigned int)
+#ifdef IP_PKTINFO
+    + sizeof (struct in_pktinfo)
+#endif
+    )];
     unsigned int *refp;
     struct msghdr msgh;
     int err;
     struct iovec iov;
+#ifdef IP_PKTINFO
     struct in_pktinfo *pktinfo;
+#endif
     int finallen;
     
     /*
@@ -312,7 +318,7 @@ void udp_xmit (struct buffer *buf, struc
 	
 	finallen = cmsg->cmsg_len;
     }
-    
+#ifdef IP_PKTINFO    
     if (t->my_addr.ipi_addr.s_addr){
 
 	if ( ! cmsg) {
@@ -331,7 +337,9 @@ void udp_xmit (struct buffer *buf, struc
 	
 	finallen += cmsg->cmsg_len;
     }
-    
+#endif
+    if (finallen == 0)
+	msgh.msg_control = NULL;
     msgh.msg_controllen = finallen;
     
     iov.iov_base = buf->start;
@@ -426,7 +434,9 @@ void network_thread ()
      * our network socket.  Control handling is no longer done here.
      */
     struct sockaddr_in from;
+#ifdef IP_PKTINFO
     struct in_pktinfo to;
+#endif
     unsigned int fromlen;
     int tunnel, call;           /* Tunnel and call */
     int recvsize;               /* Length of data received */
@@ -506,7 +516,9 @@ void network_thread ()
             buf->len -= PAYLOAD_BUF;
 
 	    memset(&from, 0, sizeof(from));
+#ifdef IP_PKTINFO
 	    memset(&to,   0, sizeof(to));
+#endif
 	    
 	    fromlen = sizeof(from);
 	    
@@ -557,13 +569,16 @@ void network_thread ()
 		for (cmsg = CMSG_FIRSTHDR(&msgh);
 			cmsg != NULL;
 			cmsg = CMSG_NXTHDR(&msgh,cmsg)) {
+#ifdef IP_PKTINFO
 			/* extract destination(our) addr */
 			if (cmsg->cmsg_level == IPPROTO_IP && cmsg->cmsg_type == IP_PKTINFO) {
 				struct in_pktinfo* pktInfo = ((struct in_pktinfo*)CMSG_DATA(cmsg));
 				to = *pktInfo;
+				continue;
 			}
+#endif
 			/* extract IPsec info out */
-			else if (gconfig.ipsecsaref && cmsg->cmsg_level == IPPROTO_IP
+			if (gconfig.ipsecsaref && cmsg->cmsg_level == IPPROTO_IP
 			&& cmsg->cmsg_type == gconfig.sarefnum) {
 				unsigned int *refp;
 				
@@ -592,6 +607,8 @@ void network_thread ()
 
 	    if (gconfig.packet_dump)
 	    {
+    struct payload_hdr *p = (struct payload_hdr *) buf->start;
+		l2tp_log(LOG_DEBUG, "ver = 0x%x\n", p->ver);
 		do_packet_dump (buf);
 	    }
 	    if (!
@@ -627,9 +644,11 @@ void network_thread ()
 	    }
 	    else
 	    {
+#ifdef IP_PKTINFO
 		if (c->container) {
 			c->container->my_addr = to;
 		}
+#endif
 
 		buf->peer = from;
 		/* Handle the packet */
