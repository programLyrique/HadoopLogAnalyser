.PHONY: all

all:

ocamlbuild hadoopLogVisual.native
mv hadoopLogVisual.native hadoopLogVisual
