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

let zmsg : t typ = ptr void
let zmsg_opt : t option typ = ptr_opt void

let create = foreign "zmsg_new" (void @-> returning zmsg) 

let destroy = foreign "zmsg_destroy" (ptr zmsg @-> returning void)
(*
let destroy msg : unit = 
  let fptr = allocate zmsg msg in
  let stub = foreign "zmsg_destroy" (ptr zmsg @-> returning void) in
  match stub fptr with
  | _ -> ()
*)
let recv = foreign "zmsg_recv" (ptr void @-> returning zmsg_opt)

let recv_nowait = foreign "zmsg_recv_nowait" (ptr void @-> returning zmsg_opt)

let send msg socket = 
  let fptr = allocate zmsg msg in
  let stub = foreign "zmsg_send" (ptr zmsg @-> ptr void @-> returning int) in
  match stub fptr socket with
  | _ -> ()

let size msg = 
  let stub = foreign "zmsg_size" (ptr void @-> returning size_t) in
  Unsigned.Size_t.to_int (stub msg)

let content_size msg =
  let stub = foreign "zmsg_content_size" (ptr void @-> returning size_t) in
  Unsigned.Size_t.to_int (stub msg)

let prepend msg frame = 
  let fptr = allocate zmsg frame in
  let stub = foreign "zmsg_prepend" (ptr void @-> ptr (ptr void) @-> returning int) in
  match stub msg fptr with
  | _ -> ()

let append msg frame = 
  let fptr = allocate zmsg frame in
  let stub = foreign "zmsg_append" (ptr void @-> ptr (ptr void) @-> returning int) in
  match stub msg fptr with
  | _ -> ()

let unwrap = foreign "zmsg_unwrap" (zmsg @-> returning (ptr_opt void))

let pushstr msg content = 
  let stub = foreign "zmsg_pushstr" (zmsg @-> string @-> returning int) in
  match stub msg content with
  | _ -> ()

let addstr msg content = 
  let stub = foreign "zmsg_addstr" (zmsg @-> string @-> returning int) in
  match stub msg content with
  | _ -> ()

let dup = foreign "zmsg_dup" (zmsg @-> returning zmsg)
