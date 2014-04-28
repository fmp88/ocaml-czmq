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

exception Frame_creation

type t = unit ptr
let zframe : t typ = ptr void
let zframe_opt : t option typ = ptr_opt void

type flags = Last | More | Dontwait | Reuse | More_Dontwait | More_Reuse

let destroy = foreign "zframe_destroy" ((ptr zframe) @-> returning void)

let create msg = 
  let stub = foreign "zframe_new"
      (string @-> size_t @-> returning zframe_opt)
  in
  let msg_size =  Size_t.of_int (String.length msg) in
  match stub msg msg_size with 
  | None -> raise Frame_creation
  | Some x -> x

let empty = foreign "zframe_new_empty" (void @-> returning zframe)

let recv = foreign "zframe_recv"
    ((ptr void) @-> returning zframe_opt)

let recv_nowait = foreign "zframe_recv_nowait"
    ((ptr void) @-> returning zframe_opt)

let send (frame : t) ?flag:(f=Last) socket =
  let fptr = allocate zframe frame in
  let stub = foreign "zframe_send"
      (ptr zframe @-> ptr void @-> int @-> returning int)
  in
  let ocaml_flag = match f with
    | Last -> 0
    | Reuse -> 2
    | More -> 1
    | Dontwait -> 4
    | More_Dontwait -> 4 + 1
    | More_Reuse -> 1 + 2
  in
  stub fptr socket ocaml_flag

let strhex = foreign "zframe_strhex"
    (ptr void @-> returning string)

let data = foreign "zframe_strdup" (ptr void @-> returning string)

let size msg = 
  let stub = foreign "zframe_size" (ptr void @-> returning size_t) in
  Unsigned.Size_t.to_int (stub msg)

let streq msg str = 
  let stub = foreign "zframe_streq" (ptr void @-> string @-> returning int) in
  match stub msg str with
  | 0 -> false
  | _ -> true

let eq msg1 msg2 = 
  let stub = foreign "zframe_eq" (ptr void @-> ptr void @-> returning int) in
  match stub msg1 msg2 with
  | 0 -> false
  | _ -> true

let more msg = 
  let stub = foreign "zframe_more" (ptr void @-> returning int) in
  match stub msg with
  | 0 -> false
  | _ -> true

let set_more msg flag = 
  let stub = foreign "zframe_set_more" (ptr void @-> int @-> returning void) in
  match flag with
  | true  -> stub msg 1
  | false -> stub msg 0

let dup = foreign "zframe_dup" (ptr void @-> returning (ptr void))
