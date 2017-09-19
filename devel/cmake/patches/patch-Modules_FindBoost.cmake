$NetBSD: patch-Modules_FindBoost.cmake,v 1.1 2017/09/19 15:58:21 prlw1 Exp $

- dbba53a5 FindBoost: Add version 1.65.1
- fa114e7d FindBoost: Add Boost 1.65 dependencies

--- Modules/FindBoost.cmake.orig	2017-09-07 16:10:58.000000000 +0000
+++ Modules/FindBoost.cmake
@@ -550,7 +550,10 @@ function(_Boost_COMPONENT_DEPENDENCIES c
   # The addition of a new release should only require it to be run
   # against the new release.
   set(_Boost_IMPORTED_TARGETS TRUE)
-  if(NOT Boost_VERSION VERSION_LESS 103300 AND Boost_VERSION VERSION_LESS 103500)
+  if(Boost_VERSION VERSION_LESS 103300)
+    message(WARNING "Imported targets and dependency information not available for Boost version ${Boost_VERSION} (all versions older than 1.33)")
+    set(_Boost_IMPORTED_TARGETS FALSE)
+  elseif(NOT Boost_VERSION VERSION_LESS 103300 AND Boost_VERSION VERSION_LESS 103500)
     set(_Boost_IOSTREAMS_DEPENDENCIES regex thread)
     set(_Boost_REGEX_DEPENDENCIES thread)
     set(_Boost_WAVE_DEPENDENCIES filesystem thread)
@@ -764,8 +767,27 @@ function(_Boost_COMPONENT_DEPENDENCIES c
     set(_Boost_WAVE_DEPENDENCIES filesystem system serialization thread chrono date_time atomic)
     set(_Boost_WSERIALIZATION_DEPENDENCIES serialization)
   else()
-    message(WARNING "Imported targets not available for Boost version ${Boost_VERSION}")
-    set(_Boost_IMPORTED_TARGETS FALSE)
+    if(NOT Boost_VERSION VERSION_LESS 106500)
+      set(_Boost_CHRONO_DEPENDENCIES system)
+      set(_Boost_CONTEXT_DEPENDENCIES thread chrono system date_time)
+      set(_Boost_COROUTINE_DEPENDENCIES context system)
+      set(_Boost_FIBER_DEPENDENCIES context thread chrono system date_time)
+      set(_Boost_FILESYSTEM_DEPENDENCIES system)
+      set(_Boost_IOSTREAMS_DEPENDENCIES regex)
+      set(_Boost_LOG_DEPENDENCIES date_time log_setup system filesystem thread regex chrono atomic)
+      set(_Boost_MATH_DEPENDENCIES math_c99 math_c99f math_c99l math_tr1 math_tr1f math_tr1l atomic)
+      set(_Boost_MPI_DEPENDENCIES serialization)
+      set(_Boost_MPI_PYTHON_DEPENDENCIES python mpi serialization)
+      set(_Boost_NUMPY_DEPENDENCIES python)
+      set(_Boost_RANDOM_DEPENDENCIES system)
+      set(_Boost_THREAD_DEPENDENCIES chrono system date_time atomic)
+      set(_Boost_WAVE_DEPENDENCIES filesystem system serialization thread chrono date_time atomic)
+      set(_Boost_WSERIALIZATION_DEPENDENCIES serialization)
+    endif()
+    if(NOT Boost_VERSION VERSION_LESS 106600)
+      message(WARNING "New Boost version may have incorrect or missing dependencies and imported targets")
+      set(_Boost_IMPORTED_TARGETS FALSE)
+    endif()
   endif()
 
   string(TOUPPER ${component} uppercomponent)
@@ -815,6 +837,7 @@ function(_Boost_COMPONENT_HEADERS compon
   set(_Boost_MATH_TR1L_HEADERS           "boost/math/tr1.hpp")
   set(_Boost_MPI_HEADERS                 "boost/mpi.hpp")
   set(_Boost_MPI_PYTHON_HEADERS          "boost/mpi/python/config.hpp")
+  set(_Boost_NUMPY_HEADERS               "boost/python/numpy.hpp")
   set(_Boost_PRG_EXEC_MONITOR_HEADERS    "boost/test/prg_exec_monitor.hpp")
   set(_Boost_PROGRAM_OPTIONS_HEADERS     "boost/program_options.hpp")
   set(_Boost_PYTHON_HEADERS              "boost/python.hpp")
@@ -998,6 +1021,7 @@ else()
   # _Boost_COMPONENT_HEADERS.  See the instructions at the top of
   # _Boost_COMPONENT_DEPENDENCIES.
   set(_Boost_KNOWN_VERSIONS ${Boost_ADDITIONAL_VERSIONS}
+    "1.65.1" "1.65.0" "1.65"
     "1.64.0" "1.64" "1.63.0" "1.63" "1.62.0" "1.62" "1.61.0" "1.61" "1.60.0" "1.60"
     "1.59.0" "1.59" "1.58.0" "1.58" "1.57.0" "1.57" "1.56.0" "1.56" "1.55.0" "1.55"
     "1.54.0" "1.54" "1.53.0" "1.53" "1.52.0" "1.52" "1.51.0" "1.51"
