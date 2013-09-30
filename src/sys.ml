open Ctypes
open PosixTypes
open Foreign
open Unsigned

let set_interface = foreign "zsys_set_interface"
  (string @-> returning void)

let interface = foreign "zsys_interface"
  (void @-> returning string)

let file_exists filename = 
  let stub = foreign "zsys_file_exists"
    (string @-> returning int)
  in
  match stub filename with
  | 0 -> false
  | _ -> true

let dir_create path = 
  let stub = foreign "zsys_dir_create"
    (string @-> returning int)
  in
  match stub path with 
  | _ -> ()

let dir_delete path = 
  let stub = foreign "zsys_dir_delete"
    (string @-> returning int)
  in
  match stub path with
  | _ -> ()

let file_mode_private = foreign "zsys_file_mode_private"
  (void @-> returning void)

let file_mode_default = foreign "zsys_file_mode_default"
  (void @-> returning void)

