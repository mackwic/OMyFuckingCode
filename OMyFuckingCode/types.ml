(**
  This file contains many usefull types for parsing the C files
**)

open WIP
open Common

(* these types are only usefull to improve readability *)
type name = string
type label = string
type unparsed_value = string
type width = int
type height = int
type lenght = int
type count = int
type void = unit


(* significant types follow *)

type t_type = i_dont_know_yet

type 'a t_condition = i_dont_know_yet

type 'return_type t_call = (string_or_something * string_or_something list * 'return_type)
(** (function_name * args) **)

type unaryOp = Incr | Decr | Add_unary | Sub_unary | Div_unary | Mul_unary | Mod_unary

type binaryOp = Add | Sub | Div | Mul | Mod

type 'return_type t_operation =
  | UnaryOp of (string_but_more_specific_in_the_future * unaryOp * unparsed_value * 'return_type)
  (** (variable_name * operator * argument_value * return_type) **)
  | BinaryOp of (string_but_more_specific_in_the_future * binaryOp * unparsed_value * unparsed_value * 'return_type)
  (** (variable_name * operator * arg1 * arg2) **)

type 'return_type instrBlock =
  | Condition of 'return_type t_condition
  | Operation of 'return_type t_operation
  | Call of 'return_type t_call
  | Value of 'return_type

type 'val_type declBlock = {
  type_decl : t_type;
  name : string_but_more_specific_in_the_future;
  value : 'val_type;
  isConst : bool;
  }

type contentBlock =
  | BlockInstruction of void instrBlock
  | BlockInlineComment of string
  | BlockDeclaration of void declBlock

type alignBlock = (width * char)
(** bloc d'aignement d'une ligne = (largeur_en_col * char_d_align **)

type eol_type = LF | CR | CRLF | Other of (char list)

type pos = (int*int)
(** position in the line = (col_start, col_end) **)

type lineBlock = {
  num : int;
  align : (pos * alignBlock);
  content : ((pos * contentBlock) list);
  eol : eol_type
  }

type prepro_instr = string_or_something

type fileBlock =
  | BlockComment of string
  | BlockPreProcessor of prepro_instr
  | BlockCode of lineBlock list

type block =
  | BlockFile of fileBlock list
