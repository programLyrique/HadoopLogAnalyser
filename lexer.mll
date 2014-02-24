{

(** Defines lexical units of the log file *)

open Batteries
open Parser
open Lexing

exception Error of string

(** Update num of line.
@author Real world OCaml 
*)
let next_line lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = lexbuf.lex_curr_pos;
               pos_lnum = pos.pos_lnum + 1
    }

}

let BLANK = [' ' '\t' ]

(*let LINE = [^ '\n']* '\n'*)
let LINE = '\n'

let NUM = ['0'-'9']
let ALPHA =  ['a'-'z' 'A'-'Z' '-' '_' ]


let NUMBER = '-'? ['0'-'9']+

let DOT = '.'
let EQUAL = '='

let QUOTE = '\"'

let LEFTPAR = '('
let RIGHTPAR = ')'

let LEFTBRACK = '['
let RIGHTBRACK = ']'

let LEFTBRACE = '{'
let RIGHTBRACE = '}'

let DELIMITER = RIGHTPAR | LEFTPAR | RIGHTBRACK | LEFTBRACK | RIGHTBRACE | LEFTBRACE

(* Miscellaneous characters *)
let MISCHAR = ['\\'  '_'  '/'  '-'  '$'  '.' ':' '*' '+' '>' ','] 

let SPACE = ' '

let IDENT = (MISCHAR | DELIMITER | ALPHA | NUM)*

let WORD = (MISCHAR | DELIMITER | ALPHA | NUM  )* 


rule make_token = parse
  | eof {Token_EOP}
  | "Meta" {Token_Tag(LogTypes.Meta)}
  (* Tokens for jobs*)
  | "Job" {Token_Tag(LogTypes.Job)}
  | "JOBID" {Token_JobId}
  | "JOBNAME" {Token_JobName}
  | "LAUNCH_TIME" {Token_LaunchTime}
  | "TOTAL_MAPS" {Token_TotalMaps}
  | "TOTAL_REDUCES" {Token_TotalReduces}
  (* Tokens for tasks, and will be also used for map and
  reduce attempts*)
  | "Task" {Token_Tag(LogTypes.Task)}
  | "TASKID" {Token_TaskId}
  | "TASK_TYPE" {Token_TaskType}
  | "START_TIME" {Token_StartTime}
  | "SPLITS" {Token_Splits}
  | "MAP" {Token_Task(LogTypes.Map)}
  | "REDUCE" {Token_Task(LogTypes.Reduce)}
  | "SETUP" {Token_Task(LogTypes.Setup)}
  | "CLEANUP" {Token_Task(LogTypes.Cleanup)}
  (* Tokens for map attempts *)
  (* Add the TASK_ATTEMPT_ID ?*)
  | "MapAttempt" {Token_Tag(LogTypes.MapAttempt)}
  | "FINISH_TIME" {Token_FinishTime}
  | "HOSTNAME" {Token_HostName}
  | "TASK_STATUS" {Token_TaskStatus}
  | "COUNTERS" {Token_Counters}
  | "TASK_ATTEMPT_ID" {Token_TaskAttemptId}
  (* Tokens for reduce attempts *)
  | "ReduceAttempt" {Token_Tag(LogTypes.ReduceAttempt)}
  (* Tokens for results*)
  | "SUCCESS" { Token_Status(LogTypes.Success) }
  | "KILLED" {Token_Status(LogTypes.Killed)}
  | "FAILED" {Token_Status(LogTypes.Failed)}
  (*| "STATE_STRING" { Token_StateString }*)
  (* Add info in Counters *) 
  | QUOTE {Token_Quote}
  | DOT {Token_Dot}
  | EQUAL {Token_Equal}
  | NUMBER 
      {
	let s = Lexing.lexeme lexbuf
	in Token_Number(int_of_string(s))
      }
  | WORD 
      {
        let s = (Lexing.lexeme lexbuf)
        in Token_Word(s)
      }
  | IDENT 
      {
	let s = Lexing.lexeme lexbuf 
	in Token_Ident(s)
      }
  | LINE { next_line lexbuf ; make_token lexbuf }
  | BLANK {make_token lexbuf}
  | _ as c (* Default case : skip the character *)
      {
	raise (Error("Unrecognized character : " ^ (Char.escaped c) ))
     }






