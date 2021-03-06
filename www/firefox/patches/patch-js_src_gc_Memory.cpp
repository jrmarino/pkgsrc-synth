$NetBSD: patch-js_src_gc_Memory.cpp,v 1.4 2018/06/26 09:37:10 jperkin Exp $

Support SunOS/x86_64.

--- js/src/gc/Memory.cpp.orig	2018-06-05 19:47:29.000000000 +0000
+++ js/src/gc/Memory.cpp
@@ -504,6 +504,7 @@ MapMemoryAt(void* desired, size_t length
 {
 
 #if defined(__ia64__) || defined(__aarch64__) || \
+    (defined(__sun) && defined(__x86_64__)) || \
     (defined(__sparc__) && defined(__arch64__) && (defined(__NetBSD__) || defined(__linux__)))
     MOZ_ASSERT((0xffff800000000000ULL & (uintptr_t(desired) + length - 1)) == 0);
 #endif
@@ -554,7 +555,7 @@ MapMemory(size_t length, int prot = PROT
         return nullptr;
     }
     return region;
-#elif defined(__aarch64__) || (defined(__sparc__) && defined(__arch64__) && defined(__linux__))
+#elif defined(__aarch64__) || (defined(__sparc__) && defined(__arch64__) && defined(__linux__)) || (defined(__sun) && defined(__x86_64__))
    /*
     * There might be similar virtual address issue on arm64 which depends on
     * hardware and kernel configurations. But the work around is slightly
