(* Source from https://github.com/superbobry/ocaml-configurator *)
(* version of Mar 09, 2012                                      *)

{
  open Parser

  let keywords = Hashtbl.create 1
  let () = List.iter (fun (kwd, token) -> Hashtbl.add keywords kwd token) [
    ("import", IMPORT);
  ]
}

rule token = parse
  | [' ' '\t' '\r' '\n'] | '#' [^'\n']* {token lexbuf}
  | '=' { EQUALS }
  | ',' { COMMA }
  | '[' { LBRACKET }
  | ']' { RBRACKET }
  | '{' { LBRACE }
  | '}' { RBRACE }
  | "yes" | "on" | "true" { TRUE }
  | "no" | "off" | "false" { FALSE }
  | ['0'-'9']+
      {INT(int_of_string(Lexing.lexeme lexbuf))}
  | ['0'-'9'] ['0'-'9']*
      ('.' ['0'-'9']*)?
      (['e' 'E'] ['+' '-']? ['0'-'9'] ['0'-'9']*)?
      {FLOAT(float_of_string(Lexing.lexeme lexbuf))}
  | ['A'-'Z' 'a'-'z']['A'-'Z' 'a'-'z' '0'-'9' '-' '_']*
      {
        let lxm = String.lowercase (Lexing.lexeme lexbuf) in
        try
          Hashtbl.find keywords lxm
        with Not_found -> IDENT(lxm)
      }
  | '"' ([^'"']+ as lxm) '"' {STRING(lxm)}
  | eof {EOF}
