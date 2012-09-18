(**
  Config.mli handle runtime configuration of the application
*)

val init : string -> unit
(** internal, do not use **)

val show : unit -> string
(** Print the whole configuration tree, for debug purpose *)

val add : string -> string -> unit
(** Add a pair (key,value) in the configuration tree *)

val int : path:string -> default:int -> int
(** Get an int from the configuration *)

val float : path:string -> default:float -> float
(** Get a float from the configuration *)

val string : path:string -> default:string -> string
(** Get a string from the configuration *)

val bool : path:string -> default:bool -> bool
(** Get a bool from the configuration *)

val custom : path:string -> f:(string -> 'a) -> default:'a -> 'a
(** Get a custom value parsed with [f] *)