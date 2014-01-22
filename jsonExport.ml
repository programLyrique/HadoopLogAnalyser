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
open Batteries
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

(* TODO : remove prefix map or reduce in name of fields*)

(** map to json*)
let mapToJson (map : mapTask) =
  `Assoc [("jobid", `String map.jobId);
	  ("id", `String map.mapId);
	  ("attemptid", `String map.mapAttemptId);
	  ("startingtime", `Int map.mapStartingTime);
	  ("finishedtime", `Int map.mapFinishedTime);
	  ("nbinputrecords", `Int map.mapNbInputRecords);
	  ("nboutputrecords", `Int map.mapNbOutputRecords);
	  ("host", `String map.mapHost);
	  ("datadistribution", 
	   `List (List.map (fun a -> `String a)  map.mapDataDistribution));
	  ("status", `String (Utils.status_pretty_printer map.mapStatus));
	  ("type", 
	   `String ((function Normal -> "normal" |  Speculated -> "speculated") 
	     map.mapType))
	 ]

(** reduce to json*)
let reduceToJson (reduce : reduceTask) =
  `Assoc [("jobid", `String reduce.jobId);
	  ("id", `String reduce.reduceId);
	  ("attemptid", `String reduce.reduceAttemptId);
	  ("executiontime", `Int reduce.reduceExecutionTime);
	  ("startingtime", `Int reduce.reduceStartingTime);
	  ("shuffletime", `Int reduce.reduceShuffleTime);
	  ("sorttime", `Int reduce.reduceSortTime);
	  ("finishedtime", `Int reduce.reduceFinishedTime);
	  ("nbinputrecords", `Int reduce.reduceNbInputRecords);
	  ("nboutputrecords", `Int reduce.reduceNbOutputRecords);
	  ("shufflebytes", `Int reduce. reduceShuffleBytes);
	  ("inputgroups", `Int reduce.reduceInputGroups);
	  ("bytesread", `Int reduce.reduceBytesRead);
	  ("host", `String reduce.reduceHost);
	  ("status", `String (Utils.status_pretty_printer reduce.reduceStatus));
	  ("type", 
	   `String ((function Normal -> "normal" |  Speculated -> "speculated") 
	     reduce.reduceType))
	 ]

(* TODO : factorize the 3 following functions *)

(** convert all maps from the hashtable into a json array of maps*)
let mapsToJson (mapHashTable : (string, mapTask) Hashtbl.t) =
  `List (Hashtbl.fold (fun id map l -> (mapToJson map)::l) mapHashTable [])

(** convert all reduces from the hashtable into a json array of reduces*)
let reducesToJson (reduceHashTable : (string, reduceTask) Hashtbl.t) =
  `List (Hashtbl.fold (fun id reduce l -> (reduceToJson reduce)::l) reduceHashTable [])


(** Take a logFile in input and output the json*)
let logFileToJson  logF =
  let LogFile(job, mapHashTable, reduceHashTable) = logF in
  `Assoc [("job", (jobToJson job));
	  ("maps", (mapsToJson mapHashTable));
	  ("reduces", (reducesToJson reduceHashTable))
	 ]
