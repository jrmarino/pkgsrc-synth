#include <err.h>
#include <stdio.h>
#include <stdarg.h>

char *
xasprintf(const char *fmt, ...)
{
	va_list ap;
	char *buf;
	
	va_start(ap, fmt);
	if (vasprintf(&buf, fmt, ap) == -1)
		err(1, "asprintf failed");
	va_end(ap);
	return buf;
}
