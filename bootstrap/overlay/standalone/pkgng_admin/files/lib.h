#ifndef _FUNCTIONALITY_
#define _FUNCTIONALITY_

#include <sys/cdefs.h>
#include <sys/syslimits.h>

/* hardcode to 32-bits, it's enough for warnx */
#define PRIzu "lu"

/* match pkg_admin version at time of creation */
#define PKGTOOLS_VERSION 20160410

enum {
	MaxPathSize = PATH_MAX
};

/* License handling */
int add_licenses(const char *);
int acceptable_license(const char *);
int acceptable_pkg_license(const char *);
void load_license_lists(void);

/* Externs */
extern const char *acceptable_licenses;
extern const char *default_acceptable_licenses;
extern const char *config_file;

/* String */
int     pkg_match(const char *, const char *);
int	pkg_order(const char *, const char *, const char *);
int     ispkgpattern(const char *);
int	quick_pkg_match(const char *, const char *);

/* helpers */

char *xasprintf(const char *, ...);

/* Parse configuration file */
void pkg_install_config(void);
/* Print configuration variable */
void pkg_install_show_variable(const char *);

#endif				/* _FUNCTIONALITY_ */
