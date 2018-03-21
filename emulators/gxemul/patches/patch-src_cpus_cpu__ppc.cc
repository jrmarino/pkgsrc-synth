$NetBSD: patch-src_cpus_cpu__ppc.cc,v 1.1 2018/03/21 17:39:42 kamil Exp $

Fix C++11 literals.

--- src/cpus/cpu_ppc.cc.orig	2014-08-17 08:45:15.000000000 +0000
+++ src/cpus/cpu_ppc.cc
@@ -361,7 +361,7 @@ void ppc_exception(struct cpu *cpu, int 
 		cpu->cd.ppc.spr[SPR_SRR1] = (cpu->cd.ppc.msr & 0x87c0ffff);
 
 	if (!quiet_mode)
-		fatal("[ PPC Exception 0x%x; pc=0x%"PRIx64" ]\n",
+		fatal("[ PPC Exception 0x%x; pc=0x%" PRIx64 " ]\n",
 		    exception_nr, cpu->pc);
 
 	/*  Disable External Interrupts, Recoverable Interrupt Mode,
@@ -401,17 +401,17 @@ void ppc_cpu_register_dump(struct cpu *c
 
 		debug("cpu%i: pc  = 0x", x);
 		if (bits32)
-			debug("%08"PRIx32, (uint32_t)cpu->pc);
+			debug("%08" PRIx32, (uint32_t)cpu->pc);
 		else
-			debug("%016"PRIx64, (uint64_t)cpu->pc);
+			debug("%016" PRIx64, (uint64_t)cpu->pc);
 		debug("  <%s>\n", symbol != NULL? symbol : " no symbol ");
 
 		debug("cpu%i: lr  = 0x", x);
 		if (bits32)
-			debug("%08"PRIx32, (uint32_t)cpu->cd.ppc.spr[SPR_LR]);
+			debug("%08" PRIx32, (uint32_t)cpu->cd.ppc.spr[SPR_LR]);
 		else
-			debug("%016"PRIx64, (uint64_t)cpu->cd.ppc.spr[SPR_LR]);
-		debug("  cr  = 0x%08"PRIx32, (uint32_t)cpu->cd.ppc.cr);
+			debug("%016" PRIx64, (uint64_t)cpu->cd.ppc.spr[SPR_LR]);
+		debug("  cr  = 0x%08" PRIx32, (uint32_t)cpu->cd.ppc.cr);
 
 		if (bits32)
 			debug("  ");
@@ -419,15 +419,15 @@ void ppc_cpu_register_dump(struct cpu *c
 			debug("\ncpu%i: ", x);
 		debug("ctr = 0x", x);
 		if (bits32)
-			debug("%08"PRIx32, (uint32_t)cpu->cd.ppc.spr[SPR_CTR]);
+			debug("%08" PRIx32, (uint32_t)cpu->cd.ppc.spr[SPR_CTR]);
 		else
-			debug("%016"PRIx64, (uint64_t)cpu->cd.ppc.spr[SPR_CTR]);
+			debug("%016" PRIx64, (uint64_t)cpu->cd.ppc.spr[SPR_CTR]);
 
 		debug("  xer = 0x", x);
 		if (bits32)
-			debug("%08"PRIx32, (uint32_t)cpu->cd.ppc.spr[SPR_XER]);
+			debug("%08" PRIx32, (uint32_t)cpu->cd.ppc.spr[SPR_XER]);
 		else
-			debug("%016"PRIx64, (uint64_t)cpu->cd.ppc.spr[SPR_XER]);
+			debug("%016" PRIx64, (uint64_t)cpu->cd.ppc.spr[SPR_XER]);
 
 		debug("\n");
 
@@ -436,7 +436,7 @@ void ppc_cpu_register_dump(struct cpu *c
 			for (i=0; i<PPC_NGPRS; i++) {
 				if ((i % 4) == 0)
 					debug("cpu%i:", x);
-				debug(" r%02i = 0x%08"PRIx32" ", i,
+				debug(" r%02i = 0x%08" PRIx32 " ", i,
 				    (uint32_t) cpu->cd.ppc.gpr[i]);
 				if ((i % 4) == 3)
 					debug("\n");
@@ -447,7 +447,7 @@ void ppc_cpu_register_dump(struct cpu *c
 				int r = (i >> 1) + ((i & 1) << 4);
 				if ((i % 2) == 0)
 					debug("cpu%i:", x);
-				debug(" r%02i = 0x%016"PRIx64" ", r,
+				debug(" r%02i = 0x%016" PRIx64 " ", r,
 				    (uint64_t) cpu->cd.ppc.gpr[r]);
 				if ((i % 2) == 1)
 					debug("\n");
@@ -456,13 +456,13 @@ void ppc_cpu_register_dump(struct cpu *c
 
 		/*  Other special registers:  */
 		if (bits32) {
-			debug("cpu%i: srr0 = 0x%08"PRIx32
-			    " srr1 = 0x%08"PRIx32"\n", x,
+			debug("cpu%i: srr0 = 0x%08" PRIx32
+			    " srr1 = 0x%08" PRIx32 "\n", x,
 			    (uint32_t) cpu->cd.ppc.spr[SPR_SRR0],
 			    (uint32_t) cpu->cd.ppc.spr[SPR_SRR1]);
 		} else {
-			debug("cpu%i: srr0 = 0x%016"PRIx64
-			    "  srr1 = 0x%016"PRIx64"\n", x,
+			debug("cpu%i: srr0 = 0x%016" PRIx64
+			    "  srr1 = 0x%016" PRIx64 "\n", x,
 			    (uint64_t) cpu->cd.ppc.spr[SPR_SRR0],
 			    (uint64_t) cpu->cd.ppc.spr[SPR_SRR1]);
 		}
@@ -470,25 +470,25 @@ void ppc_cpu_register_dump(struct cpu *c
 		debug("cpu%i: msr = ", x);
 		reg_access_msr(cpu, &tmp, 0, 0);
 		if (bits32)
-			debug("0x%08"PRIx32, (uint32_t) tmp);
+			debug("0x%08" PRIx32, (uint32_t) tmp);
 		else
-			debug("0x%016"PRIx64, (uint64_t) tmp);
+			debug("0x%016" PRIx64, (uint64_t) tmp);
 
-		debug("  tb  = 0x%08"PRIx32"%08"PRIx32"\n",
+		debug("  tb  = 0x%08" PRIx32 "%08" PRIx32 "\n",
 		    (uint32_t) cpu->cd.ppc.spr[SPR_TBU],
 		    (uint32_t) cpu->cd.ppc.spr[SPR_TBL]);
 
-		debug("cpu%i: dec = 0x%08"PRIx32,
+		debug("cpu%i: dec = 0x%08" PRIx32,
 		    x, (uint32_t) cpu->cd.ppc.spr[SPR_DEC]);
 		if (!bits32)
-			debug("  hdec = 0x%08"PRIx32"\n",
+			debug("  hdec = 0x%08" PRIx32 "\n",
 			    (uint32_t) cpu->cd.ppc.spr[SPR_HDEC]);
 
 		debug("\n");
 	}
 
 	if (coprocs & 1) {
-		debug("cpu%i: fpscr = 0x%08"PRIx32"\n",
+		debug("cpu%i: fpscr = 0x%08" PRIx32 "\n",
 		    x, (uint32_t) cpu->cd.ppc.fpscr);
 
 		/*  TODO: show floating-point values :-)  */
@@ -498,7 +498,7 @@ void ppc_cpu_register_dump(struct cpu *c
 		for (i=0; i<PPC_NFPRS; i++) {
 			if ((i % 2) == 0)
 				debug("cpu%i:", x);
-			debug(" f%02i = 0x%016"PRIx64" ", i,
+			debug(" f%02i = 0x%016" PRIx64 " ", i,
 			    (uint64_t) cpu->cd.ppc.fpr[i]);
 			if ((i % 2) == 1)
 				debug("\n");
@@ -506,7 +506,7 @@ void ppc_cpu_register_dump(struct cpu *c
 	}
 
 	if (coprocs & 2) {
-		debug("cpu%i:  sdr1 = 0x%"PRIx64"\n", x,
+		debug("cpu%i:  sdr1 = 0x%" PRIx64 "\n", x,
 		    (uint64_t) cpu->cd.ppc.spr[SPR_SDR1]);
 		if (cpu->cd.ppc.cpu_type.flags & PPC_601)
 			debug("cpu%i:  PPC601-style, TODO!\n");
@@ -517,8 +517,8 @@ void ppc_cpu_register_dump(struct cpu *c
 				uint32_t lower = cpu->cd.ppc.spr[spr+1];
 				uint32_t len = (((upper & BAT_BL) << 15)
 				    | 0x1ffff) + 1;
-				debug("cpu%i:  %sbat%i: u=0x%08"PRIx32
-				    " l=0x%08"PRIx32" ",
+				debug("cpu%i:  %sbat%i: u=0x%08" PRIx32
+				    " l=0x%08" PRIx32 " ",
 				    x, i<4? "i" : "d", i&3, upper, lower);
 				if (!(upper & BAT_V)) {
 					debug(" (not valid)\n");
@@ -555,7 +555,7 @@ void ppc_cpu_register_dump(struct cpu *c
 			uint32_t s = cpu->cd.ppc.sr[i];
 
 			debug("cpu%i:", x);
-			debug("  sr%-2i = 0x%08"PRIx32, i, s);
+			debug("  sr%-2i = 0x%08" PRIx32, i, s);
 
 			s &= (SR_TYPE | SR_SUKEY | SR_PRKEY | SR_NOEXEC);
 			if (s != 0) {
@@ -653,15 +653,15 @@ int ppc_cpu_disassemble_instr(struct cpu
 		debug("cpu%i: ", cpu->cpu_id);
 
 	if (cpu->cd.ppc.bits == 32)
-		debug("%08"PRIx32, (uint32_t) dumpaddr);
+		debug("%08" PRIx32, (uint32_t) dumpaddr);
 	else
-		debug("%016"PRIx64, (uint64_t) dumpaddr);
+		debug("%016" PRIx64, (uint64_t) dumpaddr);
 
 	/*  NOTE: Fixed to big-endian.  */
 	iword = (instr[0] << 24) + (instr[1] << 16) + (instr[2] << 8)
 	    + instr[3];
 
-	debug(": %08"PRIx32"\t", iword);
+	debug(": %08" PRIx32 "\t", iword);
 
 	/*
 	 *  Decode the instruction:
@@ -762,9 +762,9 @@ int ppc_cpu_disassemble_instr(struct cpu
 		if (cpu->cd.ppc.bits == 32)
 			addr &= 0xffffffff;
 		if (cpu->cd.ppc.bits == 32)
-			debug("0x%"PRIx32, (uint32_t) addr);
+			debug("0x%" PRIx32, (uint32_t) addr);
 		else
-			debug("0x%"PRIx64, (uint64_t) addr);
+			debug("0x%" PRIx64, (uint64_t) addr);
 		symbol = get_symbol_name(&cpu->machine->symbol_context,
 		    addr, &offset);
 		if (symbol != NULL)
@@ -795,9 +795,9 @@ int ppc_cpu_disassemble_instr(struct cpu
 		if (cpu->cd.ppc.bits == 32)
 			addr &= 0xffffffff;
 		if (cpu->cd.ppc.bits == 32)
-			debug("\t0x%"PRIx32, (uint32_t) addr);
+			debug("\t0x%" PRIx32, (uint32_t) addr);
 		else
-			debug("\t0x%"PRIx64, (uint64_t) addr);
+			debug("\t0x%" PRIx64, (uint64_t) addr);
 		symbol = get_symbol_name(&cpu->machine->symbol_context,
 		    addr, &offset);
 		if (symbol != NULL)
@@ -1086,7 +1086,7 @@ int ppc_cpu_disassemble_instr(struct cpu
 			if (symbol != NULL)
 				debug(" \t<%s", symbol);
 			else
-				debug(" \t<0x%"PRIx64, (uint64_t) addr);
+				debug(" \t<0x%" PRIx64, (uint64_t) addr);
 			if (wlen > 0 && !fpreg /* && !reverse */) {
 				/*  TODO  */
 			}
@@ -1257,10 +1257,10 @@ int ppc_cpu_disassemble_instr(struct cpu
 			    ppc_spr_names[spr]==NULL? "?" : ppc_spr_names[spr]);
 			if (running) {
 				if (cpu->cd.ppc.bits == 32)
-					debug(": 0x%"PRIx32, (uint32_t)
+					debug(": 0x%" PRIx32, (uint32_t)
 					    cpu->cd.ppc.spr[spr]);
 				else
-					debug(": 0x%"PRIx64, (uint64_t)
+					debug(": 0x%" PRIx64, (uint64_t)
 					    cpu->cd.ppc.spr[spr]);
 			}
 			debug(">");
@@ -1417,10 +1417,10 @@ int ppc_cpu_disassemble_instr(struct cpu
 			    ppc_spr_names[spr]==NULL? "?" : ppc_spr_names[spr]);
 			if (running) {
 				if (cpu->cd.ppc.bits == 32)
-					debug(": 0x%"PRIx32, (uint32_t)
+					debug(": 0x%" PRIx32, (uint32_t)
 					    cpu->cd.ppc.gpr[rs]);
 				else
-					debug(": 0x%"PRIx64, (uint64_t)
+					debug(": 0x%" PRIx64, (uint64_t)
 					    cpu->cd.ppc.gpr[rs]);
 			}
 			debug(">");
@@ -1573,7 +1573,7 @@ int ppc_cpu_disassemble_instr(struct cpu
 		if (symbol != NULL)
 			debug(" \t<%s", symbol);
 		else
-			debug(" \t<0x%"PRIx64, (uint64_t) addr);
+			debug(" \t<0x%" PRIx64, (uint64_t) addr);
 		if (wlen > 0 && load && wlen > 0) {
 			unsigned char tw[8];
 			uint64_t tdata = 0;
@@ -1597,12 +1597,12 @@ int ppc_cpu_disassemble_instr(struct cpu
 					if (symbol != NULL)
 						debug("%s", symbol);
 					else
-						debug("0x%"PRIx64,
+						debug("0x%" PRIx64,
 						    (uint64_t) tdata);
 				} else {
 					/*  TODO: if load==2, then this is
 					    a _signed_ load.  */
-					debug("0x%"PRIx64, (uint64_t) tdata);
+					debug("0x%" PRIx64, (uint64_t) tdata);
 				}
 			} else
 				debug(": unreadable");
@@ -1620,12 +1620,12 @@ int ppc_cpu_disassemble_instr(struct cpu
 				if (symbol != NULL)
 					debug("%s", symbol);
 				else
-					debug("0x%"PRIx64, (uint64_t) tdata);
+					debug("0x%" PRIx64, (uint64_t) tdata);
 			} else {
 				if (tdata > -256 && tdata < 256)
 					debug("%i", (int)tdata);
 				else
-					debug("0x%"PRIx64, (uint64_t) tdata);
+					debug("0x%" PRIx64, (uint64_t) tdata);
 			}
 		}
 		debug(">");
@@ -1817,7 +1817,7 @@ static void debug_spr_usage(uint64_t pc,
 			break;
 		} else
 			fatal("[ using UNIMPLEMENTED spr %i (%s), pc = "
-			    "0x%"PRIx64" ]\n", spr, ppc_spr_names[spr] == NULL?
+			    "0x%" PRIx64 " ]\n", spr, ppc_spr_names[spr] == NULL?
 			    "UNKNOWN" : ppc_spr_names[spr], (uint64_t) pc);
 	}
 
@@ -1862,5 +1862,3 @@ void update_cr0(struct cpu *cpu, uint64_
 
 
 #include "tmp_ppc_tail.cc"
-
-
