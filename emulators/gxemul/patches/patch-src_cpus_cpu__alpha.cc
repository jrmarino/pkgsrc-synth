$NetBSD: patch-src_cpus_cpu__alpha.cc,v 1.1 2018/03/21 17:39:42 kamil Exp $

Fix C++11 literals.

--- src/cpus/cpu_alpha.cc.orig	2014-08-17 08:45:15.000000000 +0000
+++ src/cpus/cpu_alpha.cc
@@ -181,14 +181,14 @@ void alpha_cpu_register_dump(struct cpu 
 	if (gprs) {
 		symbol = get_symbol_name(&cpu->machine->symbol_context,
 		    cpu->pc, &offset);
-		debug("cpu%i:\t pc = 0x%016"PRIx64, x, (uint64_t) cpu->pc);
+		debug("cpu%i:\t pc = 0x%016" PRIx64, x, (uint64_t) cpu->pc);
 		debug("  <%s>\n", symbol != NULL? symbol : " no symbol ");
 		for (i=0; i<N_ALPHA_REGS; i++) {
 			int r = (i >> 1) + ((i & 1) << 4);
 			if ((i % 2) == 0)
 				debug("cpu%i:\t", x);
 			if (r != ALPHA_ZERO)
-				debug("%3s = 0x%016"PRIx64, alpha_regname[r],
+				debug("%3s = 0x%016" PRIx64, alpha_regname[r],
 				    (uint64_t) cpu->cd.alpha.r[r]);
 			if ((i % 2) == 1)
 				debug("\n");
@@ -283,7 +283,7 @@ int alpha_cpu_disassemble_instr(struct c
 	if (cpu->machine->ncpus > 1 && running)
 		debug("cpu%i:\t", cpu->cpu_id);
 
-	debug("%016"PRIx64":  ", (uint64_t) dumpaddr);
+	debug("%016" PRIx64 ":  ", (uint64_t) dumpaddr);
 
 	iw = ib[0] + (ib[1]<<8) + (ib[2]<<16) + (ib[3]<<24);
 	debug("%08x\t", (int)iw);
@@ -594,7 +594,7 @@ int alpha_cpu_disassemble_instr(struct c
 				debug("jsr");
 			debug("\t%s,", alpha_regname[ra]);
 			debug("(%s),", alpha_regname[rb]);
-			debug("0x%"PRIx64, (uint64_t) tmp);
+			debug("0x%" PRIx64, (uint64_t) tmp);
 			symbol = get_symbol_name(&cpu->machine->symbol_context,
 			    tmp, &offset);
 			if (symbol != NULL)
@@ -616,7 +616,7 @@ int alpha_cpu_disassemble_instr(struct c
 		debug("%s\t", opcode==0x30? "br" : "bsr");
 		if (ra != ALPHA_ZERO)
 			debug("%s,", alpha_regname[ra]);
-		debug("0x%"PRIx64, (uint64_t) tmp);
+		debug("0x%" PRIx64, (uint64_t) tmp);
 		symbol = get_symbol_name(&cpu->machine->symbol_context,
 		    tmp, &offset);
 		if (symbol != NULL)
@@ -656,7 +656,7 @@ int alpha_cpu_disassemble_instr(struct c
 			debug("f%i,", ra);
 		else
 			debug("%s,", alpha_regname[ra]);
-		debug("0x%"PRIx64, (uint64_t) tmp);
+		debug("0x%" PRIx64, (uint64_t) tmp);
 		symbol = get_symbol_name(&cpu->machine->symbol_context,
 		    tmp, &offset);
 		if (symbol != NULL)
@@ -680,4 +680,3 @@ int alpha_cpu_disassemble_instr(struct c
 
 
 #include "tmp_alpha_tail.cc"
-
