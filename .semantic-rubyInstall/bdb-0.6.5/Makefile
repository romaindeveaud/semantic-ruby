SUBDIRS = src

all:
	@for subdir in $(SUBDIRS); do \
		(cd $${subdir} && $(MAKE) all); \
	done;

static:
	@for subdir in $(SUBDIRS); do \
		(cd $${subdir} && $(MAKE) static); \
	done;

clean:
	@for subdir in $(SUBDIRS); do \
		(cd $${subdir} && $(MAKE) clean); \
	done;
	@-rm tmp/* tests/tmp/* 2> /dev/null

distclean:
	@for subdir in $(SUBDIRS); do \
		(cd $${subdir} && $(MAKE) distclean); \
	done;
	@-rm tmp/* tests/tmp/* 2> /dev/null
	@rm Makefile

realclean:
	@for subdir in $(SUBDIRS); do \
		(cd $${subdir} && $(MAKE) realclean); \
	done;
	@-rm tmp/* tests/tmp/* 2> /dev/null
	@rm Makefile

install:
	@for subdir in $(SUBDIRS); do \
		(cd $${subdir} && $(MAKE) install); \
	done;

site-install:
	@for subdir in $(SUBDIRS); do \
		(cd $${subdir} && $(MAKE) site-install); \
	done;

unknown:
	@for subdir in $(SUBDIRS); do \
		(cd $${subdir} && $(MAKE) unknown); \
	done;

%.html: %.rd
	rd2 $< > ${<:%.rd=%.html}

HTML = bdb.html \
	docs/log.html \
	docs/sequence.html \
	docs/cursor.html \
	docs/arraylike.html \
	docs/transaction.html \
	docs/env.html \
	docs/hashlike.html \
	docs/lock.html

RDOC = bdb.rd \
	docs/log.rd \
	docs/sequence.rd \
	docs/cursor.rd \
	docs/arraylike.rd \
	docs/transaction.rd \
	docs/env.rd \
	docs/hashlike.rd \
	docs/lock.rd

rdoc: docs/doc/index.html

docs/doc/index.html: $(RDOC)
	@-(cd docs; rdoc .)

ri:
	@-(rdoc -r docs/*rb)

ri-site:
	@-(rdoc -R docs/*rb)

rd2: html

html: $(HTML)

test: $(DLLIB)
	-ruby1.8 tests/hash.rb
	-ruby1.8 tests/queue.rb
	-ruby1.8 tests/recno.rb
	-ruby1.8 tests/log.rb
	-ruby1.8 tests/recnum.rb
	-ruby1.8 tests/marshal.rb
	-ruby1.8 tests/lock.rb
	-ruby1.8 tests/btree.rb
