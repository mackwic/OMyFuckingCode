(* Source from https://github.com/superbobry/ocaml-configurator *)
(* version of Mar 09, 2012                                      *)

type expr = [ `Import of string
            | `Bind of (string * value)
            | `Group of (string * expr list)
            ]
and value = [ `Bool of bool
            | `Int of int
            | `Float of float
            | `String of string
            | `List of value list
            ]
