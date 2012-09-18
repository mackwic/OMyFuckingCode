
class rule =
object(this)
        val mutable cur_line = 1
        val mutable cur_char = 0

        val mutable binded = fun c -> match c with
                | '\n' -> cur_line <- cur_line + 1;
                          cur_char <- 0;
                          this#parse '\n'
                | c -> cur_char <- cur_char + 1; this#parse c

        method virtual parse: (char option) -> (char option)
        method bind (obj:rule) = binded <-
                fun c -> obj#parse (binded c)
end


(* /!\ a placer en dernier si reecriture du flux *)
let col_80 = <object inherit rule
        val count = ref 0

        method parse c = match c with
        | None -> None
        | Some c when c = '\n' -> (
                if !count > 80 then (* print error; *) c else c;
                count := 0;
                '\n')
        | Some c -> incr count; c 
        >


let plop = <object inherit rule
       method parse c = c
       >
