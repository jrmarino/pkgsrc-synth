$NetBSD: patch-src_cpus_cpu__m88k.cc,v 1.1 2018/03/21 17:39:42 kamil Exp $

Fix C++11 literals.

--- src/cpus/cpu_m88k.cc.orig	2014-08-17 08:45:15.000000000 +0000
+++ src/cpus/cpu_m88k.cc
@@ -278,7 +278,7 @@ void m88k_cpu_register_dump(struct cpu *
 	if (gprs) {
 		symbol = get_symbol_name(&cpu->machine->symbol_context,
 		    cpu->pc, &offset);
-		debug("cpu%i:  pc  = 0x%08"PRIx32, x, (uint32_t)cpu->pc);
+		debug("cpu%i:  pc  = 0x%08" PRIx32, x, (uint32_t)cpu->pc);
 		debug("  <%s>\n", symbol != NULL? symbol : " no symbol ");
 
 		for (i=0; i<N_M88K_REGS; i++) {
@@ -287,7 +287,7 @@ void m88k_cpu_register_dump(struct cpu *
 			if (i == 0)
 				debug("                  ");
 			else
-				debug("  r%-2i = 0x%08"PRIx32,
+				debug("  r%-2i = 0x%08" PRIx32,
 				    i, cpu->cd.m88k.r[i]);
 			if ((i % 4) == 3)
 				debug("\n");
@@ -304,7 +304,7 @@ void m88k_cpu_register_dump(struct cpu *
 		for (i=0; i<n_control_regs; i++) {
 			if ((i % 4) == 0)
 				debug("cpu%i:", x);
-			debug("  %4s=0x%08"PRIx32,
+			debug("  %4s=0x%08" PRIx32,
 			    m88k_cr_name(cpu, i), cpu->cd.m88k.cr[i]);
 			if ((i % 4) == 3)
 				debug("\n");
@@ -317,7 +317,7 @@ void m88k_cpu_register_dump(struct cpu *
 		for (i=0; i<n_fpu_control_regs; i++) {
 			if ((i % 4) == 0)
 				debug("cpu%i:", x);
-			debug("  %5s=0x%08"PRIx32,
+			debug("  %5s=0x%08" PRIx32,
 			    m88k_fcr_name(cpu, i), cpu->cd.m88k.fcr[i]);
 			if ((i % 4) == 3)
 				debug("\n");
@@ -357,8 +357,8 @@ void m88k_cpu_tlbdump(struct machine *m,
 			for (i = 0; i < N_M88200_BATC_REGS; i++) {
 				uint32_t b = cmmu->batc[i];
 				printf("cpu%i: BATC[%2i]: ", cpu_nr, i);
-				printf("v=0x%08"PRIx32, b & 0xfff80000);
-				printf(", p=0x%08"PRIx32,
+				printf("v=0x%08" PRIx32, b & 0xfff80000);
+				printf(", p=0x%08" PRIx32,
 				    (b << 13) & 0xfff80000);
 				printf(", %s %s %s %s %s %s\n",
 				    b & BATC_SO? "SP " : "!sp",
@@ -379,8 +379,8 @@ void m88k_cpu_tlbdump(struct machine *m,
 					printf("superv");
 				else
 					printf("user  ");
-				printf(" v=0x%08"PRIx32, v & 0xfffff000);
-				printf(", p=0x%08"PRIx32, p & 0xfffff000);
+				printf(" v=0x%08" PRIx32, v & 0xfffff000);
+				printf(", p=0x%08" PRIx32, p & 0xfffff000);
 
 				printf("  %s %s %s %s %s %s %s",
 				    v & PG_U1?   "U1 " : "!u1",
@@ -633,8 +633,8 @@ static void m88k_memory_transaction_debu
 		}
 		debug("bytebits=0x%x ]\n", DMT_ENBITS(dmt));
 
-		debug("[ DMD%i: 0x%08"PRIx32"; ", n, cpu->cd.m88k.dmd[n]);
-		debug("DMA%i: 0x%08"PRIx32" ]\n", n, cpu->cd.m88k.dma[n]);
+		debug("[ DMD%i: 0x%08" PRIx32 "; ", n, cpu->cd.m88k.dmd[n]);
+		debug("DMA%i: 0x%08" PRIx32 " ]\n", n, cpu->cd.m88k.dma[n]);
 	} else
 		debug("not valid ]\n");
 }
@@ -852,7 +852,7 @@ int m88k_cpu_disassemble_instr(struct cp
 	if (cpu->machine->ncpus > 1 && running)
 		debug("cpu%i:\t", cpu->cpu_id);
 
-	debug("%c%08"PRIx32": ",
+	debug("%c%08" PRIx32 ": ",
 	    cpu->cd.m88k.cr[M88K_CR_PSR] & M88K_PSR_MODE? 's' : 'u',
 	    (uint32_t) dumpaddr);
 
@@ -861,7 +861,7 @@ int m88k_cpu_disassemble_instr(struct cp
 	else
 		iw = ib[3] + (ib[2]<<8) + (ib[1]<<16) + (ib[0]<<24);
 
-	debug("%08"PRIx32, (uint32_t) iw);
+	debug("%08" PRIx32, (uint32_t) iw);
 
 	if (running && cpu->delay_slot)
 		debug(" (d)");
@@ -914,23 +914,23 @@ int m88k_cpu_disassemble_instr(struct cp
 			if (symbol != NULL && supervisor)
 				debug("\t; [<%s>]", symbol);
 			else
-				debug("\t; [0x%08"PRIx32"]", tmpaddr);
+				debug("\t; [0x%08" PRIx32 "]", tmpaddr);
 			if (op26 >= 0x08) {
 				/*  Store:  */
 				debug(" = ");
 				switch (op26 & 3) {
-				case 0:	debug("0x%016"PRIx64, (uint64_t)
+				case 0:	debug("0x%016" PRIx64, (uint64_t)
 					    ((((uint64_t) cpu->cd.m88k.r[d])
 					    << 32) + ((uint64_t)
 					    cpu->cd.m88k.r[d+1])) );
 					break;
-				case 1:	debug("0x%08"PRIx32,
+				case 1:	debug("0x%08" PRIx32,
 					    (uint32_t) cpu->cd.m88k.r[d]);
 					break;
-				case 2:	debug("0x%04"PRIx16,
+				case 2:	debug("0x%04" PRIx16,
 					    (uint16_t) cpu->cd.m88k.r[d]);
 					break;
-				case 3:	debug("0x%02"PRIx8,
+				case 3:	debug("0x%02" PRIx8,
 					    (uint8_t) cpu->cd.m88k.r[d]);
 					break;
 				}
@@ -967,7 +967,7 @@ int m88k_cpu_disassemble_instr(struct cp
 				if (symbol != NULL && supervisor)
 					debug("\t; [<%s>]", symbol);
 				else
-					debug("\t; [0x%08"PRIx32"]", tmpaddr);
+					debug("\t; [0x%08" PRIx32 "]", tmpaddr);
 			}
 		}
 		debug("\n");
@@ -1023,7 +1023,7 @@ int m88k_cpu_disassemble_instr(struct cp
 				if (symbol != NULL && supervisor)
 					debug("<%s>", symbol);
 				else
-					debug("0x%08"PRIx32, tmpaddr);
+					debug("0x%08" PRIx32, tmpaddr);
 			}
 		}
 
@@ -1145,7 +1145,7 @@ int m88k_cpu_disassemble_instr(struct cp
 		debug("b%sr%s\t",
 		    op26 >= 0x32? "s" : "",
 		    op26 & 1? ".n" : "");
-		debug("0x%08"PRIx32, (uint32_t) (dumpaddr + d26));
+		debug("0x%08" PRIx32, (uint32_t) (dumpaddr + d26));
 		symbol = get_symbol_name(&cpu->machine->symbol_context,
 		    dumpaddr + d26, &offset);
 		if (symbol != NULL && supervisor)
@@ -1184,7 +1184,7 @@ int m88k_cpu_disassemble_instr(struct cp
 		} else {
 			debug("%i", d);
 		}
-		debug(",r%i,0x%08"PRIx32, s1, (uint32_t) (dumpaddr + d16));
+		debug(",r%i,0x%08" PRIx32, s1, (uint32_t) (dumpaddr + d16));
 		symbol = get_symbol_name(&cpu->machine->symbol_context,
 		    dumpaddr + d16, &offset);
 		if (symbol != NULL && supervisor)
@@ -1225,7 +1225,7 @@ int m88k_cpu_disassemble_instr(struct cp
 				if (symbol != NULL && supervisor)
 					debug("\t; [<%s>]", symbol);
 				else
-					debug("\t; [0x%08"PRIx32"]", tmpaddr);
+					debug("\t; [0x%08" PRIx32 "]", tmpaddr);
 			}
 
 			debug("\n");
@@ -1314,7 +1314,7 @@ int m88k_cpu_disassemble_instr(struct cp
 				if (symbol != NULL && supervisor)
 					debug("\t; [<%s>]", symbol);
 				else
-					debug("\t; [0x%08"PRIx32"]", tmpaddr);
+					debug("\t; [0x%08" PRIx32 "]", tmpaddr);
 			}
 
 			debug("\n");
@@ -1410,7 +1410,7 @@ int m88k_cpu_disassemble_instr(struct cp
 				if (symbol != NULL && supervisor)
 					debug("<%s>", symbol);
 				else
-					debug("0x%08"PRIx32, tmpaddr);
+					debug("0x%08" PRIx32, tmpaddr);
 			}
 			debug("\n");
 			break;
@@ -1456,5 +1456,3 @@ int m88k_cpu_disassemble_instr(struct cp
 
 
 #include "tmp_m88k_tail.cc"
-
-
