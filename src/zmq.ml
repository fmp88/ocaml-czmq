open Ctypes
open PosixTypes
open Foreign
open Unsigned

exception General_Error of string

let zmq_version_stub = foreign "zmq_version" (ptr int @-> ptr int @-> ptr int @-> returning void)

let version () = 
  let major = allocate int 0 in
  let minor = allocate int 0 in
  let patch = allocate int 0 in
  zmq_version_stub major minor patch;
  (!@major,!@minor,!@patch)
   
module Context = struct

  type t = unit ptr
 
  let create = foreign "zmq_ctx_new" 
    (void @-> returning_checking_errno (ptr void))

  let destroy ctx = 
    let destroy_stub = foreign "zmq_ctx_term" 
      (ptr void @-> returning_checking_errno int)
    in
    match destroy_stub ctx with
    | 0 -> ()
    | _ -> raise (General_Error "Destroy context")

  let set_stub = foreign "zmq_ctx_set" (ptr void @-> int @-> int @-> returning int)
  let set_io_threads ctx nr =
    let zmq_io_threads = 1 in
    match set_stub ctx zmq_io_threads nr with
    | 0 -> ()
    | _ -> raise (General_Error "Set io threads for context")
    
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

end


module Socket = struct

  type 'kind t = unit ptr
 
  type kind = [`Req | `Rep | `Dealer | `Router | `Pub | `Sub | `XPub | `XSub |
               `Push | `Pull | `Pair]

  let create ctx kind = 
    let create_stub = foreign "zmq_socket" 
      (ptr void @-> int @-> returning_checking_errno (ptr void))
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

  let close ctx = 
    let close_stub = foreign "zmq_close" (ptr void @-> returning int) in
    match close_stub ctx with
    | 0 -> ()
    | _ -> raise (General_Error "Close socket")

  let bind ctx name = 
    let bind_stub = foreign "zmq_bind" (ptr void @-> string @-> returning int) in
    match bind_stub ctx name with 
    | 0 -> ()
    | _ -> raise (General_Error "Bind socket")

  let unbind ctx name = 
    let unbind_stub = foreign "zmq_unbind" (ptr void @-> string @-> returning int)
    in
    match unbind_stub ctx name with
    | 0 -> ()
    | _ -> raise (General_Error "Unbind socket")

  let connect ctx name = 
    let connect_stub = foreign "zmq_connect" (ptr void @-> string @-> returning int)
    in
    match connect_stub ctx name with
    | 0 -> ()
    | _ -> raise (General_Error "Connect socket")

  let disconnect ctx name = 
    let disconnect_stub = foreign "zmq_disconnect" (ptr void @-> string @-> returning int)
    in
    match disconnect_stub ctx name with
    | 0 -> ()
    | _ -> raise (General_Error "Disconnect socket")

  type msg_t 
  let msg_t : msg_t structure typ = structure "zmq_msg_t"
  let _ = msg_t *:* (array 32 uchar)
  let () = seal msg_t

  let msg_close_stub = foreign "zmq_msg_close" (ptr msg_t @-> returning int)
  let msg_data_stub = foreign "zmq_msg_data"
      (ptr msg_t @-> returning string)
 
  type snd_flag = None | Dontwait | Sndmore | Dontwait_Sndmore
  let send socket ?flag:(flag=None) m = 
    let c_flag = match flag with
    | None -> 0
    | Dontwait -> 1
    | Sndmore -> 2
    | Dontwait_Sndmore-> 42
    in
    let send_stub = foreign "zmq_msg_send" 
      (ptr msg_t @-> ptr void @->int @-> returning int)
    in
    let msg = make msg_t in
    let msg_size = Size_t.of_int (String.length m) in
    let msg_init_size_stub = foreign "zmq_msg_init_size" 
      ( ptr msg_t @-> size_t @-> returning_checking_errno int) 
    in
    msg_init_size_stub (addr msg) msg_size;
    let msg_content = msg_data_stub (addr msg) in
    let memcpy_stub = foreign "memcpy" 
      (string @-> string @-> size_t @-> returning_checking_errno void)
    in
    memcpy_stub msg_content m msg_size;
    print_endline msg_content;
    match send_stub (addr msg) socket c_flag with
    | -1 -> raise (General_Error "Send socket")
    | _ -> print_endline (msg_data_stub (addr msg));()

  type recv_flag = None | Dontwait
  let recv ?flag:(flag=None) socket =
    let c_flag = match flag with
    | None -> 0
    | Dontwait -> 1
    in
    let recv_stub = foreign "zmq_msg_recv" 
      (ptr (msg_t : msg_t structure typ) @-> ptr void @-> int @-> returning int)
    in
    let msg_buffer = make msg_t in
    let msg_init_stub = foreign "zmq_msg_init" 
      (ptr ( msg_t : msg_t structure typ) @-> returning_checking_errno int) 
    in
    msg_init_stub (addr msg_buffer);
    match recv_stub (addr msg_buffer) socket c_flag with
    | -1 -> raise (General_Error "Receive socket")
    | _ -> msg_data_stub (addr msg_buffer)
  
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

