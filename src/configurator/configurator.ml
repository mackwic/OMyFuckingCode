open StdLabels

module Config = struct
  include Map.Make(String)

  let merge =
    let f _key v1 v2 = match (v1, v2) with
      | (None, _) -> v2
      | (_, _)    -> v1
    in merge f
end

type value = Types.value
type t = value Config.t


(* +----------+
   | Internal |
   +----------+ *)
let flip2 f z = fun x y -> f x y z

let rec handle_expr prefix = function
  | `Import fn           -> Config.merge (of_file fn)
  | `Group (name, exprs) ->
      Config.merge (handle_exprs (prefix ^ name ^ ".") exprs)
  | `Bind (key, value)   -> Config.add (prefix ^ key) value

and handle_exprs prefix =
  List.fold_right ~f:(handle_expr prefix) ~init:Config.empty

and string_of_value = function
  | `Bool true  -> "true"
  | `Bool false -> "false"
  | `Int n      -> string_of_int n
  | `Float f    -> string_of_float f
  | `String s   -> s
  | `List vs    ->
      "[" ^ (String.concat ~sep:"," (List.map ~f:string_of_value vs)) ^ "]"

(* +------------+
   | Public API |
   +------------+ *)

and of_file fn =
  let ic = open_in fn in
  let exprs =
    try
      let lexbuf = Lexing.from_channel ic in
      let exprs  = Parser.main Lexer.token lexbuf in
      close_in ic;
      exprs
    with exn ->
      close_in ic;
      raise exn
  in handle_exprs "" exprs

and of_files fns =
  let cfgs = List.map ~f:of_file fns in
  List.fold_right ~f:Config.merge ~init:Config.empty cfgs


and show cfg =
  let bindings = Config.bindings cfg in
  let lines    = List.map
    ~f:(fun (key, value) -> key ^ ": " ^ (string_of_value value))
    bindings
  in String.concat ~sep:"\n" lines


let get cfg key f =
  try
    f (Config.find key cfg)
  with Not_found -> None

let bool   = flip2 get (function `Bool b   -> Some b | _ -> None)
and int    = flip2 get (function `Int n    -> Some n | _ -> None)
and float  = flip2 get (function `Float f  -> Some f | _ -> None)
and string = flip2 get (function `String s -> Some s | _ -> None)
and list cfg key f =
  let vs = get cfg key (function
    | `List vs -> Some (List.map ~f vs)
    | _        -> None)
  in match vs with
    | Some vs ->
        List.fold_left
          ~f:(fun acc -> function Some v -> v :: acc | None -> acc)
          ~init:[]
          vs
    | None    -> []
