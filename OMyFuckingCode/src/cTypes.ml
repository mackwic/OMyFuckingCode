(**
  This file contains many usefull types for parsing the C files
**)

(* How you should use this file :                                                                                  *)
(* - Theses types are meant to be the different parts of C source code.                                            *)
(* - EVERYTHING IS A BLOCK. A Block can contains some other blocks that contains blocks...                         *)
(* - Blocks are STRONGLY typed, with polymorphims if we can.                                                       *)
(*   So we can waranty that the source file is coherent at compile time.                                           *)
(* and...                                                                                                          *)
(* - There is a lot of types... yeah I know. Sorry for that. Start reading from the bottom to the top can help     *)


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
(** alignement block of a line = (col_width * char_align)
    char_align is often space or tab
**)

type pos = (int*int)
(** position in the line = (col_start, col_end) **)

type lineBlock = {
  num : int;
  align : (pos * alignBlock);
  content : ((pos * contentBlock) list);
  }
(** A line is an height in the file (num),
    plus a part programer use to align with the previous line (align)
    the significant content himself containing instructions (content)
**)

type prepro_instr =
  | MacroCondition of i_dont_know_yet
  | MacroInclude of i_dont_know_yet
  | MacroVarDefinition of (name * string) (** (name * value) **)
  | MacroFuncDefinition of (name * string * string) (** (name * args * value) **)
(** A preprocessor instruction can be #ifdef and so, #include, or #define **)

type fileBlock =
  | BlockComment of string
  | BlockPreProcessor of prepro_instr
  | BlockCode of lineBlock list
(** Each BlockFile can be comment, preprocessor instruction, or a bunch of code **)

type block =
  | BlockFile of fileBlock list
(** A File block is the contener of a whole file, maybe usefull, maybe not...
    a BlockFile contains a list of generaly typed blocks **)

