$NetBSD: patch-src_memory.c,v 1.3 2016/10/13 15:17:28 fhajny Exp $

Add a port for NetBSD using VM_UVMEXP2, and preferring
sysctl over sysctlbyname.

--- src/memory.c.orig	2016-09-11 08:10:25.267038716 +0000
+++ src/memory.c
@@ -66,6 +66,10 @@ static mach_port_t port_host;
 static vm_size_t pagesize;
 /* #endif HAVE_HOST_STATISTICS */
 
+#elif HAVE_SYSCTL
+static int pagesize;
+/* #endif HAVE_SYSCTL */
+
 #elif HAVE_SYSCTLBYNAME
 /* no global variables */
 /* #endif HAVE_SYSCTLBYNAME */
@@ -80,10 +84,6 @@ static kstat_t *ksp;
 static kstat_t *ksz;
 /* #endif HAVE_LIBKSTAT */
 
-#elif HAVE_SYSCTL
-static int pagesize;
-/* #endif HAVE_SYSCTL */
-
 #elif HAVE_LIBSTATGRAB
 /* no global variables */
 /* endif HAVE_LIBSTATGRAB */
@@ -94,6 +94,10 @@ static int pagesize;
 # error "No applicable input method."
 #endif
 
+#if KERNEL_NETBSD
+# include <uvm/uvm_extern.h>
+#endif
+
 static _Bool values_absolute = 1;
 static _Bool values_percentage = 0;
 
@@ -121,6 +125,15 @@ static int memory_init (void)
 	host_page_size (port_host, &pagesize);
 /* #endif HAVE_HOST_STATISTICS */
 
+#elif HAVE_SYSCTL
+	pagesize = getpagesize ();
+	if (pagesize <= 0)
+	{
+		ERROR ("memory plugin: Invalid pagesize: %i", pagesize);
+		return (-1);
+	}
+/* #endif HAVE_SYSCTL */
+
 #elif HAVE_SYSCTLBYNAME
 /* no init stuff */
 /* #endif HAVE_SYSCTLBYNAME */
@@ -145,15 +158,6 @@ static int memory_init (void)
 
 /* #endif HAVE_LIBKSTAT */
 
-#elif HAVE_SYSCTL
-	pagesize = getpagesize ();
-	if (pagesize <= 0)
-	{
-		ERROR ("memory plugin: Invalid pagesize: %i", pagesize);
-		return (-1);
-	}
-/* #endif HAVE_SYSCTL */
-
 #elif HAVE_LIBSTATGRAB
 /* no init stuff */
 /* #endif HAVE_LIBSTATGRAB */
@@ -227,6 +231,46 @@ static int memory_read_internal (value_l
 /* #endif HAVE_HOST_STATISTICS */
 
 #elif HAVE_SYSCTLBYNAME
+
+#if HAVE_SYSCTL && defined(KERNEL_NETBSD)
+	int mib[] = {CTL_VM, VM_UVMEXP2};
+	struct uvmexp_sysctl uvmexp;
+	gauge_t mem_active;
+	gauge_t mem_inactive;
+	gauge_t mem_free;
+	gauge_t mem_wired;
+	gauge_t mem_kernel;
+	size_t size;
+
+	memset (&uvmexp, 0, sizeof (uvmexp));
+	size = sizeof (uvmexp);
+
+	if (sysctl (mib, 2, &uvmexp, &size, NULL, 0) < 0) {
+		char errbuf[1024];
+		WARNING ("memory plugin: sysctl failed: %s",
+			sstrerror (errno, errbuf, sizeof (errbuf)));
+		return (-1);
+	}
+
+	assert (pagesize > 0);
+	mem_active   = (gauge_t) (uvmexp.active * pagesize);
+	mem_inactive = (gauge_t) (uvmexp.inactive * pagesize);
+	mem_free     = (gauge_t) (uvmexp.free * pagesize);
+	mem_wired    = (gauge_t) (uvmexp.wired * pagesize);
+	mem_kernel   = (gauge_t) ((uvmexp.npages - (
+					uvmexp.active + uvmexp.inactive +
+					uvmexp.free + uvmexp.wired
+					)) * pagesize);
+
+	MEMORY_SUBMIT ("active",   mem_active,
+	               "inactive", mem_inactive,
+	               "free",     mem_free,
+	               "wired",    mem_wired,
+	               "kernel",   mem_kernel);
+/* #endif HAVE_SYSCTL && defined(KERNEL_NETBSD) */
+
+#else /* Other HAVE_SYSCTLBYNAME providers */
+
 	/*
 	 * vm.stats.vm.v_page_size: 4096
 	 * vm.stats.vm.v_page_count: 246178
@@ -276,6 +320,8 @@ static int memory_read_internal (value_l
 	               "active",   (gauge_t) sysctl_vals[4],
 	               "inactive", (gauge_t) sysctl_vals[5],
 	               "cache",    (gauge_t) sysctl_vals[6]);
+
+#endif /* HAVE_SYSCTL && KERNEL_NETBSD */
 /* #endif HAVE_SYSCTLBYNAME */
 
 #elif KERNEL_LINUX
