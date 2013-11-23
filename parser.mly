(** Parsing. 
@see lexer.mll *)

%{
  open LogTypes


%}

%token Token_EOP

%token <int> Token_Number

%token <string> Token_Word Token_Ident

%token <LogTypes.tagLog> Token_Tag 

%token <LogTypes.taskType> Token_Task

%token Token_Equal Token_Dot Token_Quote (* Detect quotes directly during lexical analysis ?*)

%token  Token_JobId Token_JobName

%token Token_LaunchTime Token_TotalMaps Token_TotalReduces

%token  Token_TaskId Token_TaskType Token_TaskAttemptId

%token Token_StartTime Token_Splits 
(*%token Token_Map Token_Reduce Token_Setup Token_Cleanup*)

%token  Token_FinishTime Token_HostName
%token Token_TaskStatus  Token_Counters
(*%token Token_StateString*)
%token <LogTypes.resultTask> Token_Status

(*%token  Token_Success Token_Killed*)


%start <LogTypes.logFile> make_logfile

%%

(* To be able to use inherited attributes in this LR grammar, we
use functions as nodes of the tree *)

make_logfile:
   res = logfile2 Token_EOP {  res (make_empty_logFile ())} (* We apply the resulting function tree on an empty "log file " *)

(* Read all the lines of the log file *)
logfile2:
  | f1 = logfile2  f2 = logfile  {fun logFile -> f2 (f1 logFile) }
  | f = logfile { fun logFile -> f logFile }

(* A line of a lof file *)
logfile:
   tag = Token_Tag  info = informations Token_Dot
    {
      fun logFile -> info tag logFile
    }

(* Parametrized rule  *)
property(Name):
  | Name Token_Equal Token_Quote x = Token_Word Token_Quote { x }

numProperty(Name):
  | Name Token_Equal Token_Quote x = Token_Number Token_Quote { x }

emptyProperty:
  | Token_Word Token_Equal Token_Quote Token_Word Token_Quote {}

numEmptyProperty:
  | Token_Word Token_Equal Token_Quote Token_Number Token_Quote {}

taskProperty:
  | Token_TaskType Token_Equal Token_Quote x = Token_Task Token_Quote { x }

statusProperty:
  | Token_TaskStatus Token_Equal Token_Quote x = Token_Status Token_Quote {x}

informations:
  (* After a Meta tag *)
  | numEmptyProperty { fun  tag logFile -> logFile } (* No information to add *)
  (* After a Job tag  : general info*)
  | id = property(Token_JobId) (*Token_JobId Token_Equal Token_Quote id = Token_Word Token_Quote*) 
    name = property(Token_JobName) (*Token_JobName Token_Equal Token_Quote name = Token_Word Token_Quote*)
    emptyProperty (*Token_Word Token_Equal Token_Quote Token_Word Token_Quote*)
    numEmptyProperty (* SUBMIT_TIME *)
    emptyProperty 
    emptyProperty
    emptyProperty
    emptyProperty 
    {
      fun  tag (LogFile(job, mapHashTable, reduceHashTable)) -> 
	LogFile({jobId = id ;
	  jobName = name;
	  nbMaps = job.nbMaps;
	  nbReduces = job.nbReduces ;
	  nbSpecTasks = job.nbSpecTasks;
	  nbNonLocalMaps = job.nbNonLocalMaps;
	  nbSuccessLocalMapTasks = job.nbSuccessLocalMapTasks;
	  nbSuccessNonLocalMapTasks = job.nbSuccessNonLocalMapTasks ; 
	  nbSuccessSpecMaps = job.nbSuccessSpecMaps ;
	  nbSuccessSpecReduces =  job.nbSuccessSpecReduces},
	 mapHashTable,
	 reduceHashTable)
    }
  (* Info about priority of the job *)
  | property(Token_JobId) (*Token_JobId Token_Equal Token_Quote id = Token_Word Token_Quote*)
    emptyProperty (*Token_Word Token_Equal Token_Quote Token_Word Token_Quote*)
    {
      fun tag logFile -> logFile (* don't do anything *)
    }
    (* Info about launch time and number of tasks *)
  | id = property(Token_JobId) (*Token_JobId Token_Equal Token_Quote id = Token_Word Token_Quote*)
    launchTime = numProperty(Token_LaunchTime) (* Token_LaunchTime Token_Equal Token_Quote launchTime = Token_Number Token_Quote*)
    nbTotalMaps = numProperty(Token_TotalMaps)
    nbTotalReduces = numProperty(Token_TotalReduces)
    emptyProperty (* JobStatus *)
    {
     fun  tag (LogFile(job, mapHashTable, reduceHashTable)) -> 
       LogFile({jobId = id ; (* Verify whether it is the same id *)
		jobName = job.jobName;
		nbMaps = nbTotalMaps;
		nbReduces = nbTotalReduces ;
		nbSpecTasks = job.nbSpecTasks;
		nbNonLocalMaps = job.nbNonLocalMaps;
		nbSuccessLocalMapTasks = job.nbSuccessLocalMapTasks;
		nbSuccessNonLocalMapTasks = job.nbSuccessNonLocalMapTasks ; 
		nbSuccessSpecMaps = job.nbSuccessSpecMaps ;
		nbSuccessSpecReduces =  job.nbSuccessSpecReduces},
	       mapHashTable,
	       reduceHashTable)
    }
  | id = property(Token_TaskId) (*Token_TaskId Token_Equal  Token_Quote id = Token_Word Token_Quote *)
    taskType = taskProperty (*Token_TaskType Token_Equal Token_Quote taskType = Token_Task Token_Quote*)
    startTime = numProperty(Token_StartTime) (*Token_StartTime Token_Equal Token_Quote startTime = Token_Number Token_Quote*)
    place = property(Token_Splits) 
    {
      (*fun tag (LogFile(job, mapHashTable, reduceHashTable)) -> 
	if tag <> Task 
	then logFile
	else 
	LogFile(job,
	{ jobId = job.jobId ;
	mapId = id ; 
	mapStartingTime =  ; 
	mapFinishedTime : int ;
	mapNbInputRecords : int;
	mapNbOutputRecords : int;
	mapHost : string ; 
	mapDataDistribution : string list;
	mapStatus : resultTask;
	mapType : typeTask
	}*)
      (* Does nothing ; the interesting information for us are  *Attempt*)
      fun tag logFile -> logFile
    }
  (* For map and reduce attempts*)
  | taskProperty (* Token_TaskType Token_Equal Token_Quote x = Token_Task Token_Quote*)
    taskId = property(Token_TaskId)
    taskAttemptId = property(Token_TaskAttemptId)
    startTime = numProperty(Token_StartTime)
    emptyProperty (* Tracker name *)
    numEmptyProperty (* HTTP port *)
    {
      fun tag (LogFile(job, mapHashTable, reduceHashTable)) -> 
	match tag with
	  | MapAttempt ->  let mapTask = BatHashtbl.find_default mapHashTable taskAttemptId (make_empty_mapTask ()) in
			   BatHashtbl.replace mapHashTable taskAttemptId  
			     { jobId = job.jobId ;
			       mapId = taskId ; 
			       mapAttemptId = taskAttemptId;
			       mapStartingTime = startTime ; 
			       mapFinishedTime =  mapTask.mapFinishedTime;
			       mapNbInputRecords = mapTask.mapNbInputRecords;
			       mapNbOutputRecords = mapTask.mapNbOutputRecords;
			       mapHost = mapTask.mapHost ; 
			       mapDataDistribution = mapTask.mapDataDistribution;
			       mapStatus = mapTask.mapStatus;
			       mapType = mapTask.mapType; (* Normal or speculated ? *)
			     };
			   LogFile(job, mapHashTable,  reduceHashTable)	
	  | ReduceAttempt -> let reduceTask = BatHashtbl.find_default reduceHashTable taskAttemptId (make_empty_reduceTask ()) in
			     BatHashtbl.replace reduceHashTable taskAttemptId 
			       { jobId = job.jobId ;
				 reduceId = taskId ;
				 reduceAttemptId = taskAttemptId ;
				 reduceExecutionTime = reduceTask.reduceExecutionTime ;
				 reduceStartingTime = startTime ;
				 reduceShuffleTime = reduceTask.reduceShuffleTime ;
				 reduceSortTime = reduceTask.reduceSortTime ;
				 reduceFinishedTime = reduceTask.reduceFinishedTime;
				 reduceNbInputRecords = reduceTask.reduceNbInputRecords;
				 reduceNbOutputRecords = reduceTask.reduceNbOutputRecords;
				 reduceShuffleBytes = reduceTask.reduceShuffleBytes;
				 reduceInputGroups = reduceTask.reduceInputGroups;
				 reduceBytesRead = reduceTask.reduceBytesRead;
				 reduceHost = reduceTask.reduceHost ;
				 reduceStatus = reduceTask.reduceStatus;
				 reduceType = reduceTask.reduceType;
			       };
			     LogFile(job, mapHashTable, reduceHashTable)
	  | _ -> failwith "Invalid task"       
    }
  (* Finish time of MapAttempt etc *)
  | taskProperty
    taskId = property(Token_TaskId)
    taskAttemptId = property(Token_TaskAttemptId)
    status = statusProperty
    finishTime = numProperty(Token_FinishTime)
    hostname = property(Token_HostName)
    emptyProperty (*STATE_STRING *)
    emptyProperty (* COUNTERS : TODO parse counters *)
    {
      fun tag (LogFile(job, mapHashTable, reduceHashTable)) -> 
	match tag with
	  | MapAttempt ->  let mapTask = BatHashtbl.find_default mapHashTable taskAttemptId (make_empty_mapTask ()) in
			   BatHashtbl.replace mapHashTable taskAttemptId  
			     { jobId = job.jobId ;
			       mapId = taskId ; (* Do some verification ? *)
			       mapAttemptId = taskAttemptId;
			       mapStartingTime = mapTask.mapStartingTime ; 
			       mapFinishedTime =  finishTime;
			       mapNbInputRecords = mapTask.mapNbInputRecords; (* from counters *)
			       mapNbOutputRecords = mapTask.mapNbOutputRecords;
			       mapHost = hostname ; 
			       mapDataDistribution = mapTask.mapDataDistribution;
			       mapStatus = status;
			       mapType = mapTask.mapType;
			     };
			   LogFile(job, mapHashTable,  reduceHashTable)	
	  | _ -> failwith "Invalid task"  (* Reduce attempts have other options (such as shuffle time *)

    }
				    
      

