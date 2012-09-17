/* Source from https://github.com/superbobry/ocaml-configurator
 * version of Mar 09, 2012
 */

%token EOL EOF
%token IMPORT
%token TRUE FALSE
%token EQUALS
%token COMMA
%token LBRACKET RBRACKET LBRACE RBRACE
%token <int> INT
%token <string> IDENT
%token <string> STRING
%token <float> FLOAT

%start main
%type <Types.expr list> main

%%

main:
  | expr_list EOF {List.rev $1}
;

expr_list:
  | expr_list expr {$2 :: $1}
  |                {[]}
;

expr:
  | IMPORT STRING      {`Import $2}
  | IDENT EQUALS value {`Bind  ($1, $3)}
  | IDENT LBRACE expr_list RBRACE {`Group ($1, $3)}
;

value_list:
  | value_list COMMA value {$3 :: $1}
  | value                  {[$1]}
  |                        {[]}
;

value:
  | TRUE   {`Bool true}
  | FALSE  {`Bool false}
  | INT    {`Int  $1}
  | STRING {`String $1}
  | FLOAT  {`Float $1}
  | LBRACKET value_list RBRACKET {`List (List.rev $2)}
;

%%
