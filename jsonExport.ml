(** Json exporter

Json :

{
  "job" : {
    "jobid" : _
    ...
  },
  "maps" : [
    {
    },
    ...
  ]
  ,
  "reduces" : [
  ]
  
}

*)

open Yojson.Basic
open LogTypes


(** job -> object "job" in json *)
let jobToJson (job : job) =
  `Assoc [("jobid", `String job.jobId);
	  ("jobname", `String job.jobName);
	  ("nbmaps", `Int job.nbMaps);
	  ("nbreduces", `Int job.nbReduces);
	  ("nbspectasks", `Int job.nbSpecTasks);
	  ("nbnonlocalmaps", `Int job.nbNonLocalMaps);
	  ("nbsuccesslocalmaptasks", `Int job.nbSuccessNonLocalMapTasks);
	  ("nbsuccessnonlocalmaptasks", `Int job.nbSuccessLocalMapTasks);
	  ("nbsuccessspecmaps", `Int job.nbSuccessSpecMaps);
	  ("nbsuccessspecreduces", `Int job.nbSuccessSpecReduces)
	 ]

(** Take a logFile in input and output the json*)
let logFileToJson logFile =
  let (job, _, _) = logFile in
  `Assoc [("job", (jobToJson job))]
