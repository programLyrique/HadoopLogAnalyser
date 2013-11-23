.PHONY: logVis clean grammar tests

logVis: 
	ocamlbuild -use-ocamlfind hadoopLogVisual.native &&  mv hadoopLogVisual.native hadoopLogVisual

clean:
	ocamlbuild -clean

grammar:
	 rlwrap menhir --interpret --interpret-show-cst --ocamldep 'ocamlfind ocamldep -modules' parser.mly 
	

tests:
	ocamlbuild -use-ocamlfind tests.native  && ./tests.native
