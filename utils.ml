(** Some utility functions, to debug *)

open Batteries

(** Type to string*)
let taglog_pretty_printer = function
  | LogTypes.Meta -> "Meta"
  | LogTypes.Job -> "Job"
  | LogTypes.MapAttempt -> "MapAttempt"
  | LogTypes.ReduceAttempt -> "ReduceAttempt"
  | LogTypes.Task -> "Task"

let status_pretty_printer = function
  | LogTypes.Success -> "Success"
  | LogTypes.Failed -> "Failed"
  | LogTypes.Killed -> "Killed"

(** Type to string *)
let taskType_pretty_printer = function
  | LogTypes.Setup -> "Setup"
  | LogTypes.Map -> "Map"
  | LogTypes.Reduce -> "Reduce"
  | LogTypes.Cleanup -> "Cleanup"

let more_printer more  func arg = if  more then "(" ^ (func arg) ^ ")" else ""

(** Type to string.
If more = true, more information is printed*)
let token_pretty_printer more token = 
  Parser.(
  "Token_" ^ 
    match token with 
      | Token_EOP -> "EOP"
      | Token_Number(n) -> "Number" ^ (more_printer more string_of_int n)
      | Token_Word(s) -> "Word" ^ (more_printer more identity s)
      | Token_Ident(s) -> "Ident" ^ (more_printer more identity s)
      | Token_Tag(tagLog) -> "Tag" ^ (more_printer more  taglog_pretty_printer tagLog)
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
      | Token_Task(taskType) -> "Task" ^ (more_printer more taskType_pretty_printer taskType)
      | Token_FinishTime -> "FinishTime"
      | Token_HostName -> "HostName"
      | Token_TaskStatus -> "TaskStatus"
      | Token_Counters -> "Counters"
      | Token_Status(status) -> "Status" ^ (more_printer more status_pretty_printer status)
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
