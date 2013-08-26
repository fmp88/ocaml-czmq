open Ctypes
open PosixTypes
open Foreign

exception General_Error

let zmq_version_stub = foreign "zmq_version" (ptr int @-> ptr int @-> ptr int @-> returning void)

let version () = 
  let major = allocate int 0 in
  let minor = allocate int 0 in
  let patch = allocate int 0 in
  zmq_version_stub major minor patch;
  (!@major,!@minor,!@patch)
   

module Socket = struct

  type 'kind t = unit ptr
 
  type kind = Req | Rep | Dealer | Router | Pub | Sub | XPub | XSub |
              Push | Pull | Pair 

  module Context = struct

    type t = unit ptr
 
    let create = foreign "zmq_ctx_new" (void @-> returning (ptr void))

    let destroy ctx = 
      let destroy_stub = foreign "zmq_ctx_term" (ptr void @-> returning int)
      in
      match destroy_stub ctx with
      | 0 -> ()
      | _ -> raise General_Error

    let set_stub = foreign "zmq_ctx_set" (ptr void @-> int @-> int @-> returning int)
    let set_io_threads ctx nr =
      let zmq_io_threads = 1 in
      match set_stub ctx zmq_io_threads nr with
      | 0 -> ()
      | _ -> raise General_Error
      
    let set_max_sockets ctx nr =
      let zmq_max_sockets = 2 in
      match set_stub ctx zmq_max_sockets nr with
      | 0 -> ()
      | _ -> raise General_Error
      
    let set_ipv6 ctx flag =
      let zmq_set_ipv6 = 42 in
      let c_flag = match flag with
      | false -> 0 
      | true -> 1
      in
      match set_stub ctx zmq_set_ipv6 c_flag with
      | 0 -> ()
      | _ -> raise General_Error
      
    let get_stub = foreign "zmq_ctx_get" (ptr void @-> int @-> returning int)
    let get_io_threads ctx =
      let zmq_io_threads = 1 in
      match get_stub ctx zmq_io_threads with
      | x when x < 0 -> raise General_Error
      | x -> x

    let get_max_sockets ctx =
      let zmq_max_sockets = 2 in
      match get_stub ctx zmq_max_sockets with
      | x when x < 0 -> raise General_Error
      | x -> x

    let get_ipv6 ctx =
      let zmq_ipv6 = 42 in
      match get_stub ctx zmq_ipv6 with
      | x when x < 0 -> raise General_Error
      | 0 -> false
      | x -> true

  end

  let create ctx kind = 
    let create_stub = foreign "zmq_socket" (ptr void @-> int @-> returning (ptr void))
    in
    let c_kind = match kind with
    | ZMQ_PAIR -> 0
    | ZMQ_PUB -> 1
    | ZMQ_SUB -> 2
    | ZMQ_REQ -> 3
    | ZMQ_REP -> 4
    | ZMQ_DEALER -> 5
    | ZMQ_ROUTER -> 6
    | ZMQ_PULL -> 7
    | ZMQ_PUSH -> 8
    | ZMQ_XPUB -> 9
    | ZMQ_XSUB -> 10
    in
    create_stub ctx c_kind

  let close ctx = 
    let close_stub = foreign "zmq_close" (ptr void @-> returning int) in
    match close_stub ctx with
    | 0 -> ()
    | _ -> raise General_Error

end

