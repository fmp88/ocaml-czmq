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
