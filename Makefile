all : weeb

.PHONY : all deployable install

CFLAGS = "`pkg-config --cflags gtk+-3.0`"
LDFLAGS = "`pkg-config --libs gtk+-3.0`"

DESTDIR = /
PREFIX = /opt
INSTALL_DIR = $(DESTDIR)$(PREFIX)
BINDIR = $(DESTDIR)usr/bin/

weeb : weeb.scm gtk3_bindings.h
	csc -vk weeb.scm -C $(CFLAGS) -L $(LDFLAGS)

deploy_dir :
	mkdir -p deploy_dir

deploy_dir/weeb/weeb : weeb.scm gtk3_bindings.h
	mkdir -p deploy_dir/weeb
	csc -C $(CFLAGS) -L $(LDFLAGS) -deploy weeb.scm -o deploy_dir/weeb

# I'm checking for one of the *.so files, but it's really all the deps
deploy_dir/weeb/coops.so :
	mkdir -p deploy_dir/weeb
	chicken-install -deploy -p deploy_dir/weeb bind http-client uri-common openssl medea

deployable : deploy_dir/weeb/weeb deploy_dir/weeb/coops.so

install : deployable
	install -d $(INSTALL_DIR)
	install -d $(BINDIR)
	cp -r deploy_dir/* $(INSTALL_DIR)
	ln -s $(INSTALL_DIR)/weeb/weeb $(BINDIR)/weeb
