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

type t = Structs.zcertstore_t Ctypes.structure Ctypes.ptr 

let create = foreign "zcertstore_new"
  (string @-> returning (ptr Structs._zcertstore_t))
(*
let destroy = foreign

let lookup = foreign "zcertstore_lookup"
  ((ptr Structs._zcertstore_t) @-> string @-> returning (ptr Structs._zcert_t))

let insert = foreign "zcertstore_insert"
  (
*)
let dump = foreign "zcertstore_dump"
  ((ptr Structs._zcertstore_t) @-> returning void)
