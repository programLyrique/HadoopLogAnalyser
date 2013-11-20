(** Hadoop log visualisation *)


(* Taken from the example in https://github.com/derdon/menhir-example/blob/master/calc.ml *)
open Batteries

(* the name of the file which contains the expressions *)
let filename = Sys.argv.(1)
      
let main () =
  let input = open_in filename in
  let filebuf = Lexing.from_input input in
 (* Utils.tokenize_all Lexer.make_token filebuf;
  Lexing.flush_input filebuf;*)
  if (Array.length (Sys.argv)) >= 3
  then (if Sys.argv.(2) = "d" then
      Utils.tokenize_interp_all Lexer.make_token filebuf)
  else
    begin
      print_newline ();
      print_endline "Parsing";
      try
	let LogTypes.LogFile(job, _, _) = Parser.make_logfile Lexer.make_token filebuf in
	LogTypes.(Printf.printf "Job id = %s\n%!" job.jobId)
      with
	| Lexer.Error msg ->
	  Printf.eprintf "%s%!" msg
	| Parser.Error ->
	  Lexing.(
	    let pos = lexeme_start_p filebuf in
	    Printf.eprintf "At line %d, column %d: syntax error.\n%!" pos.pos_lnum (pos.pos_cnum - pos.pos_bol))
	  ;
	  IO.close_in input
    end
let _ = main ()

