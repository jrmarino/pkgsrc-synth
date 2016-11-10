BEGIN {
  FS="|";
  datanow=0;
}

function min_version (raw) {
  # look for x in "[x-z]" patterns and "[xyz]" patterns (x, y and z are digits)
   pattern = "[[][0-9]+(-[0-9]+)?[]]";
   mycopy = raw;
   while (match (mycopy, pattern)) {
      segment = substr(mycopy, RSTART, RLENGTH);
      lowver = substr (segment, 2, 1);
      mycopy = substr (mycopy, 1, RSTART - 1) lowver substr (mycopy, RSTART + RLENGTH);
  }
  
  # Return if there are no more brackets
  if (index (mycopy, "[") == 0) { return mycopy }

  # Look for "a" in "[a-z]" and "[abcd]" patterns (a,b,c, and d are letters)
  # This is case insensitive
  pattern = "[[][[:alpha:]]+(-[[:alpha:]]+)?[]]";
  copy2 = mycopy;
  while (match (copy2, pattern)) {
      segment = substr(copy2, RSTART, RLENGTH);
      lowver = substr (segment, 2, 1);
      copy2 = substr (copy2, 1, RSTART - 1) lowver substr (copy2, RSTART + RLENGTH);
  }
  return copy2;
}

function max_version (raw) {
  # look for z in "[x-z]" and "[xyz] patterns (x, y and z are digits)
   pattern = "[[][0-9]+(-[0-9]+)?[]]";
   mycopy = raw;
   while (match (mycopy, pattern)) {
      segment = substr(mycopy, RSTART, RLENGTH);
      hiver = substr (segment, length(segment) - 1, 1);
      mycopy = substr (mycopy, 1, RSTART - 1) hiver substr (mycopy, RSTART + RLENGTH);
   }
   # Return if there are no more brackets
   if (index (mycopy, "[") == 0) { return mycopy }

   # Look for "z" in "[a-z]" and "[abcz]" pattens (a,b,c, and z are letters)
   # This is case insensitive
   pattern = "[[][[:alpha:]]+(-[[:alpha:]]+)?[]]";
   copy2 = mycopy;
   while (match (copy2, pattern)) {
      segment = substr(copy2, RSTART, RLENGTH);
      hiver = substr (segment, length(segment) - 1, 1);
      copy2 = substr (copy2, 1, RSTART - 1) hiver substr (copy2, RSTART + RLENGTH);
   }
   return copy2;
}

function package_name (raw) {
   # wget-1.9{,nb*} => wget>=1.9<=nb99
   # wget-1.9{nb*,} is equivalent 
   
   nbfix = 0;
   rawlen = length(raw);
   startfrom = rawlen - 5;
   lastsix = substr (raw, startfrom, 6);
   if (lastsix == "{,nb*}" || lastsix == "{nb*,}") {
      nbfix = 1;
   } else if (substr (raw, rawlen - 2, 3) == "nb*") {
      nbfix = 1;
      startfrom = rawlen - 2;
   } else if (substr (raw, rawlen - 6, 7) == "{,nb*}*") {
      nbfix = 1;
      startfrom = rawlen - 6;
   } else if (substr (raw, rawlen, 1) == "*") {
      nbfix = 1;
      startfrom = rawlen;
   } else if (substr (raw, rawlen - 10, 11) == "{,nb[0-9]*}") {
      nbfix = 1;
      startfrom = rawlen - 10;
   }
   block_left = 0;
   block_right = 0;
   block_open = 0;
   curly_left = 0;
   curly_right = 0;
   curly_open = 0;
   star = 0;
   compops = 0;
   found = 0;
   if (nbfix) {
      # obtain pkgversion, check for [ * ] at the same time
      for (x = startfrom - 1; x >= 1; x--) {
         alphanum = substr (raw, x, 1);
              if (alphanum == "[") { block_left  = 1; block_open = 0 }
         else if (alphanum == "]") { block_right = 1; block_open = 1 }
         else if (alphanum == "{") { curly_left = 1; break }
         else if (alphanum == "}") { curly_right = 1; break }
         else if (alphanum == "*") { star = 1; break }
         else if (alphanum == "-" && !block_open) {
            found = x;
            pkgversion = substr (raw, x + 1, startfrom - x - 1);
            break;
         }
      }
      if (found) {
        if (!block_left && !block_right && !star) {
           return substr(raw, 1, found - 1) ">=" pkgversion "<=" pkgversion "nb99";
        }
        if (!star) {
           mv = min_version(pkgversion);
           if (mv == "0") {
              return substr(raw, 1, found - 1) "<=" max_version(pkgversion) "nb99";
           } else {
              return substr(raw, 1, found - 1) ">=" mv "<=" max_version(pkgversion) "nb99";
           }
        }
      }
   }
   # apache-2.0.3[5-9]
   # apache-2.0.2?
   testmark = index (raw, "?");
   if (testmark > 0) {
      raw2 = substr (raw, 1, testmark - 1) "[0-9]" substr (raw, testmark + 1);
      rawlen = length (raw2);
   } else {
      # apache-2.0.54{,nb[1234]}
      testmark = index (raw, "{,nb[");
      if (testmark > 0) {
         base = substr (raw, 1, testmark - 1);
         rest = substr (raw, testmark);
         nextbrack = index (rest, "]}");
         midbrack = substr (rest, 5, nextbrack - 4);
         tail = substr (rest, nextbrack + 2);
              if (midbrack == "[12]")     {raw2 = base "{,nb1,nb2}" tail}
         else if (midbrack == "[123]")    {raw2 = base "{,nb1,nb2,nb3}" tail }
         else if (midbrack == "[1234]")   {raw2 = base "{,nb1,nb2,nb3,nb4}" tail }
         else if (midbrack == "[1-4]")    {raw2 = base "{,nb1,nb2,nb3,nb4}" tail }
         else if (midbrack == "[123456]") {raw2 = base "{,nb1,nb2,nb3,nb4,nb5,nb6}" tail }
         else {raw2 = raw }
         rawlen = length (raw2);
      } else {
         raw2 = raw;
      }
   }
   for (x = rawlen; x >= 1; x--) {
      alphanum = substr (raw2, x, 1);
           if (alphanum == "[") { block_left  = 1; block_open = 0 }
      else if (alphanum == "]") { block_right = 1; block_open = 1; if (curly_open) {break}}
      else if (alphanum == "{") { curly_left  = 1; curly_open = 0;}
      else if (alphanum == "}") { curly_right = 1; curly_open = 1}
      else if (alphanum == "*") { star = 1; break }
      else if (alphanum == "<") { compops = 1; break }
      else if (alphanum == ">") { compops = 1; break }
      else if (alphanum == "=") { compops = 1; break }
      else if (alphanum == "-" && !block_open) {
         found = x;
         pkgversion = substr (raw2, x + 1, rawlen - x);
         break;
      }
   }
   if (found && block_left && block_right && !star) {
      mv = min_version(pkgversion);
      if (mv == "0") {
         return substr(raw2, 1, found - 1) "<=" max_version(pkgversion);
      } else {
         return substr(raw2, 1, found - 1) ">=" mv "<=" max_version(pkgversion);
      }
   }
   # apache-2.0.51
   # sun-{jdk,jre}15<5.0.6
   if (found && !block_left && !block_right && !star && !compops) {
      return substr (raw2, 1, found - 1) "=" pkgversion;
   }

   # manually fix a few braindead entries that coding isn't worth to address
   if (raw == "mysql-server-4.1.{0,1,2,3,4,5,6,7,8,9,10,11,12}{,nb*}") {
      return "mysql-server>=4.1.0<=4.1.12nb99";
   }
   if (raw == "mysql-server-4.1.{[0-9],10,11}{,nb*}") {
      return "mysql-server>=4.1.0<=4.1.11nb99";
   }
   if (raw == "perl{,-thread}-5.8.{[0-4]{,nb*},5{,nb[1-7]},6{,nb[12]}}") {
      return "perl{,-thread}>=5.8.0<=5.8.6nb2";
   }
   if (raw == "kdeedu-3.4.{0*,1,2}")       { return "kdeedu>=3.4.0<=3.4.2" }
   if (raw == "kdenetwork-3.4.{0,0nb*,1}") { return "kdenetwork>=3.4.0<=3.4.1" }
   if (raw == "samba-3.0.[0-4]{,a*,nb?}")  { return "samba>=3.0.0<=3.0.4nb99" }

   # Return back what we got
   return raw;
}

# main
{
   if (datanow) {
      print uuid [ $2 "|" $3 ] "|" package_name($1) "|" $2 "|" $3;
   }
   else if ($0 == "___START_DATA___") {
      datanow = 1;
   } else {
      uuid [ $2 "|" $3 ] = $1 
   }
}
