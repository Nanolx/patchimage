all:
	@echo "nothing to do, use 'make install'"

install:
	mkdir -p $(DESTDIR)/usr/bin/
	mkdir -p $(DESTDIR)/usr/share/patchimage/
	cp -rv data database patches scripts $(DESTDIR)/usr/share/patchimage/
	install -m755 patchimage.sh $(DESTDIR)/usr/bin/patchimage
	if [ $(shell uname -m) = x86_64 ]; then \
		mkdir -p $(DESTDIR)/usr/lib/x86_64-linux-gnu/patchimage/tools ; \
		mkdir -p $(DESTDIR)/usr/lib/x86_64-linux-gnu/patchimage/override ; \
		cp -rv tools/*.64 tools/unp tools/ucat tools/gdown.pl tools/ignore_3dstool.txt \
			$(DESTDIR)/usr/lib/x86_64-linux-gnu/patchimage/tools ; \
		cp -rv override/linux64 $(DESTDIR)/usr/lib/x86_64-linux-gnu/patchimage/override ; \
	else	mkdir -p $(DESTDIR)/usr/lib/i386-linux-gnu/patchimage/tools ; \
		mkdir -p $(DESTDIR)/usr/lib/i386-linux-gnu/patchimage/override ; \
		cp -rv tools/*.32 tools/unp tools/ucat tools/gdown.pl tools/ignore_3dstool.txt \
			$(DESTDIR)/usr/lib/i386-linux-gnu/patchimage/tools ; \
		cp -rv override/linux32 $(DESTDIR)/usr/lib/i386-linux-gnu/patchimage/override ; \
	fi

uninstall:
	rm -rf $(DESTDIR)/usr/share/patchimage
	rm -f $(DESTDIR)/usr/bin/patchimage
	if [ $(shell uname -m) = x86_64 ]; then \
		rm -rf $(DESTDIR)/usr/lib/x86_64-linux-gnu/patchimage ; \
	else	rm -rf $(DESTDIR)/usr/lib/i386-linux-gnu/patchimage ; \
	fi

clean:
	@echo "nothing to"
