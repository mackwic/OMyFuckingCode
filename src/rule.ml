
class rule =
object(this)
        val mutable binded = fun (c:char) -> c

        method virtual parse:char option ->char option
        method bind (obj:rule) = binded := fun c -> obj#parse (binded c)
end  

class rem_win_eol =
object(self) inherit rule
        method parse c = match c with
        | None -> None
        | Some c -> if c = '\r' then None else Some c
end


