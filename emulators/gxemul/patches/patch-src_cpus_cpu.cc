$NetBSD: patch-src_cpus_cpu.cc,v 1.1 2018/03/21 17:39:42 kamil Exp $

Fix C++11 literals.

--- src/cpus/cpu.cc.orig	2014-08-17 08:45:15.000000000 +0000
+++ src/cpus/cpu.cc
@@ -245,9 +245,9 @@ void cpu_functioncall_trace(struct cpu *
 		fatal("%s", symbol);
 	else {
 		if (cpu->is_32bit)
-			fatal("0x%"PRIx32, (uint32_t) f);
+			fatal("0x%" PRIx32, (uint32_t) f);
 		else
-			fatal("0x%"PRIx64, (uint64_t) f);
+			fatal("0x%" PRIx64, (uint64_t) f);
 	}
 	fatal("(");
 
@@ -258,7 +258,7 @@ void cpu_functioncall_trace(struct cpu *
 
 #ifdef PRINT_MEMORY_CHECKSUM
 	/*  Temporary hack for finding bugs:  */
-	fatal("call chksum=%016"PRIx64"\n", memory_checksum(cpu->mem));
+	fatal("call chksum=%016" PRIx64 "\n", memory_checksum(cpu->mem));
 #endif
 }
 
@@ -425,7 +425,7 @@ void cpu_show_cycles(struct machine *mac
 	if (!machine->show_nr_of_instructions && !forced)
 		goto do_return;
 
-	printf("[ %"PRIi64" instrs", (int64_t) cpu->ninstrs);
+	printf("[ %" PRIi64 " instrs", (int64_t) cpu->ninstrs);
 
 	/*  Instructions per second, and average so far:  */
 	is = 1000 * (ninstrs-ninstrs_last) / (mseconds-mseconds_last);
@@ -439,15 +439,15 @@ void cpu_show_cycles(struct machine *mac
 		printf("; idling");
 		cpu->has_been_idling = 0;
 	} else
-		printf("; i/s=%"PRIi64" avg=%"PRIi64, is, avg);
+		printf("; i/s=%" PRIi64 " avg=%" PRIi64, is, avg);
 
 	symbol = get_symbol_name(&machine->symbol_context, pc, &offset);
 
 	if (machine->ncpus == 1) {
 		if (cpu->is_32bit)
-			printf("; pc=0x%08"PRIx32, (uint32_t) pc);
+			printf("; pc=0x%08" PRIx32, (uint32_t) pc);
 		else
-			printf("; pc=0x%016"PRIx64, (uint64_t) pc);
+			printf("; pc=0x%016" PRIx64, (uint64_t) pc);
 	}
 
 	/*  Special hack for M88K userland:  (Don't show symbols.)  */
@@ -568,4 +568,3 @@ void cpu_init(void)
 {
 	ADD_ALL_CPU_FAMILIES;
 }
-
