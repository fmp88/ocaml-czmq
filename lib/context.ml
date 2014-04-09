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

type t = unit ptr
let ctx : t typ = ptr void

let create = foreign "zctx_new" 
    (void @-> returning (ctx))

let destroy = 
  let destroy_stub = foreign "zctx_destroy" 
      (ctx @-> returning void)
  in destroy_stub

let set_io_threads =
  let set_stub = foreign "zctx_set_iothreads" 
      (ctx @-> int @-> returning void)
  in
  set_stub

let set_linger =
  let set_stub = foreign "zctx_set_linger" 
      (ctx @-> int @-> returning void)
  in
  set_stub

let set_pipehwm =
  let set_stub = foreign "zctx_set_pipehwm" 
      (ctx @-> int @-> returning void)
  in
  set_stub

let set_sndhwm =
  let set_stub = foreign "zctx_set_sndhwm" 
      (ctx @-> int @-> returning void)
  in
  set_stub

let set_rcvhwm =
  let set_stub = foreign "zctx_set_rcvhwm" 
      (ctx @-> int @-> returning void)
  in
  set_stub

let interrupted = 
  let stub = foreign_value "zctx_interrupted" int
  in
  match !@ stub with
  | 0 -> false
  | _ -> true

