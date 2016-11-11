#
#  external variables:
#  -------------------
#  CONF_FILES= space delimited list of sample files (2 per)
#  CONF_FILES_PERMS= similar with perms (5 per), include REQD_FILES_PERMS
#  CONF_FILES_MODE= set mode for all CONF_FILES
#  REQD_FILES= handle like CONF_FILES
#  REQD_FILES_MODE= set mode of all REQD_FILES
#  RCD_SCRIPTS= special case of sample (1 per)
#  RCD_SCRIPTS_MODE= set mode of all RCD_SCRIPTS
#  RCD_SCRIPTS_DIR= directory to install RC scripts
#  RCD_SCRIPTS_EXAMPLEDIR = default examples directory for rc scripts
#  PKG_SHELL= single entry for @shell keyword
#  SPECIAL_PERMS= space delimited list of perms per file
#  OCAML_FINDLIB_DIRS= space delimited list of ocaml directories to register
#  X11_TYPE= either "native" or "modular"
#  FONTSDIR_X11= list of x11 font directories
#  FONTSDIR_TTF= list of ttf font directories
#  FONTSDIR_TYPE1= list of type1 font directories
#  PKG_SYSCONFDIR= check for this directory for CONF_FILES insertions
#  PREFIX= installation prefix
#

BEGIN {
    split (CONF_FILES, CF);
    num_CF = length(CF) / 2;
    for (k = 0; k < num_CF; k++) used_CF[k] = 0;

    split (REQD_FILES, RF);
    num_RF = length(RF) / 2;
    for (k = 0; k < num_RF; k++) used_RF[k] = 0;

    split (CONF_FILES_PERMS, CFP);
    num_CFP = length(CFP) / 5;
    for (k = 0; k < num_CFP; k++) used_CFP[k] = 0;

    split (RCD_SCRIPTS, RCD);
    num_RCD = length(RCD);
    for (k = 0; k < num_RCD; k++) used_RCD[k] = 0;

    split (PKG_SHELL, SHELL);
    num_SHELL = length (SHELL);
    for (k = 0; k < num_SHELL; k++) used_SHELL[k] = 0;

    split (SPECIAL_PERMS, SP);
    num_SP = length(SP) / 4;
    for (k = 0; k < num_SP; k++) used_SP[k] = 0;

    split (OCAML_FINDLIB_DIRS, OFL);
    num_OFL = length(OFL) / 4;
    for (k = 0; k < num_OFL; k++) used_OFL[k] = 0;

    split (FONTSDIR_X11, FX11);
    num_FX11 = length (FX11);
    for (k = 0; k < num_FX11; k++) used_FX11[k] = 0;

    split (FONTSDIR_TTF, FTTF);
    num_FTTF = length (FTTF);
    for (k = 0; k < num_FTTF; k++) {
       used_FTTF[k] = 0;
       # Eliminate duplicates in X11 type
       for (j = 0; j < num_FX11; j++) {
          if (FTTF[k+1] == FX11[j+1]) {
             used_FX11[j] = 1;
          }
       }
    }

    split (FONTSDIR_TYPE1, FTY1);
    num_FTY1 = length (FTY1);
    for (k = 0; k < num_FTY1; k++) {
       used_FTY1[k] = 0;
       # Eliminate duplicates in X11 type
       for (j = 0; j < num_FX11; j++) {
          if (FTY1[k+1] == FX11[j+1]) {
             used_FX11[j] = 1;
          }
       }
    }

    set_ldconfig = (LDCONFIG == "yes") ? 1 : 0;
    fontdir_type = (X11_TYPE == "modular") ? "modular_x11" : "native_x11";
    needs_sysconfdir = 0;
    has_sysconfdir   = 0;
}

function dump_CF (k) {
   if (CONF_FILES_MODE == "")
      print "@sample " CF[2*k+1] " " CF[2*k+2];
   else
      print "@sample(,," CONF_FILES_MODE ") " CF[2*k+1] " " CF[2*k+2];
   used_CF[k] = 1;
   if (index(CF[2*k+2], PKG_SYSCONFDIR) == 1) {
      needs_sysconfdir = 1;
   }
}

function dump_RF (k) {
   if (REQD_FILES_MODE == "")
      print "@sample " RF[2*k+1] " " RF[2*k+2];
   else
      print "@sample(,," REQD_FILES_MODE ") " RF[2*k+1] " " RF[2*k+2];
   used_RF[k] = 1;
}

function dump_CFP (k) {
   print "@sample(" CFP[5*k+3] "," CFP[5*k+4] "," CFP[5*k+5] ") " CFP[5*k+1] " " CFP[5*k+2];
   used_CFP[k] = 1;
}

function dump_RCD (k) {
   print "@sample(,," RCD_SCRIPTS_MODE ") " PREFIX "/" RCD_SCRIPTS_EXAMPLEDIR "/" RCD[k+1] " "  RCD_SCRIPTS_DIR "/" RCD[k+1];
   used_RCD[k] = 1;
}

function dump_SHELL (k) {
   print "@shell " SHELL[k+1];
   used_SHELL[k] = 1;
}

function dump_SP (k) {
   print "@(" SP[4*k+2] "," SP[4*k+3] "," SP[4*k+4] ") " SP[4*k+1];
   used_SP[k] = 1;
}

function dump_OFL (k) {
   print "@ocaml-register " OFL[k+1];
   used_OFL[k] = 1;
}

function dump_FX11 (k) {
   print "@fontsdir " fontdir_type " x11   " FX11[k+1];
   used_FX11[k] = 1;
}

function dump_FTTF (k) {
   print "@fontsdir " fontdir_type " ttf   " FTTF[k+1];
   used_FTTF[k] = 1;
}


function dump_FTY1 (k) {
   print "@fontsdir " fontdir_type " type1 " FTY1[k+1];
   used_FY1[k] = 1;
}

END {
   # Any output is produced in this section is indicative of a bad plist
   for (k = 0; k < num_CF; k++) {
      if (!used_CF[k]) { dump_CF(k) }
   }
   for (k = 0; k < num_RF; k++) {
      if (!used_RF[k]) { dump_RF(k) }
   }
   for (k = 0; k < num_CFP; k++) {
      if (!used_CFP[k]) { dump_CFP(k) }
   }
   for (k = 0; k < num_RCD; k++) {
      if (!used_RCD[k]) { dump_RCD(k) }
   }
   for (k = 0; k < num_SHELL; k++) {
      if (!used_SHELL[k]) { dump_SHELL(k) }
   }
   for (k = 0; k < num_SP; k++) {
      if (!used_SP[k]) { dump_SP(k) }
   }
   for (k = 0; k < num_OFL; k++) {
      if (!used_OFL[k]) { dump_OFL(k) }
   }
   for (k = 0; k < num_FTTF; k++) {
      if (!used_FTTF[k]) { dump_FTTF(k) }
   }
   for (k = 0; k < num_FTY1; k++) {
      if (!used_FTY1[k]) { dump_FTY1(k) }
   }
   for (k = 0; k < num_FX11; k++) {
      if (!used_FX11[k]) { dump_FX11(k) }
   }

   # ensure PKG_SYSCONFDIR exists if it's used
   if (needs_sysconfdir && !has_sysconfdir) {
      print "@dir " PKG_SYSCONFDIR;
   }

   # Output from here forward doesn't mean a bad plist
   if (set_ldconfig) { print "@ldconfig" }
}

function is_sample () {
    if (substr($1, 1, 1) == "/") { candidate = $1  }
    else                         { candidate = PREFIX "/" $1 }

    for (k = 0; k < num_CF; k++) {
       if (!used_CF[k]) {
          if (candidate == CF[2*k+1] || $1 == CF[2*k+1]) {
             dump_CF(k);
             return 1;
          }
       }
    }
    for (k = 0; k < num_RF; k++) {
       if (!used_RF[k]) {
          if (candidate == RF[2*k+1]) {
             dump_RF(k);
             return 1;
          }
       }
    }
    for (k = 0; k < num_CFP; k++) {
       if (!used_CFP[k]) {
          if (candidate == CFP[5*k+1]) {
             dump_CFP(k);
             return 1;
          }
       }
    }
    for (k = 0; k < num_RCD; k++) {
       if (!used_RCD[k]) {
          if ($1 == RCD_SCRIPTS_EXAMPLEDIR "/" RCD[k+1]) {
             dump_RCD(k);
             return 1;             
          }
       }
    }
    return 0;  
}

function is_info () {
   if ((length($1) > 9) && (substr ($1, 1, 5) == "info/")) {
       print "@info " PREFIX "/" $1;
       return 1;
   }
   return 0;  
}

function is_shell () {
    for (k = 0; k < num_SHELL; k++) {
       if (!used_SHELL[k]) {
          if ($1 == SHELL[k+1]) {
             dump_SHELL(k);
             return 1;
          }
       }
   }
   return 0;
}

function is_special_perms () {
    for (k = 0; k < num_SP; k++) {
       if (!used_SP[k]) {
          if ($1 == SP[k+1]) {
             dump_SP(k);
             return 1;
          }
       }
   }
   return 0;
}

# MAIN
{
    if ($1 == "@pkgdir") {
       print "@dir " $2;
       if ($2 == PKG_SYSCONFDIR) { has_sysconfdir=1 }
    } else if (is_sample()) {
       # handled in function
    } else if (is_info()) {
       # handled in function
    } else if (is_shell()) {
       # handled in function
    } else if (is_special_perms()) {
       # handled in function
    } else {
        print $0
    }
}
