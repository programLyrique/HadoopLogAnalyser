{

(** Defines lexical units of the log file *)

open Batteries
open Parser

}

let BLANK = [' ' '\t' '\n']

let LINE = [^ '\n']* '\n'

let NUM = ['0'-'9']
let ALPHA =  ['a'-'z' 'A'-'Z' '-' '_' ]
let WORD = ALPHA (ALPHA | NUM)*

let NUMBER = '-'? ['0'-'9']+

let DOT = "."
let EQUAL = "="

let QUOTE = "\""


rule make_token = parse
  | BLANK {make_token lexbuf}
  | eof {Token_EOP}
  (* Tokens for jobs*)
  | "Job" {Token_Job}
  | "JOBID" {Token_JobId}
  | "JOBNAME" {Token_JobName}
  | "LAUNCH_TIME" {Token_LaunchTime}
  | "TOTAL_MAPS" {Token_TotalMaps}
  | "TOTAL_REDUCES" {Token_TotalReduces}
  (* Tokens for tasks, and will be also used for map and
  reduce attempts*)
  | "Task" {Token_Task}
  | "TASKID" {Token_TaskId}
  | "TASK_TYPE" {Token_TaskType}
  | "START_TIME" {Token_StartTime}
  | "SPLITS" {Token_Splits}
  | "MAP" {Token_Map}
  | "REDUCE" {Token_Reduce}
  | "SETUP" {Token_Setup}
  | "CLEANUP" {Token_Cleanup}
  (* Tokens for map attempts *)
  (* Add the TASK_ATTEMPT_ID ?*)
  | "MapAttempt" {Token_MapAttempt}
  | "FINISH_TIME" {Token_FinishTime}
  | "HOSTNAME" {Token_HostName}
  | "TASK_STATUS" {Token_TaskStatus}
  | "COUNTERS" {Token_Counters}
  (* Tokens for reduce attempts *)
  | "ReduceAttempt" {Token_ReduceAttempt}
  (* Tokens for results*)
  | "SUCCESS" { Token_Success }
  | "KILLED" {Token_Killed}
(* Add info in Counters *) 



