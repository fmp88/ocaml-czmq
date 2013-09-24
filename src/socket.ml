(*
Copyright (c) 2013, Florian Pichlmeier <florian.pichlmeier@mytum.de>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies, 
either expressed or implied, of the FreeBSD Project.
*)

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

(* Get socket options *)
let ipv6 socket = 
  let stub = foreign "zsocket_ipv6"
    ((ptr void) @-> returning int)
  in
  match stub socket with
  | 0 -> false
  | _ -> true

let ipv4only socket = 
  let stub = foreign "zsocket_ipv4only"
    ((ptr void) @-> returning int)
  in
  match stub socket with
  | 0 -> false
  | _ -> true

let probe_router socket = 
  let stub = foreign "zsocket_probe_router"
    ((ptr void) @-> returning int)
  in
  match stub socket with
  | 0 -> false
  | _ -> true

let plain_server socket = 
  let stub = foreign "zsocket_plain_server"
    ((ptr void) @-> returning int)
  in
  match stub socket with
  | 0 -> false
  | _ -> true

let plain_username  = foreign "zsocket_plain_username"
    ((ptr void) @-> returning string)

let plain_password  = foreign "zsocket_plain_password"
    ((ptr void) @-> returning string)

let curve_server  = foreign "zsocket_curve_server"
    ((ptr void) @-> returning int)

let curve_publickey  = foreign "zsocket_curve_publickey"
    ((ptr void) @-> returning string)

let curve_secretkey  = foreign "zsocket_curve_secretkey"
    ((ptr void) @-> returning string)

let curve_serverkey  = foreign "zsocket_curve_serverkey"
    ((ptr void) @-> returning string)

let zap_domain  = foreign "zsocket_zap_domain"
    ((ptr void) @-> returning string)

let socket_type = foreign "zsocket_socket_type"
    ((ptr void) @-> returning int)

let sndhwm  = foreign "zsocket_sndhwm"
    ((ptr void) @-> returning int)

let rcvhwm  = foreign "zsocket_rcvhwm"
    ((ptr void) @-> returning int)

let affinity  = foreign "zsocket_affinity"
    ((ptr void) @-> returning int)

let identity  = foreign "zsocket_identity"
    ((ptr void) @-> returning string)

let rate  = foreign "zsocket_rate"
    ((ptr void) @-> returning int)

let recovery_ivl  = foreign "zsocket_recovery_ivl"
    ((ptr void) @-> returning int)

let sndbuf  = foreign "zsocket_sndbuf"
    ((ptr void) @-> returning int)

let rcvbuf = foreign "zsocket_rcvbuf"
    ((ptr void) @-> returning int)

let linger = foreign "zsocket_linger"
    ((ptr void) @-> returning int)

let reconnect_ivl = foreign "zsocket_reconnect_ivl"
    ((ptr void) @-> returning int)

let reconnect_ivl_max = foreign "zsocket_reconnect_ivl_max"
    ((ptr void) @-> returning int)

let backlog = foreign "zsocket_backlog"
    ((ptr void) @-> returning int)

let maxmsgsize = foreign "zsocket_maxmsgsize"
    ((ptr void) @-> returning int)

let multicast_hops = foreign "zsocket_multicast_hops"
    ((ptr void) @-> returning int)

let rcvtimeo = foreign "zsocket_rcvtimeo"
    ((ptr void) @-> returning int)

let sndtimeo = foreign "zsocket_sndtimeo"
    ((ptr void) @-> returning int)

let tcp_keepalive = foreign "zsocket_tcp_keepalive"
    ((ptr void) @-> returning int)

let tcp_keepalive_idle = foreign "zsocket_tcp_keepalive_idle"
    ((ptr void) @-> returning int)

let tcp_keepalive_cnt = foreign "zsocket_tcp_keepalive_cnt"
    ((ptr void) @-> returning int)

let tcp_keepalive_intvl = foreign "zsocket_tcp_keepalive_intvl"
    ((ptr void) @-> returning int)

let tcp_accept_filter = foreign "zsocket_tcp_accept_filter"
    ((ptr void) @-> returning string)

let rcvmore = foreign "zsocket_rcvmore"
    ((ptr void) @-> returning int)

let fd = foreign "zsocket_fd"
    ((ptr void) @-> returning int)

let events = foreign "zsocket_events"
    ((ptr void) @-> returning int)

let last_endpoint = foreign "zsocket_last_endpoint"
    ((ptr void) @-> returning string)

(* Set socket options *)
let set_ipv6 socket flag = 
  let stub = foreign "zsocket_set_ipv6"
    ((ptr void) @-> int @-> returning void)
  in
  match flag with
  | false -> stub socket 0
  | true -> stub socket 1

let set_plain_server = foreign "zsocket_set_plain_server"
  ((ptr void) @-> int @-> returning void)

let set_plain_username = foreign "zsocket_set_plain_username"
  ((ptr void) @-> string @-> returning void)

let set_plain_password = foreign "zsocket_set_plain_password"
  ((ptr void) @-> string @-> returning void)

let set_curve_server = foreign "zsocket_set_curve_server"
  ((ptr void) @-> int @-> returning void)

let set_curve_publickey = foreign "zsocket_set_curve_publickey"
  ((ptr void) @-> string @-> returning void)
(*
let set_curve_publickey_bin = foreign "zsocket_set_curve_publickey_bin"
  ((ptr void) @-> string @-> returning void)
*)
let set_curve_secretkey = foreign "zsocket_set_curve_secretkey"
  ((ptr void) @-> string @-> returning void)
(*
let set_curve_secretkey_bin = foreign "zsocket_set_curve_secretkey_bin"
  ((ptr void) @-> string @-> returning void)
*)
let set_zap_domain = foreign "zsocket_set_zap_domain"
  ((ptr void) @-> string @-> returning void)

