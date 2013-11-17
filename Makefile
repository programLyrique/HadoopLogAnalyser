.PHONY: logVis clean grammar

logVis: 
	ocamlbuild -use-ocamlfind hadoopLogVisual.native &&  mv hadoopLogVisual.native hadoopLogVisual

clean:
	ocamlbuild -clean

grammar:
	 rlwrap menhir --interpret --interpret-show-cst --ocamldep 'ocamlfind ocamldep -modules' parser.mly 
	
