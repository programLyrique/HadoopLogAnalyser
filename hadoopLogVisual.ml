(** Hadoop log visualisation *)


(* Taken from the example in https://github.com/derdon/menhir-example/blob/master/calc.ml *)
open Batteries


    
let main () =
  (* the name of the file which contains the expressions *)
  if (Array.length (Sys.argv)) > 1 then
    begin
      let filename = Sys.argv.(1) in
      let input = open_in filename in
      let filebuf = Lexing.from_input input in
      if (Array.length (Sys.argv)) >= 3 then
	(if Sys.argv.(2) = "d" then
	    Utils.tokenize_interp_all Lexer.make_token filebuf)
      else
	begin
	  Printf.printf "\nParsing\n\n";
	  try
	    let logFile = Parser.make_logfile Lexer.make_token filebuf in
	    (*LogTypes.(Printf.printf "Job id = %s\n%!" job.jobId)*)
	    Printf.printf "%s\n"   (Yojson.Basic.pretty_to_string 
				      (JsonExport.logFileToJson logFile))
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
    end
  else
    Printf.eprintf "Error : no input file.\n"

let _ = main ()

