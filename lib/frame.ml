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

type flags = Last | More | Dontwait | More_Dontwait

let create msg = 
  let stub = foreign "zframe_new"
      (string @-> size_t @-> returning zframe_opt)
  in
  let msg_size =  Size_t.of_int (String.length msg) in
  match stub msg msg_size with 
  | None -> raise Frame_creation
  | Some x -> x

let recv = foreign "zframe_recv"
    ((ptr void) @-> returning zframe_opt)

let recv_nowait = foreign "zframe_recv_nowait"
    ((ptr void) @-> returning zframe_opt)

let send (frame : t) socket ?flag:(f=Last) =
  let fptr = allocate zframe frame in
  let stub = foreign "zframe_send"
      (ptr zframe @-> ptr void @-> int @-> returning int)
  in
  match f with
  | Last -> stub fptr socket 0
  | More -> stub fptr socket 1
  | Dontwait -> stub fptr socket 4
  | More_Dontwait -> stub fptr socket 42

let strhex = foreign "zframe_strhex"
    (ptr void @-> returning string)

let data = foreign "zframe_strdup" (ptr void @-> returning string)

