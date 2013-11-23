(** Unit tests for the parser*)

open OUnit

let parse_logfile filename =
  BatFile.with_file_in filename 
    (fun file -> 
      let filebuf = BatLexing.from_input file in
      Parser.make_logfile Lexer.make_token filebuf
    )

let string_printer (s:string) = s

module JobTest = struct
  let test () = 
    let  LogTypes.LogFile(job, _, _) = 
      parse_logfile "tests/Job.log" in
    LogTypes.(
      assert_equal ~msg:"jobId" 
	~printer:string_printer
	"job_201210041922_0001" job.jobId;
      assert_equal ~msg:"jobName"
	~printer:string_printer
	"sorter" job.jobName;
      assert_equal ~msg:"nbMaps"
	~printer:string_of_int
	313 job.nbMaps;
      assert_equal ~msg:"nbReduces" 
	~printer:string_of_int
	36 job.nbReduces
    )
end

(* Name the test cases and group them together *)
let suite = 
"Job">:::
 ["JobId">:: JobTest.test ]


let _ = 
  print_endline "Testing";
  run_test_tt_main suite;

