BEGIN {
   FS = "|";
   last_vid = "__initial__";
   topic = ""
   num_refs = 0;
   num_pkgs = 0;
   virgin = 1;

   print "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
   print "<!DOCTYPE vuxml PUBLIC \"-//vuxml.org//DTD VuXML 1.1//EN\" \"http://www.vuxml.org/dtd/vuxml-1/vuxml-11.dtd\">";
   print "<vuxml xmlns=\"http://www.vuxml.org/apps/vuxml-1\">";
}

function write_package (package) {
   workstr = "";
   pkg_name = "__uninitialized__";
   name_set = 0;
   len = length (package);
   
   for (x = 1; x <= len; x++) {
      alphanum = substr(package, x, 1);
      if (alphanum == ">" || alphanum == "<" || alphanum == "=") {
         pkg_name = substr (package, 1, x - 1);
         workstr = substr (package, x);
         name_set = 1;
         break;
      }
   }

   print "      <package>";
   if (name_set) {
   print "       <name>" pkg_name "</name>";
   } else {
   print "       <name>###### " package " ######</name>";
   }

   len = length (workstr);
   if (len < 2) { return }
   duo = substr (workstr, 1, 2);
   uno = substr (workstr, 1, 1);
   
   print "       <range>";
        if (duo == ">=") { typ1 = 5; workstr = substr (workstr, 3); }
   else if (duo == "=>") { typ1 = 5; workstr = substr (workstr, 3); }
   else if (uno == ">")  { typ1 = 4; workstr = substr (workstr, 2); }
   else if (duo == "<=") { typ1 = 3; workstr = substr (workstr, 3); }
   else if (duo == "=<") { typ1 = 3; workstr = substr (workstr, 3); }
   else if (uno == "<")  { typ1 = 2; workstr = substr (workstr, 2); }
   else                  { typ1 = 1; workstr = substr (workstr, 2); }

   typ2 = 0;
   range1 = workstr;
   len = length (workstr);
   if ((len >= 2) && (typ1 >= 4)) {
      chk = index (workstr, "<=");
      if (chk > 0) {
         typ2 = 3;
         range1 = substr (workstr, 1, chk - 1);
         range2 = substr (workstr, chk + 2);
      } else {
         chk = index (workstr, "=<");
         if (chk > 0) {
            typ2 = 3;
            range1 = substr (workstr, 1, chk - 1);
            range2 = substr (workstr, chk + 2);   
         } else {
            chk = index (workstr, "<");         
            if (chk > 0) {
               typ2 = 2;
               range1 = substr (workstr, 1, chk - 1);
               range2 = substr (workstr, chk + 1);
            }
         }
      }
   }
   if (range1 == "") { range1 = "0" }
        if (typ1 == 1) { print "       <eq>" range1 "</eq>" }
   else if (typ1 == 2) { print "       <lt>" range1 "</lt>" }
   else if (typ1 == 3) { print "       <le>" range1 "</le>" }
   else if (typ1 == 4) { print "       <gt>" range1 "</gt>" }
   else if (typ1 == 5) { print "       <ge>" range1 "</ge>" }
  
   if (range2 == "") { range2 = "0" }
        if (typ2 == 2) { print "       <lt>" range2 "</lt>" }
   else if (typ2 == 3) { print "       <le>" range2 "</le>" }
   print "       </range>";
   print "      </package>";
}

function write_reference (reference) {
   # FreeBSD Security advisories e.g. <freebsdsa>SA-10:75.foo</freebsdsa>
   if (index (reference, "www.freebsd.org/security/advisories") > 0) {
      ref = substr (reference, index (reference, "SA-"));
      print "      <freebsdsa>" ref "</freebsdsa>"
      return;
   }
   # Mitre security advisories, e.g. <cvename>CAN-2010-0201</cvename>
   if (index (reference, "cve.mitre.org/cgi-bin/cvename.cgi") > 0) {
      ref = substr (reference, index (reference, "name=") + 5);
      print "      <cvename>" ref "</cvename>"
      return;
   }
   # SecurityFocus Bug ID, e.g. <bid>96298</bid>
   if (index (reference, "/www.securityfocus.com/archive") > 0) {
      ref = substr (reference, index (reference, "/1/") + 3);
      print "      <bid>" ref "</bid>"
      return;
   }
   # US-CERT Security advisory    <certsa>CA-2010-99</certsa> (only one used)
   # US-CERT Vulnerability note   <certvu>740169</certvu>
   # US-CERT Cyber Security Alert <uscertsa>SA10-99A</uscertsa>
   # US-CERT Tech Cyber Sec Alert <uscertta>SA10-99A</uscertta>
   if (index (reference, "www.cert.org/advisories") > 0) {
      ref = substr (reference, index (reference, "/advisories/") + 13);
      refnohtml = substr (ref, 1, length (ref) - 5);
      print "      <certsa>" ref "</certsa>"
      return;
   }
   # generic catch-all
   # we must change all "&" to "&amp;" for xml validation
   fixed_ref = reference;
   gsub (/&/, "&amp;", fixed_ref); 
   print "      <url>" fixed_ref "</url>"
}

function write_entry () {
     if (virgin) { virgin = 0 }
     else        { print "" }

     print "  <vuln vid=\"" last_vid "\">";
     print "    <topic>" topic "</topic>";
     print "    <affects>";
     for (Q in packages) { write_package(packages[Q]) }
     print "    </affects>";
     print "    <description>";
     print "      <body xmlns=\"http://www.w3.org/1999/xhtml\"><p>Summary not available.</p></body>";
     print "    </description>";
     print "    <references>";
     for (Q in references) { write_reference(references[Q]) }
     print "    </references>";
     print "    <dates>";
     print "      <discovery>1969-07-20</discovery>";
     print "      <entry>1980-01-01</entry>";
     print "    </dates>";
     print "  </vuln>";
}

function insert_reference (ref) {
   # Ensure references are unique
   found = 0;
   for (k = 1; k <= num_refs; k++) {
      if (references [k] == ref) {
         found = 1;
         break;
      }
   }
   if (!found) {
      num_refs++;
      references [num_refs] = ref;
   }
}

function insert_package (pkg) {
   # Ensure packages are unique
   found = 0;
   for (k = 1; k <= num_pkgs; k++) {
      if (packages [k] == pkg) {
         found = 1;
         break;
      }
   }
   if (!found) {
      num_pkgs++;
      packages [num_pkgs] = pkg;
   }
}

END {
   # Flush the final entry
   if (last_vid != "__initial__") { write_entry(); }
   print "</vuxml>";
}

# must be recursive-capability because package names can have more than
# curly bracket substitution group

function expand_and_insert_pkgname (rawname, level) {
     curly1 = index (rawname, "{");
     curly2 = index (rawname, "}");
     pkghead[level] = substr (rawname, 1, curly1 - 1);
     pkgtail[level] = substr (rawname, curly2 + 1);
     segment[level] = substr (rawname, curly1 + 1, curly2 - curly1 - 1);
     delete pkgbody[level];
     n[level] = split (segment[level], hold_data, ",");
     for (k = 1; k <= n[level]; k++) {
        pkgbody[level, k] = hold_data [k];
     }
     for (z[level] = 1; z[level] <= n[level]; z[level]++) {
        newname = pkghead[level] pkgbody[level, z[level]] pkgtail[level];
        curly1 = index (newname, "{");
        curly2 = index (newname, "}");
        if ((curly1 == 0) || (curly2 == 0)) {
           insert_package(newname);
        } else {
           expand_and_insert_pkgname(newname, level + 1);
        }
     }
}

#main
{
   if (($1 != last_vid) && (last_vid != "__initial__")) {
      write_entry();
      delete references;
      delete packages;
      num_refs = 0;
      num_pkgs = 0;
   }
   last_vid = $1;
   topic = $3;

   insert_reference($4);

   # Break apart multiple packages to separate entries
   # and also ensure they are unique for this vid
   curly1 = index ($2, "{");
   curly2 = index ($2, "}");
   if ((curly1 == 0) || (curly2 == 0)) {
      insert_package($2);
   } else {
     expand_and_insert_pkgname($2, 1);
   }
}
