$NetBSD: patch-src_debugger_debugger__cmds.cc,v 1.1 2018/03/21 17:39:42 kamil Exp $

--- src/debugger/debugger_cmds.cc.orig	2014-08-17 08:45:14.000000000 +0000
+++ src/debugger/debugger_cmds.cc
@@ -201,7 +201,7 @@ static void debugger_cmd_device(struct m
 			printf("No memory-mapped devices in this machine.\n");
 
 		for (i=0; i<mem->n_mmapped_devices; i++) {
-			printf("%2i: %25s @ 0x%011"PRIx64", len = 0x%"PRIx64,
+			printf("%2i: %25s @ 0x%011" PRIx64 ", len = 0x%" PRIx64,
 			    i, mem->devices[i].name,
 			    (uint64_t) mem->devices[i].baseaddr,
 			    (uint64_t) mem->devices[i].length);
@@ -313,9 +313,9 @@ static void debugger_cmd_dump(struct mac
 		    MEM_READ, CACHE_NONE | NO_EXCEPTIONS);
 
 		if (c->is_32bit)
-			printf("0x%08"PRIx32"  ", (uint32_t) addr);
+			printf("0x%08" PRIx32 "  ", (uint32_t) addr);
 		else
-			printf("0x%016"PRIx64"  ", (uint64_t) addr);
+			printf("0x%016" PRIx64 "  ", (uint64_t) addr);
 
 		if (r == MEMORY_ACCESS_FAILED)
 			printf("(memory access failed)\n");
@@ -491,9 +491,9 @@ static void debugger_cmd_lookup(struct m
 		}
 		printf("%s = 0x", cmd_line);
 		if (m->cpus[0]->is_32bit)
-			printf("%08"PRIx32"\n", (uint32_t) newaddr);
+			printf("%08" PRIx32 "\n", (uint32_t) newaddr);
 		else
-			printf("%016"PRIx64"\n", (uint64_t) newaddr);
+			printf("%016" PRIx64 "\n", (uint64_t) newaddr);
 		return;
 	}
 
@@ -501,9 +501,9 @@ static void debugger_cmd_lookup(struct m
 
 	if (symbol != NULL) {
 		if (m->cpus[0]->is_32bit)
-			printf("0x%08"PRIx32, (uint32_t) addr);
+			printf("0x%08" PRIx32, (uint32_t) addr);
 		else
-			printf("0x%016"PRIx64, (uint64_t) addr);
+			printf("0x%016" PRIx64, (uint64_t) addr);
 		printf(" = %s\n", symbol);
 	} else
 		printf("lookup for '%s' failed\n", cmd_line);
@@ -636,16 +636,16 @@ static void debugger_cmd_print(struct ma
 		printf("Multiple matches. Try prefixing with %%, $, or @.\n");
 		break;
 	case PARSE_SETTINGS:
-		printf("%s = 0x%"PRIx64"\n", cmd_line, (uint64_t)tmp);
+		printf("%s = 0x%" PRIx64 "\n", cmd_line, (uint64_t)tmp);
 		break;
 	case PARSE_SYMBOL:
 		if (m->cpus[0]->is_32bit)
-			printf("%s = 0x%08"PRIx32"\n", cmd_line, (uint32_t)tmp);
+			printf("%s = 0x%08" PRIx32 "\n", cmd_line, (uint32_t)tmp);
 		else
-			printf("%s = 0x%016"PRIx64"\n", cmd_line,(uint64_t)tmp);
+			printf("%s = 0x%016" PRIx64 "\n", cmd_line,(uint64_t)tmp);
 		break;
 	case PARSE_NUMBER:
-		printf("0x%"PRIx64"\n", (uint64_t) tmp);
+		printf("0x%" PRIx64 "\n", (uint64_t) tmp);
 		break;
 	}
 }
@@ -754,12 +754,12 @@ static void debugger_cmd_put(struct mach
 	case 'b':
 		a_byte = data;
 		if (m->cpus[0]->is_32bit)
-			printf("0x%08"PRIx32, (uint32_t) addr);
+			printf("0x%08" PRIx32, (uint32_t) addr);
 		else
-			printf("0x%016"PRIx64, (uint64_t) addr);
+			printf("0x%016" PRIx64, (uint64_t) addr);
 		printf(": %02x", a_byte);
 		if (data > 255)
-			printf(" (NOTE: truncating %0"PRIx64")",
+			printf(" (NOTE: truncating %0" PRIx64 ")",
 			    (uint64_t) data);
 		res = m->cpus[0]->memory_rw(m->cpus[0], m->cpus[0]->mem, addr,
 		    &a_byte, 1, MEM_WRITE, CACHE_NONE | NO_EXCEPTIONS);
@@ -771,12 +771,12 @@ static void debugger_cmd_put(struct mach
 		if ((addr & 1) != 0)
 			printf("WARNING: address isn't aligned\n");
 		if (m->cpus[0]->is_32bit)
-			printf("0x%08"PRIx32, (uint32_t) addr);
+			printf("0x%08" PRIx32, (uint32_t) addr);
 		else
-			printf("0x%016"PRIx64, (uint64_t) addr);
+			printf("0x%016" PRIx64, (uint64_t) addr);
 		printf(": %04x", (int)data);
 		if (data > 0xffff)
-			printf(" (NOTE: truncating %0"PRIx64")",
+			printf(" (NOTE: truncating %0" PRIx64 ")",
 			    (uint64_t) data);
 		res = store_16bit_word(m->cpus[0], addr, data);
 		if (!res)
@@ -787,15 +787,15 @@ static void debugger_cmd_put(struct mach
 		if ((addr & 3) != 0)
 			printf("WARNING: address isn't aligned\n");
 		if (m->cpus[0]->is_32bit)
-			printf("0x%08"PRIx32, (uint32_t) addr);
+			printf("0x%08" PRIx32, (uint32_t) addr);
 		else
-			printf("0x%016"PRIx64, (uint64_t) addr);
+			printf("0x%016" PRIx64, (uint64_t) addr);
 
 		printf(": %08x", (int)data);
 
 		if (data > 0xffffffff && (data >> 32) != 0
 		    && (data >> 32) != 0xffffffff)
-			printf(" (NOTE: truncating %0"PRIx64")",
+			printf(" (NOTE: truncating %0" PRIx64 ")",
 			    (uint64_t) data);
 
 		res = store_32bit_word(m->cpus[0], addr, data);
@@ -807,11 +807,11 @@ static void debugger_cmd_put(struct mach
 		if ((addr & 7) != 0)
 			printf("WARNING: address isn't aligned\n");
 		if (m->cpus[0]->is_32bit)
-			printf("0x%08"PRIx32, (uint32_t) addr);
+			printf("0x%08" PRIx32, (uint32_t) addr);
 		else
-			printf("0x%016"PRIx64, (uint64_t) addr);
+			printf("0x%016" PRIx64, (uint64_t) addr);
 
-		printf(": %016"PRIx64, (uint64_t) data);
+		printf(": %016" PRIx64, (uint64_t) data);
 
 		res = store_64bit_word(m->cpus[0], addr, data);
 		if (!res)
@@ -1381,4 +1381,3 @@ static void debugger_cmd_help(struct mac
 	    " registers, '@'\nfor symbols, and '$' for numeric values. Use"
 	    " 0x for hexadecimal values.\n");
 }
-
