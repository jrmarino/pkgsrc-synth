$NetBSD: patch-ipc_chromium_src_base_process__util.h,v 1.1 2013/01/10 16:17:10 ryoon Exp $

--- ipc/chromium/src/base/process_util.h.orig	2012-08-24 22:55:37.000000000 +0000
+++ ipc/chromium/src/base/process_util.h
@@ -280,6 +280,7 @@ class NamedProcessIterator {
   const ProcessEntry* NextProcessEntry();
 
  private:
+#if !defined(OS_BSD)
   // Determines whether there's another process (regardless of executable)
   // left in the list of all processes.  Returns true and sets entry_ to
   // that process's info if there is one, false otherwise.
@@ -292,18 +293,24 @@ class NamedProcessIterator {
   void InitProcessEntry(ProcessEntry* entry);
 
   std::wstring executable_name_;
+#endif
 
 #if defined(OS_WIN)
   HANDLE snapshot_;
   bool started_iteration_;
 #elif defined(OS_LINUX)
   DIR *procfs_dir_;
+#elif defined(OS_BSD)
+  std::vector<ProcessEntry> content;
+  size_t nextEntry;
 #elif defined(OS_MACOSX)
   std::vector<kinfo_proc> kinfo_procs_;
   size_t index_of_kinfo_proc_;
 #endif
+#if !defined(OS_BSD)
   ProcessEntry entry_;
   const ProcessFilter* filter_;
+#endif
 
   DISALLOW_EVIL_CONSTRUCTORS(NamedProcessIterator);
 };
