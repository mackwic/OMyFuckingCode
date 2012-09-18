open Common

let conf_file = ref "omfc.config"
let set_conf_file f = conf_file := f
let show_confdb_and_quit () =
  Config.init !conf_file;
  print_endline (Config.show ());
  exit 0

let options = [
  ( "-c", (Arg.String set_conf_file), "choose the config file");
  ("-show-conf", (Arg.Unit show_confdb_and_quit), "show the config database and quit");
  ]

let usageMsg = "OMyFuckingCode is a C code checker"

let _ =
  Arg.parse options (fun s -> ()) (Arg.usage_string options usageMsg)
  (* Format_checker.moulinette "plop.c"; *)
  (* Config.init "omfc.config";     *)
  (* print_endline (Config.show ()) *)
