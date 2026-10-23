PREFIX ?= /usr
QMLDIR ?= $(PREFIX)/lib/qt6/qml
DEST = $(DESTDIR)$(QMLDIR)/Twilight/Bar

install:
	install -d $(DEST)
	cp -r Twilight/Bar/. $(DEST)

uninstall:
	rm -rf $(DEST)

.PHONY: install uninstall
