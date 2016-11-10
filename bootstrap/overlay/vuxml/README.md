# VUXML GENERATOR

pkg(8) uses vuXML to audit packages.  The format contains a lot more
information than is provided by the NetBSD vulnerabilities file.

These utilities make a best effort at converting the NetBSD format to
the vuXML format.  Besides a lot of missing useful information such
as the vulnerability summary, discovery and entry dates, the NetBSD
format is inconsistent with the indication of package versions affected.
The range format are directly convertable, but NetBSD makes heavy use
of regex leaving ambiguity on affected versions and nb* subversions.
In a handful of cases, the regex was so rare it had to be corrected
manually.


## Method to generate vuxml

1. Install ossp-uuid to obtain uuid(1) for SHA1 hash-based UUIDs
1. Change to this directory
1. Download NetBSD vulnerabilities
from https://ftp.netbsd.org/pub/NetBSD/packages/vulns/pkg-vulnerabilities 
1. Run "./calculate_uuid-2.sh pkg-vulnerabilities". This results in
some generated files including pkg-vulnerabilities.combined
1. Run "awk -f genvuxml.awk pkg-vulnerabilities.combined > vuln.xml"

The resulting vuln.xml file can be validated on FreeBSD at
/usr/ports/security/vuxml by replacing the vuln.xml file there after
installing the port.
