SHELL      = bash
OCAMLBUILD = ocamlbuild
DEDUKTI    = dkc
OPENTHEORY = opentheory

OPTIONS    = -classic-display
BUILD_DIR  = build
INCLUDES   = src
LIBS       = str

# OpenTheory standard library
# (needs the opentheory tool if you don't have the article files)
STDLIB =\
  unit\
  bool\
  pair\
  function\
  natural\
  set\
  list\
  option\
  real\
  relation\
  sum

BUILD = $(OCAMLBUILD) \
  $(OPTIONS) -build-dir $(BUILD_DIR) -libs $(LIBS) -Is $(INCLUDES)

holide:
	$(BUILD) main.native
	ln -sf build/src/main.native holide
	$(DEDUKTI) -o dedukti/hol.lua dedukti/hol.dk

test: holide dedukti/unit.dk
	$(BUILD) test.native --
	cd dedukti && dkc unit.dk | lua -

stdlib: $(STDLIB:%=dedukti/%.dk)

clean:
	$(BUILD) -clean
	rm -rf holide
	rm -f dedukti/hol.lua
	rm -f $(STDLIB:%=dedukti/%.dk)

stat:
	wc -l src/*.ml*

dedukti/%.dk: holide opentheory/%.art
	./holide opentheory/$*.art -o dedukti/$*.dk 

opentheory/%.art:
	$(OPENTHEORY) install $*
	$(OPENTHEORY) info --article -o opentheory/$*.art $*

.PHONY : holide test stdlib clean stat

# Prevent make from deleting intermediary files.
.SECONDARY:

