(* Source from https://github.com/superbobry/ocaml-configurator *)
(* version of Mar 09, 2012                                      *)

type t
type value = Types.value

val of_file  : string -> t
val of_files : string list -> t

val show : t -> string

val get    : t -> string -> (value -> 'a option) -> 'a option
val bool   : t -> string -> bool option
val int    : t -> string -> int option
val float  : t -> string -> float option
val string : t -> string -> string option
val list   : t -> string -> (value -> 'a option) -> 'a list
