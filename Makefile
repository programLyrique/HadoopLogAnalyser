.PHONY: all

all:

ocamlbuild -use-ocamlfind hadoopLogVisual.native
mv hadoopLogVisual.native hadoopLogVisual
