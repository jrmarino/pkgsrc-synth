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
#  PREFIX= installation prefix
#  
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
}

function dump_CF (k) {
   if (CONF_FILES_MODE == "")
      print "@sample " CF[2*k+1] " " CF[2*k+2];
   else
      print "@sample(,," CONF_FILES_MODE ") " CF[2*k+1] " " CF[2*k+2];
   used_CF[k] = 1;
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

END {
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
}

function is_sample () {
    if (substr($1, 1, 1) == "/") { candidate = $1  }
    else                         { candidate = PREFIX "/" $1 }

    for (k = 0; k < num_CF; k++) {
       if (!used_CF[k]) {
          if (candidate == CF[2*k+1]) {
             dump_CF(k);
             return 1;
          }
       }
    }
    for (k = 0; k < num_RF; k++) {
       if (!used_RF[k]) {
          if (candidate == RF[2*k+1]) {
             dump_RF;
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

function is_info() {
   if ((length($1) > 9) && (substr ($1, 1, 5) == "info/")) {
       print "@info " PREFIX "/" $1;
       return 1;
   }
   return 0;  
}

# MAIN
{
    if ($1 == "@pkgdir") {
       print "@dir " $2;
    } else if (is_sample()) {
       # handled in function
    } else if (is_info()){
       # handled in function
    } else {
        print $0
    }
}
