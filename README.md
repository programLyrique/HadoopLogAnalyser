Hadoop Log Visualiser
====================

A tool to parse hadoop log files.

## Dependencies

- ocaml
- batteries included
- ocamllex
- menhir
- yojson

## Compilation

 * `make` : build *hadoopLogVisual*
 * `grammar` : launch an interactive interpreter which takes tokens in input and checks whether there valid tokens of a Hadoop log file grammar
* `tests` : unit tests


## Usage

### Output a formated json

     hadoopLogVisual logFile

### Output tokens 

     hadoopLogVisual logFile d

