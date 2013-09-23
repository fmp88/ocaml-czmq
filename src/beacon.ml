module Beacon = struct

  type t = zbeacon_t Ctypes.structure Ctypes.ptr 
 
  let create = foreign "zbeacon_new"
    (int @-> returning (ptr _zbeacon_t))

  let hostname = foreign "zbeacon_hostname"
    ((ptr _zbeacon_t) @-> returning string)

  let set_interval = foreign "zbeacon_set_interval"
    ((ptr _zbeacon_t) @-> int @-> returning void)
  
  let noecho = foreign "zbeacon_noecho"
    ((ptr _zbeacon_t) @-> returning void)
(*
  let publish = foreign "zbeacon_publish"
    ((ptr _zbeacon_t) @-> 
*)
  let silence = foreign "zbeacon_unsubscribe"
    ((ptr _zbeacon_t) @-> returning void)

end

