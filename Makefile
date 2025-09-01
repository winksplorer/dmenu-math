# dmenu-math - dynamic menu with math expression support
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dmenu.c stest.c util.c tinyexpr.c
OBJ = $(SRC:.c=.o)

all: dmenu-math stest

.c.o:
	$(CC) -c $(CFLAGS) $<

config.h:
	cp config.def.h $@

$(OBJ): arg.h config.h config.mk drw.h

dmenu-math: dmenu.o drw.o util.o tinyexpr.o
	$(CC) -o $@ dmenu.o drw.o util.o tinyexpr.o $(LDFLAGS)

stest: stest.o
	$(CC) -o $@ stest.o $(LDFLAGS)

clean:
	rm -f dmenu-math stest $(OBJ) dmenu-math-$(VERSION).tar.gz

dist: clean
	mkdir -p dmenu-math-$(VERSION)
	cp LICENSE Makefile README arg.h config.def.h config.mk dmenu-math.1\
		drw.h util.h dmenu-math_path dmenu-math_run stest.1 $(SRC)\
		dmenu-math-$(VERSION)
	tar -cf dmenu-math-$(VERSION).tar dmenu-math-$(VERSION)
	gzip dmenu-math-$(VERSION).tar
	rm -rf dmenu-math-$(VERSION)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f dmenu-math dmenu-math_path dmenu-math_run stest $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu-math
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu-math_path
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu-math_run
	chmod 755 $(DESTDIR)$(PREFIX)/bin/stest
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < dmenu-math.1 > $(DESTDIR)$(MANPREFIX)/man1/dmenu-math.1
	sed "s/VERSION/$(VERSION)/g" < stest.1 > $(DESTDIR)$(MANPREFIX)/man1/stest.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/dmenu-math.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/stest.1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/dmenu-math\
		$(DESTDIR)$(PREFIX)/bin/dmenu-math_path\
		$(DESTDIR)$(PREFIX)/bin/dmenu-math_run\
		$(DESTDIR)$(PREFIX)/bin/stest\
		$(DESTDIR)$(MANPREFIX)/man1/dmenu-math.1\
		$(DESTDIR)$(MANPREFIX)/man1/stest.1

.PHONY: all clean dist install uninstall
