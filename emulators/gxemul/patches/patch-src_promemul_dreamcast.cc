$NetBSD: patch-src_promemul_dreamcast.cc,v 1.1 2018/03/21 17:39:42 kamil Exp $

Fix C++11 literals.
Change vectorAddr to long to handle longer values in switch().

--- src/promemul/dreamcast.cc.orig	2014-08-17 08:45:15.000000000 +0000
+++ src/promemul/dreamcast.cc
@@ -241,7 +241,7 @@ void dreamcast_emul(struct cpu *cpu)
 	// cpu->pc is the address where PROM emulation was triggered, but
 	// what we are after is the indirect vector that was used to fetch
 	// that address.
-	int vectorAddr = ((cpu->pc & 0x00ffffff) - 0x100 + 0xb0) | 0x8c000000;
+	long vectorAddr = ((cpu->pc & 0x00ffffff) - 0x100 + 0xb0) | 0x8c000000;
 
 	int r1 = cpu->cd.sh.r[1];
 	int r6 = cpu->cd.sh.r[6];
@@ -382,8 +382,7 @@ bad:
 	cpu_register_dump(cpu->machine, cpu, 1, 0);
 	printf("\n");
 	fatal("[ dreamcast_emul(): unimplemented dreamcast PROM call, "
-	    "pc=0x%08"PRIx32" (vectorAddr=0x%08"PRIx32") ]\n", (uint32_t)cpu->pc, vectorAddr);
+	    "pc=0x%08" PRIx32 " (vectorAddr=0x%08" PRIx32 ") ]\n", (uint32_t)cpu->pc, vectorAddr);
 	cpu->running = 0;
 	return;
 }
-
