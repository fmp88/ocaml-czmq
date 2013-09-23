open Ctypes
open PosixTypes
open Foreign
open Unsigned

exception General_Error of string

type 'kind t = unit ptr
 
type kind = [`Req | `Rep | `Dealer | `Router | `Pub | `Sub | `XPub | `XSub |
             `Push | `Pull | `Pair]

let create ctx kind = 
  let create_stub = foreign "zsocket_new" 
    (ptr Structs._zctx_t @-> int @-> returning (ptr void))
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
    (ptr Structs._zctx_t @-> ptr void @-> returning void) 
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
