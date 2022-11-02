GRUB_THEMES=sua-sponte-theme/grub\
    ranger-theme/grub
DEFAULT_BACKGROUND=desktop-background

PIXMAPS=$(wildcard pixmaps/*.png)
DESKTOPFILES=$(wildcard *.desktop)

.PHONY: all clean install install-local
all: build-grub build-emblems build-logos
clean: clean-grub clean-emblems clean-logos

.PHONY: build-grub clean-grub install-grub
build-grub clean-grub install-grub:
	@target=`echo $@ | sed s/-grub//`; \
	for grub_theme in $(GRUB_THEMES) ; do \
		if [ -f $$grub_theme/Makefile ] ; then \
			$(MAKE) $$target -C $$grub_theme || exit 1; \
		fi \
	done

.PHONY: build-emblems clean-emblems install-emblems
build-emblems clean-emblems install-emblems:
	@target=`echo $@ | sed s/-emblems//`; \
	$(MAKE) $$target -C emblems-cybint || exit 1;

.PHONY: build-logos clean-logos install-logos
build-logos clean-logos install-logos:
	@target=`echo $@ | sed s/-logos//`; \
	$(MAKE) $$target -C cybint-logos || exit 1;


install: install-grub install-emblems install-logos install-local

install-local:
	# background files
	mkdir -p $(DESTDIR)/usr/share/images/desktop-base
	cd $(DESTDIR)/usr/share/images/desktop-base && ln -s $(DEFAULT_BACKGROUND) default
	# desktop files
	mkdir -p $(DESTDIR)/usr/share/desktop-base
	$(INSTALL_DATA) $(DESKTOPFILES) $(DESTDIR)/usr/share/desktop-base/
	# pixmaps files
	mkdir -p $(DESTDIR)/usr/share/pixmaps
	$(INSTALL_DATA) $(PIXMAPS) $(DESTDIR)/usr/share/pixmaps/

	# Create a 'sua-sponte-theme' symlink in plymouth themes folder, pointing at the
	# plymouth theme for the currently active 'desktop-theme' alternative.
	mkdir -p $(DESTDIR)/usr/share/plymouth/themes
	ln -s ../../desktop-base/active-theme/plymouth $(DESTDIR)/usr/share/plymouth/themes/sua-sponte-theme

	# Set Plasma 5/KDE default wallpaper
	install -d $(DESTDIR)/usr/share/plasma/shells/org.kde.plasma.desktop/contents/updates
	$(INSTALL_DATA) defaults/plasma5/desktop-base.js $(DESTDIR)/usr/share/plasma/shells/org.kde.plasma.desktop/contents/updates/

	# Xfce 4.6
	mkdir -p $(DESTDIR)/usr/share/desktop-base/profiles/xdg-config/xfce4/xfconf/xfce-perchannel-xml
	$(INSTALL_DATA) $(wildcard profiles/xdg-config/xfce4/xfconf/xfce-perchannel-xml/*) $(DESTDIR)/usr/share/desktop-base/profiles/xdg-config/xfce4/xfconf/xfce-perchannel-xml

	# GNOME background descriptors
	mkdir -p $(DESTDIR)/usr/share/gnome-background-properties

	# Sua-Sponte theme (CYBINT's default)
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/sua-sponte
	$(INSTALL_DATA) $(wildcard sua-sponte-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/sua-sponte
	install -d $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme
	cd $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme && ln -s /usr/share/plymouth/themes/sua-sponte plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme/login
	$(INSTALL_DATA) $(wildcard sua-sponte-theme/login/*) $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme/wallpaper/contents/images
	$(INSTALL_DATA) sua-sponte-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme/wallpaper
	$(INSTALL_DATA) sua-sponte-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme/wallpaper
	$(INSTALL_DATA) $(wildcard sua-sponte-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme/wallpaper/contents/images/
	$(INSTALL_DATA) sua-sponte-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/cybint-sua-sponte.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/sua-sponte-theme/wallpaper sua-sponte

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme/lockscreen/contents/images
	$(INSTALL_DATA) sua-sponte-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme/lockscreen
	$(INSTALL_DATA) sua-sponte-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme/lockscreen
	$(INSTALL_DATA) $(wildcard sua-sponte-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme/lockscreen/contents/images/

	### Alternate wallpaper with cybint swirl
	install -d $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme/wallpaper-withlogo/contents/images
	$(INSTALL_DATA) sua-sponte-theme/wallpaper-withlogo/metadata.desktop $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme/wallpaper-withlogo
	$(INSTALL_DATA) sua-sponte-theme/wallpaper-withlogo/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme/wallpaper-withlogo
	$(INSTALL_DATA) $(wildcard sua-sponte-theme/wallpaper-withlogo/contents/images/*) $(DESTDIR)/usr/share/desktop-base/sua-sponte-theme/wallpaper-withlogo/contents/images/

	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/sua-sponte-theme/wallpaper-withlogo sua-sponteWithLogo


	# ranger theme
	### Plymouth theme
	install -d $(DESTDIR)/usr/share/plymouth/themes/ranger
	$(INSTALL_DATA) $(wildcard ranger-theme/plymouth/*) $(DESTDIR)/usr/share/plymouth/themes/ranger
	install -d $(DESTDIR)/usr/share/desktop-base/ranger-theme
	cd $(DESTDIR)/usr/share/desktop-base/ranger-theme && ln -s /usr/share/plymouth/themes/ranger plymouth

	### Login background
	install -d $(DESTDIR)/usr/share/desktop-base/ranger-theme/login
	$(INSTALL_DATA) $(wildcard ranger-theme/login/*) $(DESTDIR)/usr/share/desktop-base/ranger-theme/login

	### Wallpapers
	install -d $(DESTDIR)/usr/share/desktop-base/ranger-theme/wallpaper/contents/images
	$(INSTALL_DATA) ranger-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/ranger-theme/wallpaper
	$(INSTALL_DATA) ranger-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/ranger-theme/wallpaper
	$(INSTALL_DATA) $(wildcard ranger-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/ranger-theme/wallpaper/contents/images/
	$(INSTALL_DATA) ranger-theme/gnome-wp-list.xml $(DESTDIR)/usr/share/gnome-background-properties/cybint-ranger.xml
	# Wallpaper symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/ranger-theme/wallpaper ranger

	### Lockscreen is using the same image as wallpaper
	install -d $(DESTDIR)/usr/share/desktop-base/ranger-theme/lockscreen/contents/images
	$(INSTALL_DATA) ranger-theme/wallpaper/metadata.desktop $(DESTDIR)/usr/share/desktop-base/ranger-theme/lockscreen
	$(INSTALL_DATA) ranger-theme/wallpaper/gnome-background.xml $(DESTDIR)/usr/share/desktop-base/ranger-theme/lockscreen
	$(INSTALL_DATA) $(wildcard ranger-theme/wallpaper/contents/images/*) $(DESTDIR)/usr/share/desktop-base/ranger-theme/lockscreen/contents/images/

	# Lock screen symlink for KDE
	install -d $(DESTDIR)/usr/share/wallpapers
	cd $(DESTDIR)/usr/share/wallpapers && ln -s /usr/share/desktop-base/ranger-theme/wallpaper ranger_wallpaper

include Makefile.inc
