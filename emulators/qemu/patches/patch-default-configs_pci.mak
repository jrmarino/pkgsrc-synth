$NetBSD: patch-default-configs_pci.mak,v 1.2 2016/05/15 01:25:15 ryoon Exp $

--- default-configs/pci.mak.orig	2016-05-11 15:56:07.000000000 +0000
+++ default-configs/pci.mak
@@ -36,5 +36,5 @@ CONFIG_SDHCI=y
 CONFIG_EDU=y
 CONFIG_VGA=y
 CONFIG_VGA_PCI=y
-CONFIG_IVSHMEM=$(CONFIG_EVENTFD)
+CONFIG_IVSHMEM=$(CONFIG_SHM_OPEN)
 CONFIG_ROCKER=y
