(**
  Handle all the configuration stuff
**)

let table = Hashtbl.create 101

let add path value = Hashtbl.add table path value

let get path_of_confVal alternative_value =
  if Hashtbl.mem table path_of_confVal then Hashtbl.find table path_of_confVal
  else alternative_value
(** meant to use an hashtable to get the value associated to path, but not now **)

let _ =
  begin
    Hashtbl.add table "plop" 4;
    ()
  end

