PROG=		pkgng_admin
CFLAGS+=	-I.
OBJS=		dewey.o \
		license.o \
		nbcompat.o \
		opattern.o \
		parse-config.o \
		main.o

all:	${PROG}

.c.o:
	${CC} ${CFLAGS} -c ${.ALLSRC}

${PROG}: ${OBJS}
	${CC} ${LDFLAGS} -o ${.TARGET} ${.ALLSRC}

clean:
	rm -r ${OBJS} ${PROG}

install: pkgng_admin.1 pkgng_admin.conf.5
	mkdir -p ${DESTDIR}${PREFIX}/sbin \
		${DESTDIR}${PREFIX}/man/man1 \
		${DESTDIR}${PREFIX}/man/man5
	cp ${PROG} ${DESTDIR}${PREFIX}/sbin/
	cp pkgng_admin.1 ${DESTDIR}${PREFIX}/man/man1/
	cp pkgng_admin.conf.5 ${DESTDIR}${PREFIX}/man/man5/
