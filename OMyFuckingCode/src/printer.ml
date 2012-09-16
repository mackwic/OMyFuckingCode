(**
  Usefull to print nice informations at the screen

  TODO
**)

let info ~from mesg =
  BatPrintf.printf "[%s] %s\n" from mesg

let warning = info
let error = info
let log = info
let debug = info