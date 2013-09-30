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

include Structs

type t = Structs.zcert_t Ctypes.structure Ctypes.ptr 

let create = foreign "zcert_new"
  (void @-> returning (ptr Structs._zcert_t))
(*
let destroy certificate = 
  let destroy_stub = foreign "zcert_destroy"
    (ptr (ptr _zcert_t) @-> returning void)
  in
  destroy_stub (addr certificate)
*)
let public_txt = foreign "zcert_public_txt"
  ((ptr _zcert_t) @-> returning string)

let secret_txt = foreign "zcert_secret_txt"
  ((ptr _zcert_t) @-> returning string)

let set_meta = foreign "zcert_set_meta"
  ((ptr _zcert_t) @-> string @-> string @-> returning void)

let meta = foreign "zcert_meta"
  ((ptr _zcert_t) @-> string @-> returning string)

let load = foreign "zcert_load"
  (string @-> returning (ptr _zcert_t))

let save self filename = 
  let stub = foreign "zcert_save"
    ((ptr _zcert_t) @-> string @-> returning int) 
  in
  match stub self filename with 
  | _ -> ()

let save_public self filename = 
  let stub = foreign "zcert_save_public"
    ((ptr _zcert_t) @-> string @-> returning int)
  in
  match stub self filename with
  | _ -> ()

let apply = foreign "zcert_apply"
  ((ptr _zcert_t) @-> ptr void @-> returning void)

let dup = foreign "zcert_dup"
  ((ptr _zcert_t) @-> returning (ptr _zcert_t))

let eq self compare = 
  let stub = foreign "zcert_eq"
    ((ptr _zcert_t) @-> (ptr _zcert_t) @-> returning int)
  in
  match stub self compare with
  | 0 -> false
  | _ -> true

let dump = foreign "zcert_dump"
  ((ptr _zcert_t) @-> returning void)
