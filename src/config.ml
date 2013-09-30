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

type t = Structs.zconfig_t Ctypes.structure Ctypes.ptr 

let create = foreign "zconfig_new"
  (string @-> (ptr Structs._zconfig_t) @-> returning (ptr Structs._zconfig_t))

let name = foreign "zconfig_name"
  ((ptr Structs._zconfig_t) @-> returning string)

let value = foreign "zconfig_value"
  ((ptr Structs._zconfig_t) @-> returning string)

let put = foreign "zconfig_put"
  ((ptr Structs._zconfig_t) @-> string @-> string @-> returning void)

let set_name = foreign "zconfig_set_name"
  ((ptr Structs._zconfig_t) @-> string @-> returning void)

let set_value = foreign "zconfig_set_value"
  ((ptr Structs._zconfig_t) @-> string @-> returning void)

let child = foreign "zconfig_child"
  ((ptr Structs._zconfig_t) @-> returning (ptr Structs._zconfig_t))

let next = foreign "zconfig_next"
  ((ptr Structs._zconfig_t) @-> returning (ptr Structs._zconfig_t))

let locate = foreign "zconfig_locate"
  ((ptr Structs._zconfig_t) @-> string @-> returning (ptr Structs._zconfig_t))

let resolve = foreign "zconfig_resolve"
  ((ptr Structs._zconfig_t) @-> string @-> string @-> returning string)

let set_path = foreign "zconfig_set_path"
  ((ptr Structs._zconfig_t) @-> string @-> string @-> returning void)

let at_depth = foreign "zconfig_at_depth"
  ((ptr Structs._zconfig_t) @-> int @-> returning (ptr Structs._zconfig_t))

let comment = foreign "zconfig_comment"
  ((ptr Structs._zconfig_t) @-> string @-> returning void)

let load = foreign "zconfig_load"
  (string @-> returning (ptr Structs._zconfig_t))

let dump = foreign "zconfig_dump"
  ((ptr Structs._zconfig_t) @-> returning void)

