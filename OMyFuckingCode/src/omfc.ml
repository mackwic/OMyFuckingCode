
let _ =
  (* Format_checker.moulinette "plop.c"; *)
  Config.init "omfc.config";
  print_endline (Config.show ());
