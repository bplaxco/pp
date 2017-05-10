########################################################
# useful targets:
#   make sdist ---------------- produce a tarball
#   make rpm  ----------------- produce RPMs

########################################################

PKGNAME := $(shell cat PKGNAME)
VERSION := $(shell cat VERSION)
RELEASE := $(shell cat RELEASE)
RPMSPECDIR := .
RPMSPEC := $(RPMSPECDIR)/rpm.spec
SOURCEDIR=$(PKGNAME)-$(VERSION)

all: $(PKGNAME)

# Build the spec file on the fly.
rpm.spec: rpm.spec.in
	cat $< | \
	sed "s/%VERSION%/$(VERSION)/" | \
	sed "s/%RELEASE%/$(RELEASE)/" | \
	sed "s/%PKGNAME%/$(PKGNAME)/" \
	> $@

clean:
	@find . -type f -regex ".*\.[o]$$" -delete
	@find . -type f \( -name "*~" -or -name "#*" \) -delete
	@rm -fR dist rpm-build rpm.spec ./$(PKGNAME)

install:
	gcc -o pp pp.c
	mkdir -p $(DESTDIR)/usr/bin
	cp ./pp $(DESTDIR)/usr/bin/

sdist: clean rpm.spec
	mkdir -p ./$(SOURCEDIR) && mkdir -p dist &&\
	cp -r $(shell ls | grep -v $(SOURCEDIR)) ./$(SOURCEDIR)/ && \
	tar -czf ./dist/$(SOURCEDIR).tar.gz $(SOURCEDIR)
	rm -r $(SOURCEDIR)

rpm: sdist
	@mkdir -p rpm-build
	@cp dist/*.gz rpm-build/
	rpmbuild --define "_topdir %(pwd)/rpm-build" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \
	--define "_specdir $(RPMSPECDIR)" \
	--define "_sourcedir %{_topdir}" \
	-ba $(RPMSPEC)
	###########################################################################
	@echo "$(PKGNAME) RPMs are built:"
	@find rpm-build -maxdepth 2 -name '$(PKGNAME)*.rpm' | awk '{print "* " $$1}'
