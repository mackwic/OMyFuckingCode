(**
  Handle all the configuration stuff
**)

open Common

let table = Hashtbl.create 101
(** used for runtime configuration *)

let conf = ref (Obj.magic None)
(** used from .config file *)

let init config_file = conf := Configurator.of_file config_file
let show () = Configurator.show !conf
(** debug facility *)

let add path value = Hashtbl.add table path value
(** store only strings *)

let mem = Hashtbl.mem table
let find = Hashtbl.find table

let int ~path ~default =
  match Configurator.int !conf path with
  | Some i -> i
  | None -> if mem path
            then find path |> int_of_string else default

let float ~path ~default =
  match Configurator.float !conf path with
  | Some f -> f
  | None -> if mem path
            then find path |> float_of_string else default

let string ~path ~default =
  match Configurator.string !conf path with
  | Some s -> s
  | None -> if mem path
            then find path else default

let bool ~path ~default =
  match Configurator.bool !conf path with
  | Some b -> b
  | None -> if mem path
            then find path |> bool_of_string else default

let custom ~path ~f ~default =
  match Configurator.string !conf path with
  | Some s -> f s
  | None -> if mem path
            then find path |> f else default
