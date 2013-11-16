(** Definition of the components of a hadoop log file*)

open Batteries


type job = { jobId : string ; jobName : string ; nbMaps : int ;
	     nbReduces : int ; nbSpecTasks : int ;
	     nbNonLocalMaps : int ; nbSuccessLocalMapTasks : int;
	     nbSuccessNonLocalMapTasks : int ; 
	     nbSuccessSpecMaps : int ;
	     nbSuccessSpecReduces : int 
	   }

type typeTask = Normal | Speculated
type resultTask = Failed | Success

type mapTask = { jobId : string ;
		 mapId : string ;
		 mapAttemptId : string;
		 mapStartingTime : int ; (* Giving a well formated date is the task of the display ; see Date.t*)
		 mapFinishedTime : int ;
		 mapNbInputRecords : int;
		 mapNbOutputRecords : int;
		 mapHost : string ; 
		 mapDataDistribution : string list;
		 mapStatus : resultTask;
		 mapType : typeTask
	       }

type reduceTask = { jobId : string ;
		    reduceId : string ;
		    reduceAttemptId : string ;
		    reduceExecutionTime : int ;
		    reduceStartingTime : int ;
		    reduceShuffleTime : int ;
		    reduceSortTime : int ;
		    reduceFinishedTime : int;
		    reduceNbInputRecords : int;
		    reduceNbOutputRecords : int;
		    reduceShuffleBytes : int;
		    reduceInputGroups : int;
		    reduceBytesRead : int;
		    reduceHost : string ;
		    reduceStatus : resultTask;
		    reduceType : typeTask;
		  }

(* There is only one job in a log file ? *)
type logFile = LogFile of job * (string, mapTask) Hashtbl.t * (string, reduceTask) Hashtbl.t
		    
 (** Create the log file structure*)
  let make_logFile job mapHashTable reduceHashTable =
    LogFile(job, mapHashTable, reduceHashTable)

  let make_empty_job () =
    { jobId = "" ; jobName = "" ; nbMaps = 0 ;
	     nbReduces = 0 ; nbSpecTasks = 0 ;
	     nbNonLocalMaps = 0 ; nbSuccessLocalMapTasks = 0;
	     nbSuccessNonLocalMapTasks = 0 ; 
	     nbSuccessSpecMaps = 0 ;
	     nbSuccessSpecReduces = 0 
	   }

  (** Create an "empty" log file *)
  let make_empty_logFile () =
     make_logFile (make_empty_job ()) 
       (Hashtbl.create 100) (* Will be adjusted when reading info about the job *)
       (Hashtbl.create 10)

  let make_empty_mapTask () =
    { jobId = "" ;
      mapId = "" ; 
      mapAttemptId = "";
      mapStartingTime = 0 ; 
      mapFinishedTime = 0 ;
      mapNbInputRecords = 0;
      mapNbOutputRecords = 0;
      mapHost = "" ; 
      mapDataDistribution = [""];
      mapStatus = Success;
      mapType = Normal ;
    }

  let make_empty_reduceTask () =
    { jobId = "" ;
      reduceId = "" ;
      reduceAttemptId = "" ;
      reduceExecutionTime = 0 ;
      reduceStartingTime = 0 ;
      reduceShuffleTime = 0 ;
      reduceSortTime = 0 ;
      reduceFinishedTime = 0;
      reduceNbInputRecords = 0;
      reduceNbOutputRecords = 0;
      reduceShuffleBytes = 0;
      reduceInputGroups = 0;
      reduceBytesRead = 0;
      reduceHost = "" ;
      reduceStatus = Success;
      reduceType = Normal;
    }

  type tagLog = 
    | Job
    | Task
    | MapAttempt
    | ReduceAttempt
    | Meta
