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
let config : t typ = ptr void

let create = foreign "zconfig_new"
  (string @-> ptr void @-> returning config)

let name = foreign "zconfig_name"
  (config @-> returning string)

let value = foreign "zconfig_value"
  (config @-> returning string)

let put = foreign "zconfig_put"
  (config @-> string @-> string @-> returning void)

let set_name = foreign "zconfig_set_name"
  (config @-> string @-> returning void)

let set_value = foreign "zconfig_set_value"
  (config @-> string @-> returning void)

let child = foreign "zconfig_child"
  (config @-> returning config)

let next = foreign "zconfig_next"
  (config @-> returning config)

let locate = foreign "zconfig_locate"
  (config @-> string @-> returning config)

let resolve = foreign "zconfig_resolve"
  (config @-> string @-> string @-> returning string)
(*
let set_path = foreign "zconfig_set_path"
  ((ptr Structs._zconfig_t) @-> string @-> string @-> returning void)
*)
let at_depth = foreign "zconfig_at_depth"
  (config @-> int @-> returning config)

let comment = foreign "zconfig_comment"
  (config @-> string @-> returning void)

let load = foreign "zconfig_load"
  (string @-> returning config)

let dump = foreign "zconfig_dump"
  (config @-> returning void)

