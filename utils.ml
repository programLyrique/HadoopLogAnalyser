(** Some utility functions, to debug *)


(** Type to string*)
let taglog_pretty_printer = function
  | LogTypes.Meta -> "Meta"
  | LogTypes.Job -> "Job"
  | LogTypes.MapAttempt -> "MapAttempt"
  | LogTypes.ReduceAttempt -> "ReduceAttempt"
  | LogTypes.Task -> "Task"

(** Type to string *)
let token_pretty_printer token = 
  Parser.(
  "Token_" ^ 
    match token with 
      | Token_EOP -> "EOP"
      | Token_Number(n) -> "Number(" ^ (string_of_int n) ^")"
      | Token_Word(s) -> "Word(" ^s ^")"
      | Token_Ident(s) -> "Ident(" ^ s ^ ")"
      | Token_Tag(tagLog) -> "Tag(" ^ 
	(taglog_pretty_printer tagLog) ^
	")"
      | Token_Equal -> "Equal"
      | Token_Dot -> "Dot"
      | Token_Quote -> "Quote"
      | Token_JobId -> "JobID"
      | Token_JobName -> "JobName"
      | Token_LaunchTime -> "LaunchTime"
      | Token_TotalMaps -> "TotalMaps"
      | Token_TotalReduces -> "TotalReduces"
      | Token_TaskId -> "TaskId"
      | Token_TaskType -> "TaskType"
      | Token_TaskAttemptId -> "TaskAttemptId"
      | Token_StartTime -> "StartTime"
      | Token_Splits -> "Splits"
      | Token_Map -> "Map"
      | Token_Reduce -> "Reduce"
      | Token_Setup -> "Setup"
      | Token_Cleanup -> "Cleanup"
      | Token_FinishTime -> "FinishTime"
      | Token_HostName -> "HostName"
      | Token_TaskStatus -> "TaskStatus"
      | Token_Counters -> "Counters"
      | Token_Success -> "Success"
      | Token_Killed -> "Killed"
  )

(** Print a large representation of the detected tokens*)
let rec tokenize_all tokenizer lexbuf =
  let print_token tok =  print_endline ("# : " ^ (token_pretty_printer tok));
    print_endline ("\t[" ^ (Lexing.lexeme lexbuf) ^"]" ) in
  match (tokenizer lexbuf) with 
    | Parser.Token_EOP -> print_token Parser.Token_EOP
    | token -> print_token token ;
      tokenize_all tokenizer lexbuf

(** All tokens for the input such as the representation will be used by the menhir interpreter*)
let rec tokenize_interp_all tokenizer lexbuf =
  let print_token tok = print_string ((token_pretty_printer tok) ^ " ") in
  match (tokenizer lexbuf) with 
    | Parser.Token_EOP -> print_token Parser.Token_EOP
    | token -> print_token token; tokenize_interp_all tokenizer lexbuf
