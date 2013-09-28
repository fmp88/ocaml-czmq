open Ctypes
open PosixTypes
open Foreign
open Unsigned

let dir_create path = 
  let stub = foreign "zsys_dir_create"
    (string @-> returning int)
  in
  match stub path with 
  | _ -> ()
