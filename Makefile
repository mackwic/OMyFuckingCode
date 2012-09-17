
EXEC := omfc
FLAGS := -use-ocamlfind -pkg batteries,configurator

all:
	ocamlbuild $(EXEC).byte $(FLAGS)
