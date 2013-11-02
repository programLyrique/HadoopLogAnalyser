(** Definition of the components of a hadoop log file*)

open Batteries

type job = { jobId : int ; jobName : string ; nbMaps : int ;
	     nbReduces : int ; nbSpecTasks : int ;
	     nbNonLocalMaps : int ; nbSuccessLocalMapTasks : int;
	     nbSuccessNonLocalMapTasks : int ; 
	     nbSuccessSpecMaps : int ;
	     nbSuccessSpecReduces : int 
	   }

type typeTask = Normal | Speculated
type resultTask = Failed | Success

type mapTask = { mapId : int ; mapStartingTime : Date.t ;
		 mapFinishedTime : Date.t ;
		 mapNbInputRecords : int;
		 mapNbOutputRecords : int;
		 mapHost : string ; 
		 mapDataDistribution : string list;
		 mapStatus : resultTask;
		 mapType : typeTask
	       }

(* Date.t is also a duration *)
type reduceTask = { reduceId : int ; reduceExecutionTime : Date.t ;
		    reduceStartingTime : Date.t ;
		    reduceShuffleTime : Date.t ;
		    reduceSortTime : Date.t ;
		    reduceFinishedTime : Date.t;
		    reduceNbInputRecords : int;
		    reduceNbOutputRecords : int;
		    reduceShuffleBytes : int;
		    reduceInputGroups : int;
		    reduceBytesRead : int;
		    reduceHost : string ;
		    reduceStatus : resultTask;
		    reduceType : typeTask;
		  }
		    
