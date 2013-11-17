(** Hadoop log visualisation *)


(* Taken from the example in https://github.com/derdon/menhir-example/blob/master/calc.ml *)
open Batteries

(* the name of the file which contains the expressions *)
let filename = Sys.argv.(1)
      
let main () =
  let input = open_in filename in
  let filebuf = Lexing.from_input input in
  (*Utils.tokenize_all Lexer.make_token filebuf;
  Lexing.flush_input filebuf;*)
  (*ignore (Parser.make_logfile Lexer.make_token filebuf)*)
  print_endline "Parsing";
  try
    ignore (Parser.make_logfile Lexer.make_token filebuf)
  with
  | Lexer.Error msg ->
      Printf.eprintf "%s%!" msg
  | Parser.Error ->
      Printf.eprintf "At offset %d: syntax error.\n%!" (Lexing.lexeme_start filebuf)
  ;
  IO.close_in input

let _ = main ()

