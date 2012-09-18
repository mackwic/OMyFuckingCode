(**
  Many useful symbols for common use
**)

let (|>) f x = x f
let (|-) f g x = g (f x)

let toggle bool = not bool
