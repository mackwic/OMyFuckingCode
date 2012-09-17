(**
  Usefull to print nice informations at the screen

  TODO
**)

let info ~file ?(line= -1) ~from mesg =
  if line = -1
  then BatPrintf.printf "[INFO] %s:[%s] %s\n" file from mesg
  else BatPrintf.printf "[INFO] %s:%d:[%s] %s\n" file line from mesg

let warning ~file ?(line= -1) ~from mesg =
  if line = -1
  then BatPrintf.printf "[WARN] %s:[%s] %s\n" file from mesg
  else BatPrintf.printf "[WARN] %s:%d:[%s] %s\n" file line from mesg

let error ~file ?(line= -1) ~from mesg =
  if line = -1
  then BatPrintf.printf "[ERROR] %s:[%s] %s\n" file from mesg
  else BatPrintf.printf "[ERROR] %s:%d:[%s] %s\n" file line from mesg

let debug ~file ?(line= -1) ~from mesg =
  if line = -1
  then BatPrintf.printf "[DEBUG] %s:[%s] %s\n" file from mesg
  else BatPrintf.printf "[DEBUG] %s:%d:[%s] %s\n" file line from mesg
