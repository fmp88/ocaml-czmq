open Ctypes
open PosixTypes
open Foreign
open Unsigned

exception General_Error of string

let version () = 
  let zmq_version_stub = foreign "zmq_version" 
    (ptr int @-> ptr int @-> ptr int @-> returning void)
  in
  let major = allocate int 0 in
  let minor = allocate int 0 in
  let patch = allocate int 0 in
  zmq_version_stub major minor patch;
  (!@major,!@minor,!@patch)

type zctx_t
let _zctx_t : zctx_t structure typ = structure "_zctx_t"
   
type zcertstore_t
let _zcertstore_t : zcertstore_t structure typ = structure "_zcertstore_t"

type zcert_t
let _zcert_t : zcert_t structure typ = structure "_zcert_t"

type zauth_t
let _zauth_t : zauth_t structure typ = structure "_zauth_t"

type zbeacon_t
let _zbeacon_t : zbeacon_t structure typ = structure "_zbeacon_t"

module Context = struct

(*type t = unit ptr*)
  type t = zctx_t Ctypes.structure Ctypes.ptr 

  let create = foreign "zctx_new" 
    (void @-> returning (ptr _zctx_t))

  let destroy = 
    let destroy_stub = foreign "zctx_destroy" 
      (ptr _zctx_t @-> returning void)
    in destroy_stub

  let set_io_threads =
    let set_stub = foreign "zctx_set_iothreads" 
      (ptr _zctx_t @-> int @-> returning void)
    in
    set_stub
    
  let set_linger =
    let set_stub = foreign "zctx_set_linger" 
      (ptr _zctx_t @-> int @-> returning void)
    in
    set_stub
    
  let set_pipehwm =
    let set_stub = foreign "zctx_set_pipehwm" 
      (ptr _zctx_t @-> int @-> returning void)
    in
    set_stub
    
  let set_sndhwm =
    let set_stub = foreign "zctx_set_sndhwm" 
      (ptr _zctx_t @-> int @-> returning void)
    in
    set_stub
    
  let set_rcvhwm =
    let set_stub = foreign "zctx_set_rcvhwm" 
      (ptr _zctx_t @-> int @-> returning void)
    in
    set_stub
(*
  let set_max_sockets ctx nr =
    let zmq_max_sockets = 2 in
    match set_stub ctx zmq_max_sockets nr with
    | 0 -> ()
    | _ -> raise (General_Error "Set max threads for context")
    
  let set_ipv6 ctx flag =
    let zmq_set_ipv6 = 42 in
    let c_flag = match flag with
    | false -> 0 
    | true -> 1
    in
    match set_stub ctx zmq_set_ipv6 c_flag with
    | 0 -> ()
    | _ -> raise (General_Error "Set ipv6 for context")
  
  let get_stub = foreign "zmq_ctx_get" (ptr void @-> int @-> returning int)
  let get_io_threads ctx =
    let zmq_io_threads = 1 in
    match get_stub ctx zmq_io_threads with
    | x when x < 0 -> raise (General_Error "Get io threads of context")
    | x -> x

  let get_max_sockets ctx =
    let zmq_max_sockets = 2 in
    match get_stub ctx zmq_max_sockets with
    | x when x < 0 -> raise (General_Error "Get max sockets of context")
    | x -> x

  let get_ipv6 ctx =
    let zmq_ipv6 = 42 in
    match get_stub ctx zmq_ipv6 with
    | x when x < 0 -> raise (General_Error "Get ipv6 of context")
    | 0 -> false
    | x -> true
*)
end


module Socket = struct

  type 'kind t = unit ptr
 
  type kind = [`Req | `Rep | `Dealer | `Router | `Pub | `Sub | `XPub | `XSub |
               `Push | `Pull | `Pair]

  let create ctx kind = 
    let create_stub = foreign "zsocket_new" 
      (ptr _zctx_t @-> int @-> returning (ptr void))
    in
    let c_kind = match kind with
    | `Pair -> 0
    | `Pub -> 1
    | `Sub -> 2
    | `Req -> 3
    | `Rep -> 4
    | `Dealer -> 5
    | `Router -> 6
    | `Pull -> 7
    | `Push -> 8
    | `XPub -> 9
    | `XSub -> 10
    in
    create_stub ctx c_kind

  let destroy = 
    let destroy_stub = foreign "zsocket_destroy" 
      (ptr _zctx_t @-> ptr void @-> returning void) 
    in
    destroy_stub

  let bind ctx name = 
    let bind_stub = foreign "zsocket_bind" (ptr void @-> string @-> returning int) in
    match bind_stub ctx name with 
    | 0 -> ()
    | _ -> raise (General_Error "Bind socket")

  let unbind ctx name = 
    let unbind_stub = foreign "zsocket_unbind" (ptr void @-> string @-> returning int)
    in
    match unbind_stub ctx name with
    | 0 -> ()
    | _ -> raise (General_Error "Unbind socket")

  let connect ctx name = 
    let connect_stub = foreign "zsocket_connect" (ptr void @-> string @-> returning int)
    in
    match connect_stub ctx name with
    | 0 -> ()
    | _ -> raise (General_Error "Connect socket")

  let disconnect ctx name = 
    let disconnect_stub = foreign "zsocket_disconnect" 
      (ptr void @-> string @-> returning int)
    in
    match disconnect_stub ctx name with
    | 0 -> ()
    | _ -> raise (General_Error "Disconnect socket")

  type snd_flag = None | Dontwait | Sndmore | Dontwait_Sndmore
  let send socket ?flag:(flag=None) m = 
    let c_flag = match flag with
    | None -> 0
    | Dontwait -> 1
    | Sndmore -> 2
    | Dontwait_Sndmore-> 42
    in
    let send_stub = foreign "zsocket_sendmem" 
      (ptr void @-> string @-> size_t @-> int @-> returning int)
    in
    let msg_size = Size_t.of_int (String.length m) in
    match send_stub socket m msg_size c_flag with
    | -1 -> raise (General_Error "Send socket")
    | _ -> ()

  type recv_flag = None | Dontwait
  let recv ?flag:(flag=None) socket =
    let c_flag = match flag with
    | None -> 0
    | Dontwait -> 1
    in
    let recv_stub = foreign "zstr_recv" 
      (ptr void @-> returning string)
    in
    recv_stub socket
  
end

module Poll = struct

  type poll_t
  type t = poll_t Ctypes.structure Ctypes.Array.t

  type event = In | Out |InOut
  type item = (Socket.kind Socket.t * event) 

  let pollitem_t : poll_t structure typ = structure "zmq_pollitem_t"
  let socket = pollitem_t *:* (ptr void)
  let fd = pollitem_t *:* int
  let events = pollitem_t *:* int16_t
  let revents = pollitem_t *:* int16_t
  let () = seal pollitem_t

  let mask items =  
    let length = Array.length items in
    let poll_mask = Array.make pollitem_t length in
    let transform item = 
      let (socket_elt, event_elt) = match item with
      | (s, In) -> (s, 1)
      | (s, Out) -> (s, 2)
      | (s, InOut) -> (s, 42)
      in
      let pollitem = make pollitem_t in
      setf pollitem socket socket_elt;
      setf pollitem events event_elt;
      pollitem
    in
    for i=0 to length -1 do
      let tmp = transform (Array.get items i) in
      Array.set poll_mask i tmp;
    done;
    poll_mask
(*
  let poll ?timeout(t=0) mask = 
    let poll_stub = foreign "zmq_poll" (ptr pollitem @-> int @-> long @-> int) 
    in
    let length = Array.length mask in
    let retransform item = match item with
    | 
*)  
end

module Options = struct 
 
end

module Clock = struct

  let sleep = foreign "zclock_sleep"
    (int @-> returning void)

  let time = foreign "zclock_time"
    (void @-> returning int64_t)

  let log = foreign "zclock_log"
    (string @-> returning void)

  let timestr = foreign "zclock_timestr" 
    (void @-> returning string)

end

module Cert = struct

  type t = zcert_t Ctypes.structure Ctypes.ptr 

  let create = foreign "zcert_new"
    (void @-> returning (ptr _zcert_t))

end

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
