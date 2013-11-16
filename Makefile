.PHONY: logVis

logVis: 
	ocamlbuild -use-ocamlfind hadoopLogVisual.native &&  mv hadoopLogVisual.native hadoopLogVisual
