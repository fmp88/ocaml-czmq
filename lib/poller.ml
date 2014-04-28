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

exception General_Error of string

type t = unit ptr
let zpoller : t typ = ptr void

let create reader = 
  let stub = foreign "zpoller_new"
      (ptr void @-> ptr void @-> returning zpoller)
  in
  stub reader Ctypes.null 

let add reader_list reader =  
  let stub = foreign "zpoller_add"
      (zpoller @-> ptr void @-> returning int)
  in
  match stub reader_list reader with
  | 0 -> ()
  | _ -> failwith "Can't create poller"

let wait sockets timeout = 
  let stub = foreign "zpoller_wait" (zpoller @-> int @-> returning (ptr void))
  in
  match stub sockets timeout with
  | null when null = Ctypes.null -> None
  | x -> Some x

let expired self = 
  let stub = foreign "zpoller_expired"
      (zpoller @-> returning int)
  in
  match stub self with
  | 0 -> false
  | _ -> true

let terminated self = 
  let stub = foreign "zpoller_terminated"
      (zpoller @-> returning int)
  in
  match stub self with
  | 0 -> false
  | _ -> true

