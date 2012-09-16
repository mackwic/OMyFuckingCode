(**
Format_checker is a sort of preprocess - moulinette

It ONLY looks at FORMATTING things

Its goal is to:
* Ensure that all the lines are 80 columns max (if not... eeeer we'll see :)
* Ensure that there is never more than 25 lines between a {} pair
* Ensure that the file is not too long (set by config, skipped if not)
**)
open BatFile
open Common
  
type line_nb = int

type format_error =
  | Line_too_wide of (line_nb * int)
  | Scope_too_large of (line_nb * int)
  | File_too_long of int

let file = ref ""

let print_error error =
  let line_ref = ref (-1) in
  let err_msg =
    match error with
    | Line_too_wide (line, width) -> line_ref := line;
        BatPrintf.sprintf "Line %d is too wide (is %d width)" line width
    | Scope_too_large (line, width) -> line_ref := line;
        BatPrintf.sprintf
          "Scope ending at line %d is too large (is %d lines large)" line
          width
    | File_too_long length ->
        BatPrintf.sprintf "File is too long (is %d lines long)" length
  in Printer.error ~line:(!line_ref) ~file:!file ~from: "First_run" err_msg
  
let process input =
  let col_count = ref 0 and max_col_count = Config.int "rules.format.max_column" 80

  and scope_count = ref 0
  and max_scope_count = Config.int "rules.format.max_function_size" 25
  and line_count = ref 1

  and max_line_count = Config.int "rules.format.max_file_size" 250 in
  let rec processs input depth_scope is_string =
    match BatInnerIO.read input with
    | '\n' ->
        (if !col_count > max_col_count
         then print_error (Line_too_wide (!line_count, !col_count))
         else ();
         col_count := 0;
         incr line_count;
         if depth_scope > 0 then incr scope_count else ();
         processs input depth_scope is_string)
    | '{' ->
        (incr col_count;
         processs input (depth_scope + (if is_string then 0 else 1)) is_string)
    | '}' ->
        (incr col_count;
         if (depth_scope = 1) || (not is_string)
         then
           (if !scope_count > max_scope_count
            then print_error (Scope_too_large (!line_count, !scope_count))
            else ();
            scope_count := 0)
         else ();
         processs input (depth_scope - (if is_string then 0 else 1)) is_string)
    | '"' -> (incr col_count; processs input depth_scope (toggle is_string))
    | _ -> (incr col_count; processs input depth_scope is_string)
  in
    try processs input 0 false
    with
    | BatInnerIO.No_more_input ->
        if !line_count > max_line_count
        then print_error (File_too_long (!line_count - 1))
        else ()
  
let moulinette filepath =
  file := Filename.basename filepath;
  with_file_in ~mode: [ `excl; `text; `nonblock ] filepath process

