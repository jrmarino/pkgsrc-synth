# The following variables are expected to be defined via the command
# line.  If they are present, output the definitions so they can
# be concatenated to the head.
#

BEGIN {
  prog[ 1] = "AWK"                ; cmd[ 1] = AWK;
  prog[ 2] = "BASENAME"           ; cmd[ 2] = BASENAME;
  prog[ 3] = "CAT"                ; cmd[ 3] = CAT;
  prog[ 4] = "CHGRP"              ; cmd[ 4] = CHGRP;
  prog[ 5] = "CHMOD"              ; cmd[ 5] = CHMOD;
  prog[ 6] = "CHOWN"              ; cmd[ 6] = CHOWN; 
  prog[ 7] = "CMP"                ; cmd[ 7] = CMP;
  prog[ 8] = "CP"                 ; cmd[ 8] = CP;
  prog[ 9] = "DIRNAME"            ; cmd[ 9] = DIRNAME;
  prog[10] = "ECHO"               ; cmd[10] = ECHO;
  prog[11] = "ECHO_N"             ; cmd[11] = ECHO_N;
  prog[12] = "EGREP"              ; cmd[12] = EGREP;
  prog[13] = "EXPR"               ; cmd[13] = EXPR;
  prog[14] = "FALSE"              ; cmd[14] = FALSE;
  prog[15] = "FIND"               ; cmd[15] = FIND;
  prog[16] = "GREP"               ; cmd[16] = GREP;
  prog[17] = "HEAD"               ; cmd[17] = HEAD;
  prog[18] = "ID"                 ; cmd[18] = ID;
  #  prog[19] = ""                ; cmd[19] = ;
  prog[20] = "LN"                 ; cmd[20] = LN;
  prog[21] = "LS"                 ; cmd[21] = LS;
  prog[22] = "MKDIR"              ; cmd[22] = MKDIR;
  prog[23] = "MV"                 ; cmd[23] = MV;
  prog[24] = "PERL5"              ; cmd[24] = PERL5;
  prog[25] = "PKG_ADMIN"          ; cmd[25] = PKG_ADMIN;
  prog[26] = "PKG_INFO"           ; cmd[26] = PKG_INFO;
  prog[27] = "PW"                 ; cmd[27] = PW;
  prog[28] = "PWD_CMD"            ; cmd[28] = PWD_CMD;
  prog[29] = "RM"                 ; cmd[29] = RM;
  prog[30] = "RMDIR"              ; cmd[30] = RMDIR;
  prog[31] = "SED"                ; cmd[31] = SED;
  prog[32] = "SETENV"             ; cmd[32] = SETENV;
  prog[33] = "SH"                 ; cmd[33] = SH;
  prog[34] = "SORT"               ; cmd[34] = SORT;
  prog[35] = "SU"                 ; cmd[35] = SU;
  prog[36] = "TEST"               ; cmd[36] = TEST;
  prog[37] = "TOUCH"              ; cmd[37] = TOUCH;
  prog[38] = "TR"                 ; cmd[38] = TR;
  prog[39] = "TRUE"               ; cmd[39] = TRUE;
  prog[40] = "XARGS"              ; cmd[40] = XARGS;
  prog[41] = "PKGBASE"            ; cmd[41] = PKGBASE;
  prog[42] = "LOCALBASE"          ; cmd[42] = LOCALBASE;
  prog[43] = "X11BASE"            ; cmd[43] = X11BASE;
  prog[44] = "VARBASE"            ; cmd[44] = VARBASE;
  prog[45] = "PREFIX"             ; cmd[45] = PREFIX;
  prog[46] = "PKG_SYSCONFBASE"    ; cmd[46] = PKG_SYSCONFBASE;
  prog[47] = "PKG_SYSCONFBASEDIR" ; cmd[47] = PKG_SYSCONFBASEDIR;
  prog[48] = "PKG_SYSCONFDIR"     ; cmd[48] = PKG_SYSCONFDIR;
  
  for (k in prog) used[k] = 0;
  
  replace_mode = (MODE == "replace") ? 1 : 0;
}

END {
   if (!replace_mode) {
      for (k in prog) {
         if (used[k]) { print prog[k] "=\"" cmd[k] "\"" }
      }
      print ""
   }
}

# main
{
   if (replace_mode) {
      myline = $0;
      for (k in prog) {
         len = length (prog[k]) + 2;
         do {
            ndx = index (myline, "@" prog[k] "@");
            if (ndx > 0) {
               myline = substr(myline, 1, ndx - 1) cmd[k] substr(myline, ndx + len);
            }
         }
         while (ndx > 0);
      }
      print myline;
   } else {
      for (k in prog) {
         if (!used[k]) {
            if ((index ($0, "${" prog[k] "}") > 0) || 
                (index ($0, "$(" prog[k] ")") > 0)) {
               used[k] = 1;
            }
         }
      }
   }
}
