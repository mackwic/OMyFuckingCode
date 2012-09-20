
(**
 * RULES, all the stuff thats matter
 *
 * HOW TO MAKE A RULE:
 * - inherit from rule
 * - set the name
 *      + NAMING CONVENTION : <name>_<suffix>
 *      + Suffix stands for the scope of the rules, different suffixes:
 *              + c for all coding rules
 *              + p for preprocessor specific rule
 *              + f for function specific rules
 *              + d for declaration specific rules
 *      + Of course you can add them together.
 *      + Example: col80_c for the 80-width rule applied for all lines
 *      + or upcaseMacroCheck_pd for a rule checking that all the preprocessor
 *      + macro are upcased
 *
 * - set the priority
 *      + priority is used to order the differents rules
 *      + priority is an int between -1000 and 1000, 0 if it doesn't matter
 *
 * - code the parser method
 *      + This is the method that handle the stream. You know what to do
 *      + You can use the values cur_line and cur_char to know the position of
 *      + the cursor
 *      + To handle errors, I suggest you to use the functions I defined just after
 *      + BE CARREFUL TO ALWAYS RETURN SOMETHING (None, or Some c)
 *
 *)

(* message printing convenience *)
let error obj msg = Printer.error ~line:obj#line ~from:obj#name msg
let warning obj msg = Printer.warning ~line:obj#line ~from:obj#name msg
let info obj msg = Printer.info ~line:obj#line ~from:obj#name msg
let debug obj msg = Printer.debug ~line:obj#line ~from:obj#name msg

(* string comparison convenience *)
let is_in str c i = str.(i) = i

class rule =
object(this)
  val mutable cur_line = 1
  val mutable cur_char = 1

  val mutable binded = fun c -> match c with
    | '\n' -> cur_line <- cur_line + 1;
        cur_char <- 0;
        this#parse '\n'
    | c -> cur_char <- cur_char + 1; this#parse c

  val mutable keeped = BatRope.empty

  method keep c = keeped <- BatRope.append keeped c
  method release = Some (BatRope.shift keeped)

  method virtual parse: (char option) -> (char option)
  method virtual name: string
  method virtual priority: int
  method virtual print_err:unit -> unit

  method bind (obj:rule) = binded <-
    fun c -> obj#parse (binded c)

  method line = self#cur_line
end

(* maybe you need only few chars of the beginning of the line... *)
class start_line_rule =
object(self) inherit rule
  val len = List.length chars
  val virtual chars: char list

  val mutable wait = true

  method skip_line c = if c != '\n' then Some c else wait <- false; Some '\n'

  method parse c = function
          | None -> None
          | Some c -> if wait then skip_line c else apply c

  method virtual apply: char -> char option
  >


(* maybe you need the whole line... *)
class line_rule rule =
object(self) inherit rule
  val rule = rule
  val mutable pending = BatRope.empty

  method apply = append '\n';
          if rule (BatRope.to_string pending) then self#print_err
          else ();
          keeped <- BatRope.append keeped pending;
          pending <- BatRope.empty

  method append c = pending <- BatRope.append pending (UChar.of_char c)

  method parse = function
          | None -> self#release
          | Some c when c = '\n' -> self#apply; self#release
          | Some c -> self#append c; self#release
>


(* /!\ a placer en dernier *)
let col_80 = <object(self) inherit rule
                     val count = ref 0
                     method name = "col80_all"
                     method priority = -1000

                     method parse c = match c with
                       | None -> None
                       | Some c when c = '\n' -> (
                         if !count > 80 then error self "Line too large" else ();
                         count := 0;
                         Some '\n')
                       | Some c -> incr count; c
          >

let windowsEOL_c = <object(self) inherit rule
                           method name = "windowsEOL_c"
                           method priority = -1
                           method parse = function
                             | None -> None
                             | Some c -> if c = '\r' then error self "Windows EOL";
                                 None
                                 >

let identity = <object(this) inherit rule
                       method name = "identity_c"
                       method priority = 0
                       method parse c = c
                              >

let macroCheckName_p = <object(self) inherit line_rule (fun l ->
        Regex.match "^#define .*" l
        && not (Regex.match "^#define [A-Z][A-Z_]*[ (]"))
                              method name = "macroCheckName_all"
                              method priority = 10
                                    >

let macroCheckArgs_p =
        let reg1 = Str.regexp "^#define [A-Z][A-Z_]*[ (]"
        and reg2 = Str.regexp "^#define [A-Z][A-Z_]*[ (]([A-Z][a-z]*,?)+)"
        in
        let func = fun line -> (Str.string_match reg1 line 0)
                                && not (Str.string_match reg2 line 0)
        in
        <object(self) inherit line_rule func
                method name = "macroCheckArgs_p"
                method priority = 5
                        >
