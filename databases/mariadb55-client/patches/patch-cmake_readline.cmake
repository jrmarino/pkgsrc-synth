$NetBSD: patch-cmake_readline.cmake,v 1.2 2015/05/07 12:45:29 fhajny Exp $

Fix cmake's check build error. Borrowed from mysql56's readline.cmake.
Fi build with pkgsrc readline>=6 that removed some deprecated symbols.
--- cmake/readline.cmake.orig	2015-02-13 12:07:00.000000000 +0000
+++ cmake/readline.cmake
@@ -132,7 +132,7 @@ MACRO (MYSQL_FIND_SYSTEM_READLINE)
     SET(CMAKE_REQUIRED_INCLUDES ${READLINE_INCLUDE_DIR})
     CHECK_CXX_SOURCE_COMPILES("
     #include <stdio.h>
-    #include <readline.h>
+    #include <readline/readline.h>
     int main(int argc, char **argv)
     {
       rl_completion_func_t *func1= (rl_completion_func_t*)0;
@@ -142,7 +142,7 @@ MACRO (MYSQL_FIND_SYSTEM_READLINE)
 
     CHECK_C_SOURCE_COMPILES("
     #include <stdio.h>
-    #include <readline.h>
+    #include <readline/readline.h>
     #if RL_VERSION_MAJOR > 5
     #error
     #endif
@@ -152,6 +152,19 @@ MACRO (MYSQL_FIND_SYSTEM_READLINE)
     }"
     READLINE_V5)
 
+    CHECK_C_SOURCE_COMPILES("
+    #include <stdio.h>
+    #include <readline/readline.h>
+    #if RL_VERSION_MAJOR < 6
+    #error
+    #endif
+    int main(int argc, char **argv)
+    {
+      return 0;
+    }"
+    READLINE_V6)
+    SET(USE_READLINE_V6 ${READLINE_V6})
+
     IF(NEW_READLINE_INTERFACE)
       IF (READLINE_V5)
         SET(USE_NEW_READLINE_INTERFACE 1)
@@ -180,8 +193,11 @@ MACRO (MYSQL_FIND_SYSTEM_LIBEDIT)
     #include <readline.h>
     int main(int argc, char **argv)
     {
-      int res= (*rl_completion_entry_function)(0,0);
+      typedef int MYFunction(const char*, int);
+      MYFunction* myf= rl_completion_entry_function;
+      int res= (myf)(NULL, 0);
       completion_matches(0,0);
+      return res;
     }"
     LIBEDIT_INTERFACE)
     SET(USE_LIBEDIT_INTERFACE ${LIBEDIT_INTERFACE})
@@ -195,32 +211,13 @@ MACRO (MYSQL_CHECK_READLINE)
     SET(WITH_READLINE OFF CACHE BOOL "Use bundled readline")
     FIND_CURSES()
 
-    IF(WITH_READLINE)
-      MYSQL_USE_BUNDLED_READLINE()
-    ELSE()
-      # OSX includes incompatible readline lib
-      IF (NOT APPLE)
-        MYSQL_FIND_SYSTEM_READLINE()
-      ENDIF()
-      IF(USE_NEW_READLINE_INTERFACE)
-        SET(MY_READLINE_INCLUDE_DIR ${READLINE_INCLUDE_DIR})
-        SET(MY_READLINE_LIBRARY ${READLINE_LIBRARY} ${CURSES_LIBRARY})
-      ELSE()
-        MYSQL_FIND_SYSTEM_LIBEDIT()
-        IF(USE_LIBEDIT_INTERFACE)
-          SET(MY_READLINE_INCLUDE_DIR ${LIBEDIT_INCLUDE_DIR})
-          SET(MY_READLINE_LIBRARY ${LIBEDIT_LIBRARY} ${CURSES_LIBRARY})
-        ELSE()
-          MYSQL_USE_BUNDLED_READLINE()
-        ENDIF()
-      ENDIF()
-    ENDIF()
+    MYSQL_FIND_SYSTEM_READLINE()
 
     SET(CMAKE_REQUIRED_LIBRARIES ${MY_READLINE_LIBRARY})
     SET(CMAKE_REQUIRED_INCLUDES ${MY_READLINE_INCLUDE_DIR})
     CHECK_CXX_SOURCE_COMPILES("
     #include <stdio.h>
-    #include <readline.h>
+    #include <readline/readline.h>
     int main(int argc, char **argv)
     {
        HIST_ENTRY entry;
