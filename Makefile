all:
	@echo "nothing to do"

install:
	mkdir -p $(DESTDIR)/usr/bin/
	mkdir -p $(DESTDIR)/usr/share/patchimage/
	cp -rv patches tools script.d $(DESTDIR)/usr/share/patchimage/
	install -m755 patchimage.sh $(DESTDIR)/usr/bin/patchimage

uninstall:
	rm -rf $(DESTDIR)/usr/share/patchimage
	rm -f $(DESTDIR)/usr/bin/patchimage

clean:
