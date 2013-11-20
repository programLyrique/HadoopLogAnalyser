(** Some utility functions, to debug *)


(** Type to string*)
let taglog_pretty_printer = function
  | LogTypes.Meta -> "Meta"
  | LogTypes.Job -> "Job"
  | LogTypes.MapAttempt -> "MapAttempt"
  | LogTypes.ReduceAttempt -> "ReduceAttempt"
  | LogTypes.Task -> "Task"

(** Type to string *)
let taskType_pretty_printer = function
  | LogTypes.Setup -> "Setup"
  | LogTypes.Map -> "Map"
  | LogTypes.Reduce -> "Reduce"
  | LogTypes.Cleanup -> "Cleanup"

(** Type to string.
If more = true, more information is printed*)
let token_pretty_printer more token = 
  Parser.(
  "Token_" ^ 
    match token with 
      | Token_EOP -> "EOP"
      | Token_Number(n) -> "Number" ^(if more then "(" ^ (string_of_int n) ^")" else "")
      | Token_Word(s) -> "Word" ^ (if more then "(" ^s ^")" else "" )
      | Token_Ident(s) -> "Ident" ^(if more then "(" ^ s ^ ")" else "")
      | Token_Tag(tagLog) -> "Tag" ^ (if more then "(" ^ (taglog_pretty_printer tagLog) ^ ")" else "" )
      | Token_Equal -> "Equal"
      | Token_Dot -> "Dot"
      | Token_Quote -> "Quote"
      | Token_JobId -> "JobId"
      | Token_JobName -> "JobName"
      | Token_LaunchTime -> "LaunchTime"
      | Token_TotalMaps -> "TotalMaps"
      | Token_TotalReduces -> "TotalReduces"
      | Token_TaskId -> "TaskId"
      | Token_TaskType -> "TaskType"
      | Token_TaskAttemptId -> "TaskAttemptId"
      | Token_StartTime -> "StartTime"
      | Token_Splits -> "Splits"
      | Token_Task(taskType) -> "Task" ^ (if more then "(" ^(taskType_pretty_printer taskType) ^")" else "")
      | Token_FinishTime -> "FinishTime"
      | Token_HostName -> "HostName"
      | Token_TaskStatus -> "TaskStatus"
      | Token_Counters -> "Counters"
      | Token_Success -> "Success"
      | Token_Killed -> "Killed"
  )

(** Print a large representation of the detected tokens*)
let rec tokenize_all tokenizer lexbuf =
  let print_token tok =  print_endline ("# : " ^ (token_pretty_printer true tok));
    print_endline ("\t[" ^ (Lexing.lexeme lexbuf) ^"]" ) in
  match (tokenizer lexbuf) with 
    | Parser.Token_EOP -> print_token Parser.Token_EOP
    | token -> print_token token ;
      tokenize_all tokenizer lexbuf

(** All tokens for the input such as the representation will be used by the menhir interpreter*)
let rec tokenize_interp_all tokenizer lexbuf =
  let print_token tok = print_string ((token_pretty_printer false tok) ^ " ") in
  match (tokenizer lexbuf) with 
    | Parser.Token_EOP -> print_token Parser.Token_EOP
    | token -> print_token token; tokenize_interp_all tokenizer lexbuf
