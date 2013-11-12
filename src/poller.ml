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

type t = Structs.zpoller_t Ctypes.structure Ctypes.ptr 

let create reader_list = 
  let stub = foreign "zpoller_new"
    (ptr void @-> returning (ptr Structs._zpoller_t))
  in
  let stub2 = foreign "zpoller_new"
    (ptr void @-> ptr void @-> returning (ptr Structs._zpoller_t))
  in
  let stub3 = foreign "zpoller_new"
    (ptr void @-> ptr void @-> ptr void @-> returning (ptr Structs._zpoller_t))
  in
  let stub4 = foreign "zpoller_new"
    (ptr void @-> ptr void @-> ptr void @-> ptr void @-> returning (ptr Structs._zpoller_t))
  in
  let stub5 = foreign "zpoller_new"
    (ptr void @-> ptr void @-> ptr void @-> ptr void @-> ptr void @-> returning (ptr Structs._zpoller_t))
  in
  match List.length reader_list with 
  | 1 -> stub (List.nth reader_list 0)
  | 2 -> stub2 (List.nth reader_list 0) (List.nth reader_list 1)
  | 3 -> stub3 (List.nth reader_list 0) (List.nth reader_list 1) (List.nth reader_list 2)
  | 4 -> stub4 (List.nth reader_list 0) (List.nth reader_list 1) (List.nth reader_list 2)
    (List.nth reader_list 3)
  | 5 -> stub5 (List.nth reader_list 0) (List.nth reader_list 1) (List.nth reader_list 2)
    (List.nth reader_list 3) (List.nth reader_list 4)
  | _ -> raise (General_Error "To many readers")

let wait sockets timeout = 
  let stub = foreign "zpoller_wait" ((ptr Structs._zpoller_t) @-> int @-> returning (ptr void))
  in
  match stub sockets timeout with
  | null -> None
  | x -> Some x

let expired self = 
  let stub = foreign "zpoller_expired"
    ((ptr Structs._zpoller_t) @-> returning int)
  in
  match stub self with
  | 0 -> false
  | _ -> true
  
let terminated self = 
  let stub = foreign "zpoller_terminated"
    ((ptr Structs._zpoller_t) @-> returning int)
  in
  match stub self with
  | 0 -> false
  | _ -> true

