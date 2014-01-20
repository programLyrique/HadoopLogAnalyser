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
	  ("mapid", `String map.mapId);
	  ("mapattemptid", `String map.mapAttemptId);
	  ("mapstartingtime", `Int map.mapStartingTime);
	  ("mapfinishedtime", `Int map.mapFinishedTime);
	  ("mapnbinputrecords", `Int map.mapNbInputRecords);
	  ("mapnboutputrecords", `Int map.mapNbOutputRecords);
	  ("maphost", `String map.mapHost);
	  ("mapdatadistribution", 
	   `List (List.map (fun a -> `String a)  map.mapDataDistribution));
	  ("mapstatus", `String (Utils.status_pretty_printer map.mapStatus));
	  ("maptype", 
	   `String ((function Normal -> "normal" |  Speculated -> "speculated") 
	     map.mapType))
	 ]

(** reduce to json*)
let reduceToJson (reduce : reduceTask) =
  `Assoc [("jobid", `String reduce.jobId);
	  ("reduceid", `String reduce.reduceId);
	  ("reduceattemptid", `String reduce.reduceAttemptId);
	  ("reduceexecutiontime", `Int reduce.reduceExecutionTime);
	  ("reducestartingtime", `Int reduce.reduceStartingTime);
	  ("reduceshuffletime", `Int reduce.reduceShuffleTime);
	  ("reducesorttime", `Int reduce.reduceSortTime);
	  ("reducefinishedtime", `Int reduce.reduceFinishedTime);
	  ("reducenbinputrecords", `Int reduce.reduceNbInputRecords);
	  ("reducenboutputrecords", `Int reduce.reduceNbOutputRecords);
	  ("reduceshufflebytes", `Int reduce. reduceShuffleBytes);
	  ("reduceinputgroups", `Int reduce.reduceInputGroups);
	  ("reducebytesread", `Int reduce.reduceBytesRead);
	  ("reducehost", `String reduce.reduceHost);
	  ("reducestatus", `String (Utils.status_pretty_printer reduce.reduceStatus));
	  ("reducetype", 
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
