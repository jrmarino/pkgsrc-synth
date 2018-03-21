$NetBSD: patch-src_machines_machine__test.cc,v 1.1 2018/03/21 17:39:42 kamil Exp $

Fix C++11 literals.

--- src/machines/machine_test.cc.orig	2014-08-17 08:45:14.000000000 +0000
+++ src/machines/machine_test.cc
@@ -106,37 +106,37 @@ static void default_test(struct machine 
 	snprintf(base_irq, sizeof(base_irq), "%s.cpu[%i]%s",
 	    machine->path, machine->bootstrap_cpu, end_of_base_irq);
 
-	snprintf(tmpstr, sizeof(tmpstr), "irqc addr=0x%"PRIx64" irq=%s",
+	snprintf(tmpstr, sizeof(tmpstr), "irqc addr=0x%" PRIx64 " irq=%s",
 	    (uint64_t) DEV_IRQC_ADDRESS, base_irq);
 	device_add(machine, tmpstr);
 
 
 	/*  Now, add the other devices:  */
 
-	snprintf(tmpstr, sizeof(tmpstr), "cons addr=0x%"PRIx64
+	snprintf(tmpstr, sizeof(tmpstr), "cons addr=0x%" PRIx64
 	    " irq=%s.irqc.2 in_use=%i",
 	    (uint64_t) DEV_CONS_ADDRESS, base_irq, machine->arch != ARCH_SH);
 	machine->main_console_handle = (size_t)device_add(machine, tmpstr);
 
-	snprintf(tmpstr, sizeof(tmpstr), "mp addr=0x%"PRIx64" irq=%s%sirqc.6",
+	snprintf(tmpstr, sizeof(tmpstr), "mp addr=0x%" PRIx64 " irq=%s%sirqc.6",
 	    (uint64_t) DEV_MP_ADDRESS,
 	    end_of_base_irq[0]? end_of_base_irq + 1 : "",
 	    end_of_base_irq[0]? "." : "");
 	device_add(machine, tmpstr);
 
-	snprintf(tmpstr, sizeof(tmpstr), "fbctrl addr=0x%"PRIx64,
+	snprintf(tmpstr, sizeof(tmpstr), "fbctrl addr=0x%" PRIx64,
 	    (uint64_t) DEV_FBCTRL_ADDRESS);
 	device_add(machine, tmpstr);
 
-	snprintf(tmpstr, sizeof(tmpstr), "disk addr=0x%"PRIx64,
+	snprintf(tmpstr, sizeof(tmpstr), "disk addr=0x%" PRIx64,
 	    (uint64_t) DEV_DISK_ADDRESS);
 	device_add(machine, tmpstr);
 
-	snprintf(tmpstr, sizeof(tmpstr), "ether addr=0x%"PRIx64" irq=%s.irqc.3",
+	snprintf(tmpstr, sizeof(tmpstr), "ether addr=0x%" PRIx64 " irq=%s.irqc.3",
 	    (uint64_t) DEV_ETHER_ADDRESS, base_irq);
 	device_add(machine, tmpstr);
 
-	snprintf(tmpstr, sizeof(tmpstr), "rtc addr=0x%"PRIx64" irq=%s.irqc.4",
+	snprintf(tmpstr, sizeof(tmpstr), "rtc addr=0x%" PRIx64 " irq=%s.irqc.4",
 	    (uint64_t) DEV_RTC_ADDRESS, base_irq);
 	device_add(machine, tmpstr);
 }
@@ -279,29 +279,29 @@ MACHINE_SETUP(oldtestmips)
 	machine->machine_name = strdup("MIPS test machine");
 	cpu->byte_order = EMUL_BIG_ENDIAN;
 
-	snprintf(tmpstr, sizeof(tmpstr), "cons addr=0x%"PRIx64" irq=%s."
+	snprintf(tmpstr, sizeof(tmpstr), "cons addr=0x%" PRIx64 " irq=%s."
 	    "cpu[%i].2", (uint64_t) DEV_CONS_ADDRESS, machine->path,
 	    machine->bootstrap_cpu);
 	machine->main_console_handle = (size_t)device_add(machine, tmpstr);
 
-	snprintf(tmpstr, sizeof(tmpstr), "mp addr=0x%"PRIx64" irq=6",
+	snprintf(tmpstr, sizeof(tmpstr), "mp addr=0x%" PRIx64 " irq=6",
 	    (uint64_t) DEV_MP_ADDRESS);
 	device_add(machine, tmpstr);
 
-	snprintf(tmpstr, sizeof(tmpstr), "fbctrl addr=0x%"PRIx64,
+	snprintf(tmpstr, sizeof(tmpstr), "fbctrl addr=0x%" PRIx64,
 	    (uint64_t) DEV_FBCTRL_ADDRESS);
 	device_add(machine, tmpstr);
 
-	snprintf(tmpstr, sizeof(tmpstr), "disk addr=0x%"PRIx64,
+	snprintf(tmpstr, sizeof(tmpstr), "disk addr=0x%" PRIx64,
 	    (uint64_t) DEV_DISK_ADDRESS);
 	device_add(machine, tmpstr);
 
-	snprintf(tmpstr, sizeof(tmpstr), "ether addr=0x%"PRIx64" irq=%s."
+	snprintf(tmpstr, sizeof(tmpstr), "ether addr=0x%" PRIx64 " irq=%s."
 	    "cpu[%i].3", (uint64_t) DEV_ETHER_ADDRESS, machine->path,
 	    machine->bootstrap_cpu);
 	device_add(machine, tmpstr);
 
-	snprintf(tmpstr, sizeof(tmpstr), "rtc addr=0x%"PRIx64" irq=%s."
+	snprintf(tmpstr, sizeof(tmpstr), "rtc addr=0x%" PRIx64 " irq=%s."
 	    "cpu[%i].4", (uint64_t) DEV_RTC_ADDRESS, machine->path,
 	    machine->bootstrap_cpu);
 	device_add(machine, tmpstr);
@@ -422,6 +422,3 @@ MACHINE_REGISTER(testsh)
 
 	machine_entry_add_alias(me, "testsh");
 }
-
-
-
