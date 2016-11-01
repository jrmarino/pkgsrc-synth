#
#  external variables:
#  -------------------
#  CONF_FILES= space delimited list of sample files (2 per)
#  CONF_FILES_PERMS= similar with perms (5 per)
#  PREFIX= installation prefix
#  
#

BEGIN {
    split (CONF_FILES, CF);
    num_CF = length(CF) / 2;
    for (k = 1; k <= num_CF; k++) used_CF[k] = 0;

    split (CONF_FILES_PERMS, CFP);
    num_CFP = length(CFP) / 5;
    for (k = 1; k <= num_CFP; k++) used_CFP[k] = 0;
}

END {
    for (k = 1; k <= num_CF; k++) {
       if (!used_CF[k]) {
          print "sample@ " CF[k*2-1] " " CF[k*2];
       }
    }
    for (k = 0; k < num_CFP; k++) {
       if (!used_CFP[k]) {
          print "@sample(" CFP[5*k+3] "," CFP[5*k+4] "," CFP[5*k+5] ") " CFP[5*k+1] " " CFP[5*k+2];
       }
    }
}

function is_sample () {
    candidate = PREFIX "/" $1
    for (k = 1; k <= num_CF; k++) {
       if (!used_CF[k]) {
          if (candidate == CF[k*2-1]) {
             used_CF[k] = 1;
             print "@sample " CF[k*2-1] " " CF[k*2];
             return 1;
          }
       }
    }
    for (k = 0; k < num_CFP; k++) {
       if (!used_CFP[k]) {
          if (candidate == CFP[5*k+1]) {
             used_CFP[k] = 1;
             print "@sample(" CFP[5*k+3] "," CFP[5*k+4] "," CFP[5*k+5] ") " CFP[5*k+1] " " CFP[5*k+2];
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
