Hadoop Log Visualiser
====================

A tool to parse hadoop log files.

## Dependencies

- ocaml (>= 4.0 )
- batteries included (>= 2.1)
- ocamllex
- menhir (>= 20130116)
- yojson (>= 1.18)

## Compilation

 * `make` : build *hadoopLogVisual*
 * `make grammar` : launch an interactive interpreter which takes tokens in input and checks whether there valid tokens of a Hadoop log file grammar
 * `make tests` : unit tests


## Usage

### Output a formated json

     hadoopLogVisual logFile

### Output tokens 

     hadoopLogVisual logFile d

