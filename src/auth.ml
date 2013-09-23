module Auth = struct

  type t = zauth_t Ctypes.structure Ctypes.ptr 

  let create = foreign "zauth_new"
    ((ptr _zctx_t) @-> returning (ptr _zauth_t))
  
  let allow = foreign "zauth_allow"
    ((ptr _zctx_t) @-> string @-> returning void)

  let deny = foreign "zauth_deny"
    ((ptr _zctx_t) @-> string @-> returning void)

  let configure_plain = foreign "zauth_configure_plain"
    ((ptr _zctx_t) @-> string @-> string @-> returning void)
    
  let configure_curve = foreign "zauth_configure_curve"
    ((ptr _zctx_t) @-> string @-> string @-> returning void)
(*
  let set_verbose = foreign "zauth_set_verbose"
    ((ptr _zctx_t) @-> bool @-> returning void)
*) 
end


