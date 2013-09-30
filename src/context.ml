(*
   Czmq - a binding for the high level C binding for zeromq

   Copyright (C) 2013 Florian Pichlmeier
   email: florian.pichlmeier@mytum.de

   This file is distributed under the terms of the GNU Library General
   Public License, with the special exception on linking described in 
   file ../COPYING.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*)

open Ctypes
open PosixTypes
open Foreign
open Unsigned

type t = Structs.zctx_t Ctypes.structure Ctypes.ptr 

let create = foreign "zctx_new" 
  (void @-> returning (ptr Structs._zctx_t))

let destroy = 
  let destroy_stub = foreign "zctx_destroy" 
    (ptr Structs._zctx_t @-> returning void)
  in destroy_stub

let set_io_threads =
  let set_stub = foreign "zctx_set_iothreads" 
    (ptr Structs._zctx_t @-> int @-> returning void)
  in
  set_stub
  
let set_linger =
  let set_stub = foreign "zctx_set_linger" 
    (ptr Structs._zctx_t @-> int @-> returning void)
  in
  set_stub
  
let set_pipehwm =
  let set_stub = foreign "zctx_set_pipehwm" 
    (ptr Structs._zctx_t @-> int @-> returning void)
  in
  set_stub
  
let set_sndhwm =
  let set_stub = foreign "zctx_set_sndhwm" 
    (ptr Structs._zctx_t @-> int @-> returning void)
  in
  set_stub
  
let set_rcvhwm =
  let set_stub = foreign "zctx_set_rcvhwm" 
    (ptr Structs._zctx_t @-> int @-> returning void)
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
