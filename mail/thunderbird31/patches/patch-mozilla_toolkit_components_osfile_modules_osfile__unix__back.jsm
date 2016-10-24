$NetBSD: patch-mozilla_toolkit_components_osfile_modules_osfile__unix__back.jsm,v 1.1 2015/07/13 17:49:26 ryoon Exp $

--- mozilla/toolkit/components/osfile/modules/osfile_unix_back.jsm.orig	2014-07-18 00:05:52.000000000 +0000
+++ mozilla/toolkit/components/osfile/modules/osfile_unix_back.jsm
@@ -228,8 +228,8 @@
          let statvfs = new SharedAll.HollowStructure("statvfs",
            Const.OSFILE_SIZEOF_STATVFS);
 
-         statvfs.add_field_at(Const.OSFILE_OFFSETOF_STATVFS_F_BSIZE,
-                        "f_bsize", Type.unsigned_long.implementation);
+         statvfs.add_field_at(Const.OSFILE_OFFSETOF_STATVFS_F_FRSIZE,
+                        "f_frsize", Type.unsigned_long.implementation);
          statvfs.add_field_at(Const.OSFILE_OFFSETOF_STATVFS_F_BAVAIL,
                         "f_bavail", Type.fsblkcnt_t.implementation);
 
@@ -632,21 +632,22 @@
            return Stat.fxstat(ver, fd, buf);
          };
        } else if (OS.Constants.Sys.Name == "NetBSD") {
-         // NetBSD 5.0 and newer
-         libc.declareLazyFFI(SysFile,  "stat",
-                             "__stat50", ctypes.default_abi,
+         // NetBSD 5.0 uses *30, and netbsd-6 uses *50
+         let v = OS.Constants.libc.OSFILE_SIZEOF_TIME_T < 8 ? "30" : "50";
+         libc.declareLazyFFI(SysFile,  "stat", 
+                             "__stat"+v, ctypes.default_abi,
                       /*return*/ Type.negativeone_or_nothing,
                       /*path*/   Type.path,
                       /*buf*/    Type.stat.out_ptr
                      );
          libc.declareLazyFFI(SysFile,  "lstat",
-                             "__lstat50", ctypes.default_abi,
+                             "__lstat"+v, ctypes.default_abi,
                       /*return*/ Type.negativeone_or_nothing,
                       /*path*/   Type.path,
                       /*buf*/    Type.stat.out_ptr
                      );
-         libc.declareLazyFFI(SysFile,  "fstat",
-                             "__fstat50", ctypes.default_abi,
+         libc.declareLazyFFI(SysFile,  "fstat", libc,
+                             "__fstat"+v, ctypes.default_abi,
                       /*return*/ Type.negativeone_or_nothing,
                       /*fd*/     Type.fd,
                       /*buf*/    Type.stat.out_ptr
