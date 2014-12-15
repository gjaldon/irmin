TESTS  ?= --enable-tests
PREFIX ?= /usr/local

VERSION = $(shell grep 'Version:' _oasis | sed 's/Version: *//')
SETUP   = ocaml setup.ml
VFILE   = lib/ir_version.ml
SFILE   = lib/http/irmin_http_static.ml
SFILES  = $(wildcard lib/http/static/*.js) \
	  $(wildcard lib/http/*.html) \
	  $(wildcard lib/http/static/*.css)

build: setup.data $(VFILE) $(SFILE)
	$(SETUP) -build $(BUILDFLAGS)

doc: setup.data build
	$(SETUP) -doc $(DOCFLAGS)

test: setup.data build
	$(SETUP) -test $(TESTFLAGS)

all:
	$(SETUP) -all $(ALLFLAGS)

install: setup.data
	$(SETUP) -install $(INSTALLFLAGS)

uninstall: setup.data
	$(SETUP) -uninstall $(UNINSTALLFLAGS)

reinstall: setup.data
	$(SETUP) -reinstall $(REINSTALLFLAGS)

clean:
	$(SETUP) -clean $(CLEANFLAGS)
	rm -f $(VFILE) $(SFILE)
	rm -rf ./test-db

distclean:
	$(SETUP) -distclean $(DISTCLEANFLAGS)

setup.data:
	$(SETUP) -configure $(CONFIGUREFLAGS) $(TESTS) --prefix $(PREFIX)

.PHONY: build doc test all install uninstall reinstall clean distclean configure

$(VFILE): _oasis
	echo "let current = \"$(VERSION)\"" > $@

$(SFILE): $(SFILES)
	cd lib/http/ && ./make_static.sh
