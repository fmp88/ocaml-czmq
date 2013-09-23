module Cert = struct

  type t = zcert_t Ctypes.structure Ctypes.ptr 

  let create = foreign "zcert_new"
    (void @-> returning (ptr _zcert_t))

end


