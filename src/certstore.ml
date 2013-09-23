module Certstore = struct
 
  type t = zcertstore_t Ctypes.structure Ctypes.ptr 

  let create = foreign "zcertstore_new"
    (string @-> returning (ptr _zcertstore_t))
(*
  let destroy = foreign
*)
  let lookup = foreign "zcertstore_lookup"
    ((ptr _zcertstore_t) @-> string @-> returning (ptr _zcert_t))
(*  
  let insert = foreign "zcertstore_insert"
    (
*)
  let dump = foreign "zcertstore_dump"
    ((ptr _zcertstore_t) @-> returning void)

end


