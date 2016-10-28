/*	$NetBSD: parse-config.c,v 1.15 2010/06/16 23:02:49 joerg Exp $	*/

#if HAVE_CONFIG_H
#include "config.h"
#endif
#include <nbcompat.h>
#if HAVE_SYS_CDEFS_H
#include <sys/cdefs.h>
#endif
__RCSID("$NetBSD: parse-config.c,v 1.15 2010/06/16 23:02:49 joerg Exp $");

/*-
 * Copyright (c) 2008, 2009 Joerg Sonnenberger <joerg@NetBSD.org>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#if HAVE_ERR_H
#include <err.h>
#endif
#include <errno.h>
#if HAVE_STRING_H
#include <string.h>
#endif
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "lib.h"

const char     *config_file = SYSCONFDIR"/pkgng_install.conf";

const char *do_license_check;
const char *acceptable_licenses = NULL;

static struct config_variable {
	const char *name;
	const char **var;
} config_variables[] = {
	{ "ACCEPTABLE_LICENSES", &acceptable_licenses },
	{ "CHECK_LICENSE", &do_license_check },
	{ "DEFAULT_ACCEPTABLE_LICENSES", &default_acceptable_licenses },
	{ NULL, NULL }, /* For use by pkg_install_show_variable */
	{ NULL, NULL }
};

char *config_tmp_variables[sizeof config_variables/sizeof config_variables[0]];

static void
parse_pkg_install_conf(void)
{
	struct config_variable *var;
	FILE *fp;
	char *line, *value;
	size_t len, var_len, i;

	fp = fopen(config_file, "r");
	if (!fp) {
		if (errno != ENOENT)
			warn("Can't open '%s' for reading", config_file);
		return;
	}

	while ((line = fgetln(fp, &len)) != (char *) NULL) {
		if (line[len - 1] == '\n')
			--len;
		for (i = 0; (var = &config_variables[i])->name != NULL; ++i) {
			var_len = strlen(var->name);
			if (strncmp(var->name, line, var_len) != 0)
				continue;
			if (line[var_len] != '=')
				continue;
			line += var_len + 1;
			len -= var_len + 1;
			if (config_tmp_variables[i])
				value = xasprintf("%s\n%.*s",
				    config_tmp_variables[i], (int)len, line);
			else
				value = xasprintf("%.*s", (int)len, line);
			free(config_tmp_variables[i]);
			config_tmp_variables[i] = value;
			break;
		}
	}

	for (i = 0; (var = &config_variables[i])->name != NULL; ++i) {
		if (config_tmp_variables[i] == NULL)
			continue;
		*var->var = config_tmp_variables[i];
		config_tmp_variables[i] = NULL;
	}

	fclose(fp);
}

void
pkg_install_config(void)
{
	char *value;

	parse_pkg_install_conf();

	if (do_license_check == NULL)
		do_license_check = "no";
}

void
pkg_install_show_variable(const char *var_name)
{
	struct config_variable *var;
	const char *tmp_value = NULL;

	for (var = config_variables; var->name != NULL; ++var) {
		if (strcmp(var->name, var_name) == 0)
			break;
	}
	if (var->name == NULL) {
		var->name = var_name;
		var->var = &tmp_value;
	}

	pkg_install_config();

	if (*var->var != NULL)
		puts(*var->var);
}
