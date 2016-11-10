#!/bin/sh

FILENAME=$1
UUID_CMD=/usr/local/bin/uuid

if [ $# -eq 0 ]; then
  echo "provide vulnerabilities file"
  exit 1;
fi

# I can't make the filtering work in a separate file (???)
# so just keep this as an inline source

FILTER1='!/^($|#|Hash:|-----BEGIN[[:space:]]PGP[[:space:]]SIGNED)/ \
{ if (!blocked) { \
    if ($0 == "-----BEGIN PGP SIGNATURE-----") { \
       blocked = 1; \
    }  \
    else { \
       curly1 = index($3, "{"); \
       if (curly1) { curly2 = index($3, "}") } \
       if (curly1 && curly2) { \
          segment = substr($3, curly1 + 1, curly2 - curly1 - 1); \
          prnum = split (segment, pr, ","); \
          for (j = 1; j <= prnum; j++) { \
             print $1 "|" $2 "|" substr($3, 1, curly1 - 1) pr[j]; \
          } \
       } \
       else { \
          square1 = index($3, "["); \
          if (square1) { square2 = index($3, "]") } \
          if (square1 && square 2) { \
             segment = substr($3, square1 + 1, square2 - square1 - 1); \
             cvenum = split (segment, cve, "-"); \
             for (j = 1; j <= cvenum; j++) { \
                print $1 "|" $2 "|" substr($3, 1, square1 - 1) cve[j]; \
             } \
          } \
          else {
             print $1 "|" $2 "|" $3; \
          } \
       } \
    } \
  } \
}'

awk "${FILTER1}" ${FILENAME} > ${FILENAME}.adjusted
list=$(awk -F'|' '{ print $2 "|" $3 }' ${FILENAME}.adjusted | sort -u)
rm -f ${FILENAME}.uuid
for line in ${list}; do
  echo $(${UUID_CMD} -v 5 ns:URL "${line}")"|${line}" >> ${FILENAME}.uuid
done

echo ___START_DATA___ | awk -f combine.awk ${FILENAME}.uuid - ${FILENAME}.adjusted | \
	sort > ${FILENAME}.combined
