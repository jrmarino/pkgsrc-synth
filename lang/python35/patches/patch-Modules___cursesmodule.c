$NetBSD: patch-Modules___cursesmodule.c,v 1.2 2015/12/07 09:07:43 wiz Exp $

Ncurses will be used by devel/py-curses and devel/py-cursespanel.
http://bugs.python.org/issue21457

--- Modules/_cursesmodule.c.orig	2015-09-13 11:41:24.000000000 +0000
+++ Modules/_cursesmodule.c
@@ -486,17 +486,9 @@ Window_NoArg2TupleReturnFunction(getpary
 
 Window_OneArgNoReturnFunction(clearok, int, "i;True(1) or False(0)")
 Window_OneArgNoReturnFunction(idlok, int, "i;True(1) or False(0)")
-#if defined(__NetBSD__)
-Window_OneArgNoReturnVoidFunction(keypad, int, "i;True(1) or False(0)")
-#else
 Window_OneArgNoReturnFunction(keypad, int, "i;True(1) or False(0)")
-#endif
 Window_OneArgNoReturnFunction(leaveok, int, "i;True(1) or False(0)")
-#if defined(__NetBSD__)
-Window_OneArgNoReturnVoidFunction(nodelay, int, "i;True(1) or False(0)")
-#else
 Window_OneArgNoReturnFunction(nodelay, int, "i;True(1) or False(0)")
-#endif
 Window_OneArgNoReturnFunction(notimeout, int, "i;True(1) or False(0)")
 Window_OneArgNoReturnFunction(scrollok, int, "i;True(1) or False(0)")
 Window_OneArgNoReturnFunction(winsdelln, int, "i;nlines")
@@ -1156,11 +1148,7 @@ PyCursesWindow_GetKey(PyCursesWindowObje
         return Py_BuildValue("C", rtn);
     } else {
         const char *knp;
-#if defined(__NetBSD__)
-        knp = unctrl(rtn);
-#else
         knp = keyname(rtn);
-#endif
         return PyUnicode_FromString((knp == NULL) ? "" : knp);
     }
 }
@@ -2595,7 +2583,6 @@ PyCurses_Is_Term_Resized(PyObject *self,
 }
 #endif /* HAVE_CURSES_IS_TERM_RESIZED */
 
-#if !defined(__NetBSD__)
 static PyObject *
 PyCurses_KeyName(PyObject *self, PyObject *args)
 {
@@ -2614,7 +2601,6 @@ PyCurses_KeyName(PyObject *self, PyObjec
 
     return PyBytes_FromString((knp == NULL) ? "" : knp);
 }
-#endif
 
 static PyObject *
 PyCurses_KillChar(PyObject *self)
@@ -3228,9 +3214,7 @@ static PyMethodDef PyCurses_methods[] = 
 #ifdef HAVE_CURSES_IS_TERM_RESIZED
     {"is_term_resized",     (PyCFunction)PyCurses_Is_Term_Resized, METH_VARARGS},
 #endif
-#if !defined(__NetBSD__)
     {"keyname",             (PyCFunction)PyCurses_KeyName, METH_VARARGS},
-#endif
     {"killchar",            (PyCFunction)PyCurses_KillChar, METH_NOARGS},
     {"longname",            (PyCFunction)PyCurses_longname, METH_NOARGS},
     {"meta",                (PyCFunction)PyCurses_Meta, METH_VARARGS},
@@ -3359,9 +3343,7 @@ PyInit__curses(void)
     SetDictInt("A_DIM",                 A_DIM);
     SetDictInt("A_BOLD",                A_BOLD);
     SetDictInt("A_ALTCHARSET",          A_ALTCHARSET);
-#if !defined(__NetBSD__)
     SetDictInt("A_INVIS",           A_INVIS);
-#endif
     SetDictInt("A_PROTECT",         A_PROTECT);
     SetDictInt("A_CHARTEXT",        A_CHARTEXT);
     SetDictInt("A_COLOR",           A_COLOR);
@@ -3433,7 +3415,6 @@ PyInit__curses(void)
         int key;
         char *key_n;
         char *key_n2;
-#if !defined(__NetBSD__)
         for (key=KEY_MIN;key < KEY_MAX; key++) {
             key_n = (char *)keyname(key);
             if (key_n == NULL || strcmp(key_n,"UNKNOWN KEY")==0)
@@ -3461,7 +3442,6 @@ PyInit__curses(void)
             if (key_n2 != key_n)
                 PyMem_Free(key_n2);
         }
-#endif
         SetDictInt("KEY_MIN", KEY_MIN);
         SetDictInt("KEY_MAX", KEY_MAX);
     }
