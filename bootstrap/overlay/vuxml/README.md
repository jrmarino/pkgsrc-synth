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

