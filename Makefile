
EXEC := omfc
DEBUG := 1

DIRS := src,src/configurator,test

# ocaml packages to load, comma separated packages
PACKAGES := batteries

# given to ocamlc/ocamlopt, comma separated flags
CFLAGS = -annot,-principal,-w,+1..30
FLAGS = -j 0 -r -I . -use-ocamlfind -pkg $(PACKAGES) -cflags $(CFLAGS) -Is $(DIRS)

ifdef DEBUG
	CFLAGS := $(CFLAGS),-g
endif

all:
	ocamlbuild $(EXEC).byte $(FLAGS)
	cp $(EXEC).byte $(EXEC)


clean::
	ocamlbuild -clean