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

type t = Czmq_structs.zbeacon_t Ctypes.structure Ctypes.ptr 

let create = foreign "zbeacon_new"
    (int @-> returning (ptr Czmq_structs._zbeacon_t))

let hostname = foreign "zbeacon_hostname"
    ((ptr Czmq_structs._zbeacon_t) @-> returning string)

let set_interval = foreign "zbeacon_set_interval"
    ((ptr Czmq_structs._zbeacon_t) @-> int @-> returning void)

let noecho = foreign "zbeacon_noecho"
    ((ptr Czmq_structs._zbeacon_t) @-> returning void)

let silence = foreign "zbeacon_unsubscribe"
    ((ptr Czmq_structs._zbeacon_t) @-> returning void)

(*
let publish = foreign "zbeacon_publish"
  ((ptr _zbeacon_t) @-> 
*)
let unsubscribe = foreign "zbeacon_unsubscribe"
    ((ptr Czmq_structs._zbeacon_t) @-> returning void)

let socket = foreign "zbeacon_socket"
    ((ptr Czmq_structs._zbeacon_t) @-> returning (ptr void))
