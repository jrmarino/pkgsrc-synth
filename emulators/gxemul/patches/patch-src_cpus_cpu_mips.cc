$NetBSD: patch-src_cpus_cpu_mips.cc,v 1.2 2018/03/21 17:39:42 kamil Exp $

implement trap with immediate instructions present in MIPS32.

Fix C++11 literals.

--- src/cpus/cpu_mips.cc.orig	2014-08-17 08:45:15.000000000 +0000
+++ src/cpus/cpu_mips.cc
@@ -514,13 +514,13 @@ void mips_cpu_tlbdump(struct machine *m,
 				    (int) cop0->reg[COP0_INDEX],
 				    (int) cop0->reg[COP0_RANDOM]);
 			else
-				printf("index=0x%016"PRIx64
-				    " random=0x%016"PRIx64,
+				printf("index=0x%016" PRIx64
+				    " random=0x%016" PRIx64,
 				    (uint64_t) cop0->reg[COP0_INDEX],
 				    (uint64_t) cop0->reg[COP0_RANDOM]);
 
 			if (m->cpus[i]->cd.mips.cpu_type.isa_level >= 3)
-				printf(" wired=0x%"PRIx64,
+				printf(" wired=0x%" PRIx64,
 				    (uint64_t) cop0->reg[COP0_WIRED]);
 
 			printf(")\n");
@@ -529,22 +529,22 @@ void mips_cpu_tlbdump(struct machine *m,
 			    nr_of_tlb_entries; j++) {
 				if (m->cpus[i]->cd.mips.cpu_type.mmu_model ==
 				    MMU3K)
-					printf("%3i: hi=0x%08"PRIx32" lo=0x%08"
-					    PRIx32"\n", j,
+					printf("%3i: hi=0x%08" PRIx32 " lo=0x%08"
+					    PRIx32 "\n", j,
 					    (uint32_t) cop0->tlbs[j].hi,
 					    (uint32_t) cop0->tlbs[j].lo0);
 				else if (m->cpus[i]->is_32bit)
-					printf("%3i: hi=0x%08"PRIx32" mask=0x"
-					    "%08"PRIx32" lo0=0x%08"PRIx32
-					    " lo1=0x%08"PRIx32"\n", j,
+					printf("%3i: hi=0x%08" PRIx32 " mask=0x"
+					    "%08" PRIx32 " lo0=0x%08" PRIx32
+					    " lo1=0x%08" PRIx32 "\n", j,
 					    (uint32_t) cop0->tlbs[j].hi,
 					    (uint32_t) cop0->tlbs[j].mask,
 					    (uint32_t) cop0->tlbs[j].lo0,
 					    (uint32_t) cop0->tlbs[j].lo1);
 				else
-					printf("%3i: hi=0x%016"PRIx64" mask="
-					    "0x%016"PRIx64" lo0=0x%016"PRIx64
-					    " lo1=0x%016"PRIx64"\n", j,
+					printf("%3i: hi=0x%016" PRIx64 " mask="
+					    "0x%016" PRIx64 " lo0=0x%016" PRIx64
+					    " lo1=0x%016" PRIx64 "\n", j,
 					    (uint64_t) cop0->tlbs[j].hi,
 					    (uint64_t) cop0->tlbs[j].mask,
 					    (uint64_t) cop0->tlbs[j].lo0,
@@ -579,7 +579,7 @@ void mips_cpu_tlbdump(struct machine *m,
 		default:printf("index=0x%x random=0x%x",
 			    (int) (cop0->reg[COP0_INDEX] & INDEX_MASK),
 			    (int) (cop0->reg[COP0_RANDOM] & RANDOM_MASK));
-			printf(" wired=0x%"PRIx64,
+			printf(" wired=0x%" PRIx64,
 			    (uint64_t) cop0->reg[COP0_WIRED]);
 		}
 
@@ -622,11 +622,11 @@ void mips_cpu_tlbdump(struct machine *m,
 				break;
 			default:switch (m->cpus[i]->cd.mips.cpu_type.mmu_model){
 				case MMU32:
-					printf("vaddr=0x%08"PRIx32" ",
+					printf("vaddr=0x%08" PRIx32 " ",
 					    (uint32_t) (hi & ~mask));
 					break;
 				default:/*  R4x00, R1x000, MIPS64, etc.  */
-					printf("vaddr=%016"PRIx64" ",
+					printf("vaddr=%016" PRIx64 " ",
 					    (uint64_t) (hi & ~mask));
 				}
 				if (hi & TLB_G)
@@ -644,7 +644,7 @@ void mips_cpu_tlbdump(struct machine *m,
 					paddr >>= ENTRYLO_PFN_SHIFT;
 					paddr <<= pageshift;
 					paddr &= ~(mask >> 1);
-					printf(" p0=0x%09"PRIx64" ",
+					printf(" p0=0x%09" PRIx64 " ",
 					    (uint64_t) paddr);
 				}
 				printf(lo0 & ENTRYLO_D? "D" : " ");
@@ -656,7 +656,7 @@ void mips_cpu_tlbdump(struct machine *m,
 					paddr >>= ENTRYLO_PFN_SHIFT;
 					paddr <<= pageshift;
 					paddr &= ~(mask >> 1);
-					printf(" p1=0x%09"PRIx64" ",
+					printf(" p1=0x%09" PRIx64 " ",
 					    (uint64_t) paddr);
 				}
 				printf(lo1 & ENTRYLO_D? "D" : " ");
@@ -718,9 +718,9 @@ int mips_cpu_disassemble_instr(struct cp
 		debug("cpu%i: ", cpu->cpu_id);
 
 	if (cpu->is_32bit)
-		debug("%08"PRIx32, (uint32_t)dumpaddr);
+		debug("%08" PRIx32, (uint32_t)dumpaddr);
 	else
-		debug("%016"PRIx64, (uint64_t)dumpaddr);
+		debug("%016" PRIx64, (uint64_t)dumpaddr);
 
 	memcpy(instr, originstr, sizeof(uint32_t));
 
@@ -1008,9 +1008,9 @@ int mips_cpu_disassemble_instr(struct cp
 		}
 
 		if (cpu->is_32bit)
-			debug("0x%08"PRIx32, (uint32_t)addr);
+			debug("0x%08" PRIx32, (uint32_t)addr);
 		else
-			debug("0x%016"PRIx64, (uint64_t)addr);
+			debug("0x%016" PRIx64, (uint64_t)addr);
 
 		symbol = get_symbol_name(&cpu->machine->symbol_context,
 		    addr, &offset);
@@ -1187,7 +1187,7 @@ int mips_cpu_disassemble_instr(struct cp
 			    rt, imm, regnames[rs]);
 
 			if (running) {
-				debug("\t[0x%016"PRIx64" = %s]",
+				debug("\t[0x%016" PRIx64 " = %s]",
 				    (uint64_t)(cpu->cd.mips.gpr[rs] + imm));
 				if (symbol != NULL)
 					debug(" = %s", symbol);
@@ -1212,10 +1212,10 @@ int mips_cpu_disassemble_instr(struct cp
 			debug("\t[");
 
 			if (cpu->is_32bit)
-				debug("0x%08"PRIx32,
+				debug("0x%08" PRIx32,
 				    (uint32_t) (cpu->cd.mips.gpr[rs] + imm));
 			else
-				debug("0x%016"PRIx64,
+				debug("0x%016" PRIx64,
 				    (uint64_t) (cpu->cd.mips.gpr[rs] + imm));
 
 			if (symbol != NULL)
@@ -1239,9 +1239,9 @@ int mips_cpu_disassemble_instr(struct cp
 		    addr, &offset);
 		debug("%s\t0x", hi6_names[hi6]);
 		if (cpu->is_32bit)
-			debug("%08"PRIx32, (uint32_t) addr);
+			debug("%08" PRIx32, (uint32_t) addr);
 		else
-			debug("%016"PRIx64, (uint64_t) addr);
+			debug("%016" PRIx64, (uint64_t) addr);
 		if (symbol != NULL)
 			debug("\t<%s>", symbol);
 		break;
@@ -1281,7 +1281,7 @@ int mips_cpu_disassemble_instr(struct cp
 		if (cache_op==6)	debug("hit writeback");
 		if (cache_op==7)	debug("hit set virtual");
 		if (running)
-			debug(", addr 0x%016"PRIx64,
+			debug(", addr 0x%016" PRIx64,
 			    (uint64_t)(cpu->cd.mips.gpr[rt] + imm));
 		if (showtag)
 		debug(", taghi=%08lx lo=%08lx",
@@ -1457,14 +1457,20 @@ int mips_cpu_disassemble_instr(struct cp
 		case REGIMM_BLTZALL:
 		case REGIMM_BGEZAL:
 		case REGIMM_BGEZALL:
+		case REGIMM_TGEI:
+		case REGIMM_TGEIU:
+		case REGIMM_TLTI:
+		case REGIMM_TLTIU:
+		case REGIMM_TEQI:
+		case REGIMM_TNEI:
 			debug("%s\t%s,", regimm_names[regimm5], regnames[rs]);
 
 			addr = (dumpaddr + 4) + (imm << 2);
 
 			if (cpu->is_32bit)
-				debug("0x%08"PRIx32, (uint32_t) addr);
+				debug("0x%08" PRIx32, (uint32_t) addr);
 			else
-				debug("0x%016"PRIx64, (uint64_t) addr);
+				debug("0x%016" PRIx64, (uint64_t) addr);
 			break;
 
 		case REGIMM_SYNCI:
@@ -1509,30 +1515,30 @@ void mips_cpu_register_dump(struct cpu *
 		    cpu->pc, &offset);
 
 		if (bits32)
-			debug("cpu%i:  pc = %08"PRIx32,
+			debug("cpu%i:  pc = %08" PRIx32,
 			    cpu->cpu_id, (uint32_t) cpu->pc);
 		else if (bits128)
-			debug("cpu%i:  pc=%016"PRIx64,
+			debug("cpu%i:  pc=%016" PRIx64,
 			    cpu->cpu_id, (uint64_t) cpu->pc);
 		else
-			debug("cpu%i:    pc = 0x%016"PRIx64,
+			debug("cpu%i:    pc = 0x%016" PRIx64,
 			    cpu->cpu_id, (uint64_t) cpu->pc);
 
 		debug("    <%s>\n", symbol != NULL? symbol :
 		    " no symbol ");
 
 		if (bits32)
-			debug("cpu%i:  hi = %08"PRIx32"  lo = %08"PRIx32"\n",
+			debug("cpu%i:  hi = %08" PRIx32 "  lo = %08" PRIx32 "\n",
 			    cpu->cpu_id, (uint32_t) cpu->cd.mips.hi,
 			    (uint32_t) cpu->cd.mips.lo);
 		else if (bits128) {
-			debug("cpu%i:  hi=%016"PRIx64"%016"PRIx64"  lo="
-			    "%016"PRIx64"%016"PRIx64"\n", cpu->cpu_id,
+			debug("cpu%i:  hi=%016" PRIx64 "%016" PRIx64 "  lo="
+			    "%016" PRIx64 "%016" PRIx64 "\n", cpu->cpu_id,
 			    cpu->cd.mips.hi1, cpu->cd.mips.hi,
 			    cpu->cd.mips.lo1, cpu->cd.mips.lo);
 		} else {
-			debug("cpu%i:    hi = 0x%016"PRIx64"    lo = 0x%016"
-			    PRIx64"\n", cpu->cpu_id,
+			debug("cpu%i:    hi = 0x%016" PRIx64 "    lo = 0x%016"
+			    PRIx64 "\n", cpu->cpu_id,
 			    (uint64_t) cpu->cd.mips.hi,
 			    (uint64_t) cpu->cd.mips.lo);
 		}
@@ -1548,7 +1554,7 @@ void mips_cpu_register_dump(struct cpu *
 					debug("                           "
 					    "          ");
 				else
-					debug(" %3s=%016"PRIx64"%016"PRIx64,
+					debug(" %3s=%016" PRIx64 "%016" PRIx64,
 					    regnames[r], (uint64_t)
 					    cpu->cd.mips.gpr_quadhi[r],
 					    (uint64_t)cpu->cd.mips.gpr[r]);
@@ -1563,7 +1569,7 @@ void mips_cpu_register_dump(struct cpu *
 				if (i == MIPS_GPR_ZERO)
 					debug("               ");
 				else
-					debug(" %3s = %08"PRIx32, regnames[i],
+					debug(" %3s = %08" PRIx32, regnames[i],
 					    (uint32_t)cpu->cd.mips.gpr[i]);
 				if ((i & 3) == 3)
 					debug("\n");
@@ -1577,7 +1583,7 @@ void mips_cpu_register_dump(struct cpu *
 				if (r == MIPS_GPR_ZERO)
 					debug("                           ");
 				else
-					debug("   %3s = 0x%016"PRIx64,
+					debug("   %3s = 0x%016" PRIx64,
 					    regnames[r],
 					    (uint64_t)cpu->cd.mips.gpr[r]);
 				if ((i & 1) == 1)
@@ -1622,7 +1628,7 @@ void mips_cpu_register_dump(struct cpu *
 					    (int) cpu->cd.mips.coproc[
 					    coprocnr]->reg[i]);
 				else
-					debug(" = 0x%016"PRIx64, (uint64_t)
+					debug(" = 0x%016" PRIx64, (uint64_t)
 					    cpu->cd.mips.coproc[
 					    coprocnr]->reg[i]);
 			}
@@ -1640,10 +1646,10 @@ void mips_cpu_register_dump(struct cpu *
 			debug("cpu%i: ", cpu->cpu_id);
 			debug("config_select1 = 0x");
 			if (cpu->is_32bit)
-				debug("%08"PRIx32,
+				debug("%08" PRIx32,
 				    (uint32_t)cpu->cd.mips.cop0_config_select1);
 			else
-				debug("%016"PRIx64,
+				debug("%016" PRIx64,
 				    (uint64_t)cpu->cd.mips.cop0_config_select1);
 			debug("\n");
 		}
@@ -1673,7 +1679,7 @@ void mips_cpu_register_dump(struct cpu *
 
 	if (cpu->cd.mips.rmw) {
 		printf("cpu%i: Read-Modify-Write in progress, address "
-		    "0x%016"PRIx64"\n", cpu->cpu_id, cpu->cd.mips.rmw_addr);
+		    "0x%016" PRIx64 "\n", cpu->cpu_id, cpu->cd.mips.rmw_addr);
 	}
 }
 
@@ -1764,10 +1770,10 @@ void mips_cpu_exception(struct cpu *cpu,
 					    d, strbuf, sizeof(strbuf)));
 				} else {
 					if (cpu->is_32bit)
-						debug(" a%i=0x%"PRIx32, x,
+						debug(" a%i=0x%" PRIx32, x,
 						    (uint32_t)d);
 					else
-						debug(" a%i=0x%"PRIx64, x,
+						debug(" a%i=0x%" PRIx64, x,
 						    (uint64_t)d);
 				}
 			}
@@ -1781,13 +1787,13 @@ void mips_cpu_exception(struct cpu *cpu,
 			if (cpu->is_32bit)
 				debug(" vaddr=0x%08x", (int)vaddr);
 			else
-				debug(" vaddr=0x%016"PRIx64, (uint64_t)vaddr);
+				debug(" vaddr=0x%016" PRIx64, (uint64_t)vaddr);
 		}
 
 		if (cpu->is_32bit)
-			debug(" pc=0x%08"PRIx32" ", (uint32_t)cpu->pc);
+			debug(" pc=0x%08" PRIx32" ", (uint32_t)cpu->pc);
 		else
-			debug(" pc=0x%016"PRIx64" ", (uint64_t)cpu->pc);
+			debug(" pc=0x%016" PRIx64" ", (uint64_t)cpu->pc);
 
 		if (symbol != NULL)
 			debug("<%s> ]\n", symbol);
@@ -1804,14 +1810,14 @@ void mips_cpu_exception(struct cpu *cpu,
 			fatal("cpu%i: ", cpu->cpu_id);
 		fatal("warning: LOW reference: vaddr=");
 		if (cpu->is_32bit)
-			fatal("0x%08"PRIx32, (uint32_t) vaddr);
+			fatal("0x%08" PRIx32, (uint32_t) vaddr);
 		else
-			fatal("0x%016"PRIx64, (uint64_t) vaddr);
+			fatal("0x%016" PRIx64, (uint64_t) vaddr);
 		fatal(", exception %s, pc=", exception_names[exccode]);
 		if (cpu->is_32bit)
-			fatal("0x%08"PRIx32, (uint32_t) cpu->pc);
+			fatal("0x%08" PRIx32, (uint32_t) cpu->pc);
 		else
-			fatal("0x%016"PRIx64, (uint64_t)cpu->pc);
+			fatal("0x%016" PRIx64, (uint64_t)cpu->pc);
 		fatal(" <%s> ]\n", symbol? symbol : "(no symbol)");
 	}
 
@@ -1974,4 +1980,3 @@ void mips_cpu_exception(struct cpu *cpu,
 
 
 #include "tmp_mips_tail.cc"
-
