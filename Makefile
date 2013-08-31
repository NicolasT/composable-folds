OCAMLBUILD ?= ocamlbuild

SOURCES = tuples.ml tuples.mli \
	  fold.ml fold.mli \
	  demo.ml \
	  validate.ml

default: all

all: $(SOURCES)
	$(OCAMLBUILD) demo.native validate.o

clean:
	$(OCAMLBUILD) -clean
.PHONY: clean
