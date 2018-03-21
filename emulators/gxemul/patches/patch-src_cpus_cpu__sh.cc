$NetBSD: patch-src_cpus_cpu__sh.cc,v 1.1 2018/03/21 17:39:42 kamil Exp $

Fix C++11 literals.

--- src/cpus/cpu_sh.cc.orig	2014-08-17 08:45:15.000000000 +0000
+++ src/cpus/cpu_sh.cc
@@ -462,10 +462,10 @@ void sh_cpu_register_dump(struct cpu *cp
 		symbol = get_symbol_name(&cpu->machine->symbol_context,
 		    cpu->pc, &offset);
 
-		debug("cpu%i: pc  = 0x%08"PRIx32, x, (uint32_t)cpu->pc);
+		debug("cpu%i: pc  = 0x%08" PRIx32, x, (uint32_t)cpu->pc);
 		debug("  <%s>\n", symbol != NULL? symbol : " no symbol ");
 
-		debug("cpu%i: sr  = 0x%08"PRIx32"  (%s, %s, %s, %s, %s, %s,"
+		debug("cpu%i: sr  = 0x%08" PRIx32 "  (%s, %s, %s, %s, %s, %s,"
 		    " imask=0x%x, %s, %s)\n", x, (int32_t)cpu->cd.sh.sr,
 		    (cpu->cd.sh.sr & SH_SR_MD)? "MD" : "!md",
 		    (cpu->cd.sh.sr & SH_SR_RB)? "RB" : "!rb",
@@ -479,11 +479,11 @@ void sh_cpu_register_dump(struct cpu *cp
 
 		symbol = get_symbol_name(&cpu->machine->symbol_context,
 		    cpu->cd.sh.pr, &offset);
-		debug("cpu%i: pr  = 0x%08"PRIx32, x, (uint32_t)cpu->cd.sh.pr);
+		debug("cpu%i: pr  = 0x%08" PRIx32, x, (uint32_t)cpu->cd.sh.pr);
 		debug("  <%s>\n", symbol != NULL? symbol : " no symbol ");
 
-		debug("cpu%i: mach = 0x%08"PRIx32"  macl = 0x%08"PRIx32
-		    "  gbr = 0x%08"PRIx32"\n", x, (uint32_t)cpu->cd.sh.mach,
+		debug("cpu%i: mach = 0x%08" PRIx32"  macl = 0x%08" PRIx32
+		    "  gbr = 0x%08" PRIx32 "\n", x, (uint32_t)cpu->cd.sh.mach,
 		    (uint32_t)cpu->cd.sh.macl, (uint32_t)cpu->cd.sh.gbr);
 
 		for (i=0; i<SH_N_GPRS; i++) {
@@ -497,8 +497,8 @@ void sh_cpu_register_dump(struct cpu *cp
 
 	if (coprocs & 1) {
 		/*  Floating point:  */
-		debug("cpu%i: fpscr = 0x%08"PRIx32" (%s,%s,%s)  fpul = 0x%08"
-		    PRIx32"\n", x, cpu->cd.sh.fpscr,
+		debug("cpu%i: fpscr = 0x%08" PRIx32 " (%s,%s,%s)  fpul = 0x%08"
+		    PRIx32 "\n", x, cpu->cd.sh.fpscr,
 		    cpu->cd.sh.fpscr & SH_FPSCR_PR? "PR" : "!pr",
 		    cpu->cd.sh.fpscr & SH_FPSCR_SZ? "SZ" : "!sz",
 		    cpu->cd.sh.fpscr & SH_FPSCR_FR? "FR" : "!fr",
@@ -523,13 +523,13 @@ void sh_cpu_register_dump(struct cpu *cp
 
 	if (coprocs & 2) {
 		/*  System registers, etc:  */
-		debug("cpu%i: vbr = 0x%08"PRIx32"  sgr = 0x%08"PRIx32
-		    "  dbr = 0x%08"PRIx32"\n", x, cpu->cd.sh.vbr, cpu->cd.sh.sgr,
+		debug("cpu%i: vbr = 0x%08" PRIx32 "  sgr = 0x%08" PRIx32
+		    "  dbr = 0x%08" PRIx32 "\n", x, cpu->cd.sh.vbr, cpu->cd.sh.sgr,
 		    cpu->cd.sh.dbr);
-		debug("cpu%i: spc = 0x%08"PRIx32"  ssr = 0x%08"PRIx32"\n",
+		debug("cpu%i: spc = 0x%08" PRIx32 "  ssr = 0x%08" PRIx32 "\n",
 		    x, cpu->cd.sh.spc, cpu->cd.sh.ssr);
-		debug("cpu%i: expevt = 0x%"PRIx32"  intevt = 0x%"PRIx32
-		    "  tra = 0x%"PRIx32"\n", x, cpu->cd.sh.expevt,
+		debug("cpu%i: expevt = 0x%" PRIx32 "  intevt = 0x%" PRIx32
+		    "  tra = 0x%" PRIx32 "\n", x, cpu->cd.sh.expevt,
 		    cpu->cd.sh.intevt, cpu->cd.sh.tra);
 
 		for (i=0; i<SH_N_GPRS_BANKED; i++) {
@@ -564,13 +564,13 @@ void sh_cpu_tlbdump(struct machine *m, i
 			continue;
 
 		for (i=0; i<SH_N_ITLB_ENTRIES; i++)
-			printf("cpu%i: itlb_hi_%-2i = 0x%08"PRIx32"  "
-			    "itlb_lo_%-2i = 0x%08"PRIx32"\n", j, i,
+			printf("cpu%i: itlb_hi_%-2i = 0x%08" PRIx32 "  "
+			    "itlb_lo_%-2i = 0x%08" PRIx32 "\n", j, i,
 			    (uint32_t) cpu->cd.sh.itlb_hi[i], i,
 			    (uint32_t) cpu->cd.sh.itlb_lo[i]);
 		for (i=0; i<SH_N_UTLB_ENTRIES; i++)
-			printf("cpu%i: utlb_hi_%-2i = 0x%08"PRIx32"  "
-			    "utlb_lo_%-2i = 0x%08"PRIx32"\n", j, i,
+			printf("cpu%i: utlb_hi_%-2i = 0x%08" PRIx32 "  "
+			    "utlb_lo_%-2i = 0x%08" PRIx32 "\n", j, i,
 			    (uint32_t) cpu->cd.sh.utlb_hi[i], i,
 			    (uint32_t) cpu->cd.sh.utlb_lo[i]);
 	}
@@ -639,9 +639,9 @@ void sh_exception(struct cpu *cpu, int e
 		else
 			debug("[ exception 0x%03x", expevt);
 
-		debug(", pc=0x%08"PRIx32" ", (uint32_t)cpu->pc);
+		debug(", pc=0x%08" PRIx32 " ", (uint32_t)cpu->pc);
 		if (intevt == 0)
-			debug("vaddr=0x%08"PRIx32" ", vaddr);
+			debug("vaddr=0x%08" PRIx32 " ", vaddr);
 
 		debug(" ]\n");
 	}
@@ -737,7 +737,7 @@ void sh_exception(struct cpu *cpu, int e
 		 *  these are not very common.
 		 */
 #if 1
-		printf("\nRESERVED SuperH instruction at spc=%08"PRIx32"\n",
+		printf("\nRESERVED SuperH instruction at spc=%08" PRIx32 "\n",
 		    cpu->cd.sh.spc);
 		exit(1);
 #else
@@ -790,7 +790,7 @@ int sh_cpu_disassemble_instr(struct cpu 
 	if (cpu->machine->ncpus > 1 && running)
 		debug("cpu%i: ", cpu->cpu_id);
 
-	debug("%08"PRIx32, (uint32_t) dumpaddr);
+	debug("%08" PRIx32, (uint32_t) dumpaddr);
 
 	if (cpu->byte_order == EMUL_BIG_ENDIAN)
 		iword = (instr[0] << 8) + instr[1];
@@ -828,7 +828,7 @@ int sh_cpu_disassemble_instr(struct cpu 
 				if (symbol != NULL)
 					debug("<%s>", symbol);
 				else
-					debug("0x%08"PRIx32, addr);
+					debug("0x%08" PRIx32, addr);
 			}
 			debug("\n");
 		} else if (lo4 == 0x7)
@@ -857,7 +857,7 @@ int sh_cpu_disassemble_instr(struct cpu 
 				if (symbol != NULL)
 					debug("<%s>", symbol);
 				else
-					debug("0x%08"PRIx32, addr);
+					debug("0x%08" PRIx32, addr);
 			}
 			debug("\n");
 		} else if (lo8 == 0x12)
@@ -927,7 +927,7 @@ int sh_cpu_disassemble_instr(struct cpu 
 			if (symbol != NULL)
 				debug("<%s>", symbol);
 			else
-				debug("0x%08"PRIx32, addr);
+				debug("0x%08" PRIx32, addr);
 		}
 		debug("\n");
 		break;
@@ -965,7 +965,7 @@ int sh_cpu_disassemble_instr(struct cpu 
 		else
 			debug("UNIMPLEMENTED hi4=0x%x, lo8=0x%02x", hi4, lo8);
 		if (running && lo4 <= 6) {
-			debug("\t; r%i = 0x%08"PRIx32, r8, cpu->cd.sh.r[r8]);
+			debug("\t; r%i = 0x%08" PRIx32, r8, cpu->cd.sh.r[r8]);
 		}
 		debug("\n");
 		break;
@@ -1133,7 +1133,7 @@ int sh_cpu_disassemble_instr(struct cpu 
 			if (symbol != NULL)
 				debug("\t; r%i+%i <%s>", r4, lo4 * 4, symbol);
 			else
-				debug("\t; r%i+%i = 0x%08"PRIx32, r4, lo4 * 4, (int)addr);
+				debug("\t; r%i+%i = 0x%08" PRIx32, r4, lo4 * 4, (int)addr);
 		}
 		debug("\n");
 		break;
@@ -1173,7 +1173,7 @@ int sh_cpu_disassemble_instr(struct cpu 
 		else
 			debug("UNIMPLEMENTED hi4=0x%x, lo8=0x%02x", hi4, lo8);
 		if (running && lo4 < 8 && (lo4 & 3) < 3) {
-			debug("\t; r%i = 0x%08"PRIx32, r4, cpu->cd.sh.r[r4]);
+			debug("\t; r%i = 0x%08" PRIx32, r4, cpu->cd.sh.r[r4]);
 		}
 		debug("\n");
 		break;
@@ -1187,7 +1187,7 @@ int sh_cpu_disassemble_instr(struct cpu 
 			else if (r8 == 0x4)
 				debug("mov.b\t@(%i,r%i),r0", lo4, r4);
 			if (running) {
-				debug("\t; r%i+%i = 0x%08"PRIx32, r4, lo4,
+				debug("\t; r%i+%i = 0x%08" PRIx32, r4, lo4,
 				    cpu->cd.sh.r[r4] + lo4);
 			}
 			debug("\n");
@@ -1197,7 +1197,7 @@ int sh_cpu_disassemble_instr(struct cpu 
 			else if (r8 == 0x5)
 				debug("mov.w\t@(%i,r%i),r0", lo4 * 2, r4);
 			if (running) {
-				debug("\t; r%i+%i = 0x%08"PRIx32, r4, lo4 * 2,
+				debug("\t; r%i+%i = 0x%08" PRIx32, r4, lo4 * 2,
 				    cpu->cd.sh.r[r4] + lo4 * 2);
 			}
 			debug("\n");
@@ -1408,4 +1408,3 @@ int sh_cpu_disassemble_instr(struct cpu 
 
 
 #include "tmp_sh_tail.cc"
-
