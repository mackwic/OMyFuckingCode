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
  | Win_EOL of line_nb
  | Indent_overflow of (lines_nb * int)

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
    | Win_EOL line -> line_ref := line;
        BatPrintf.sprintf "Windows EOL at line %d" line
    | Indent_overflow line,width -> line_ref := line;
        BatPrintf.sprintf "Incorrect indentation at line %d (width is %d)" line width
  in Printer.error ~line:(!line_ref) ~file:!file ~from: "First_run" err_msg
  
let process input =
  let col_count = ref 0 and max_col_count = Config.int "rules.format.max_column" 80

  and scope_count = ref 0
  and max_scope_count = Config.int "rules.format.max_function_size" 25
  and line_count = ref 1

  and max_line_count = Config.int "rules.format.max_file_size" 250

  and use_spaces_indent = Config.bool "rules.format.indent.use_spaces" true
  and indent_width = Config.int "rules.format.indent.width" 4
  and remove_trailling = Config.bool "rules.format.sanity.remove_trailing_spaces" true
  and remove_win_eol = Config.bool "rules.format.sanity.remove_windoz_eol" true

  in
  let rec processs input depth_scope is_string start_of_line indent_count =
    incr !count;
    if indent_count > (depth_scope * indent_width)
    then print_error (Indent_Overflow (!line_count, indent_count)) else ();
    match BatInnerIO.read input with
    | '\r' -> if remove_win_eol then print_error (Win_EOL !line_count) else ();
        processs input depth_scope is_string false 0
    | ' ' ->
          if not start_of_line then processs input depth_scope is_string false 0
          else processs input depth_scope is_string true (indent_count + 1)
    | '\n' -> begin
         if !col_count > max_col_count
         then print_error (Line_too_wide (!line_count, !col_count))
         else ();
         col_count := 0;
         if depth_scope > 0 then incr scope_count else ();
         processs input depth_scope is_string true 0;
         end
    | '{' ->
         processs input (depth_scope + (if is_string then 0 else 1)) is_string false 0
    | '}' ->
         if (depth_scope = 1) || (not is_string)
         then
           (if !scope_count > max_scope_count
            then print_error (Scope_too_large (!line_count, !scope_count))
            else ();
            scope_count := 0)
         else ();
         processs input (depth_scope - (if is_string then 0 else 1)) is_string false 0
    | '"' -> processs input depth_scope (toggle is_string) false 0
    | _ -> processs input depth_scope is_string false 0
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

