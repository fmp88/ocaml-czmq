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

type t = Czmq_structs.zdir_t Ctypes.structure Ctypes.ptr 

let create = foreign "zdir_new"
    (string @-> string @-> returning (ptr Czmq_structs._zdir_t))

let path = foreign "zdir_path"
    ((ptr Czmq_structs._zdir_t) @-> returning string)

(*
let dump = foreign "zdir_dump"
  ((ptr Czmq_structs._zdir_t) @-> int @-> returning void)
*)
