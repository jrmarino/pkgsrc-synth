#include <nbcompat.h>
#include "lib.h"
#include <strings.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <err.h>

static const char Options[] = "C:V";

void 
usage(void) {
	(void) fprintf(stderr, "usage: %s [-V] [-C config] command [args ...]\n"
	    "Where 'commands' and 'args' are:\n"
	    " pmatch pattern pkg              - returns true if pkg matches pattern\n"
	    " check-license <condition>       - check if condition is acceptable\n"
	    " check-single-license <license>  - check if license is acceptable\n"
	    " config-var name                 - print current value of the configuration variable\n",
	    getprogname());
	exit(EXIT_FAILURE);
}

void
show_version(void)
{
	printf("%d\n", PKGTOOLS_VERSION);
	exit (0);
}

int 
main(int argc, char *argv[])
{
	int ch;

        setprogname(argv[0]);

	if (argc < 2)
		usage();

	while ((ch = getopt(argc, argv, Options)) != -1)
		switch (ch) {
		case 'C':
			config_file = optarg;
			break;
                case 'V':
			show_version();
			/* NOTREACHED */
		default:
			usage();
			/* NOTREACHED */
		}

	argc -= optind;
	argv += optind;

	if (argc <= 0) {
		usage();
	}
	
	/*
	 * config-var is reading the config file implicitly,
	 * so skip it here.
	 */
	if (strcasecmp(argv[0], "config-var") != 0)
		pkg_install_config();

	if (strcasecmp(argv[0], "pmatch") == 0) {

		char *pattern, *pkg;
		
		argv++;		/* "pmatch" */

		if (argv[0] == NULL || argv[1] == NULL) {
			usage();
		}

		pattern = argv[0];
		pkg = argv[1];

		if (pkg_match(pattern, pkg)){
			return 0;
		} else {
			return 1;
		}
	} else if (strcasecmp(argv[0], "config-var") == 0) {
		argv++;
		if (argv == NULL || argv[1] != NULL)
			errx(EXIT_FAILURE, "config-var takes exactly one argument");
		pkg_install_show_variable(argv[0]);
	} else if (strcasecmp(argv[0], "check-license") == 0) {
		if (argv[1] == NULL)
			errx(EXIT_FAILURE, "check-license takes exactly one argument");

		load_license_lists();

		switch (acceptable_pkg_license(argv[1])) {
		case 0:
			puts("no");
			return 0;
		case 1:
			puts("yes");
			return 0;
		case -1:
			errx(EXIT_FAILURE, "invalid license condition");
		}
	} else if (strcasecmp(argv[0], "check-single-license") == 0) {
		if (argv[1] == NULL)
			errx(EXIT_FAILURE, "check-license takes exactly one argument");
		load_license_lists();

		switch (acceptable_license(argv[1])) {
		case 0:
			puts("no");
			return 0;
		case 1:
			puts("yes");
			return 0;
		case -1:
			errx(EXIT_FAILURE, "invalid license");
		}
	} else {
		usage();
	}

	return 0;
}
        