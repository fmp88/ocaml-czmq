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

let set_interface = foreign "zsys_set_interface"
  (string @-> returning void)

let interface = foreign "zsys_interface"
  (void @-> returning string)

let file_exists filename = 
  let stub = foreign "zsys_file_exists"
    (string @-> returning int)
  in
  match stub filename with
  | 0 -> false
  | _ -> true

let dir_create path = 
  let stub = foreign "zsys_dir_create"
    (string @-> returning int)
  in
  match stub path with 
  | _ -> ()

let dir_delete path = 
  let stub = foreign "zsys_dir_delete"
    (string @-> returning int)
  in
  match stub path with
  | _ -> ()

let file_mode_private = foreign "zsys_file_mode_private"
  (void @-> returning void)

let file_mode_default = foreign "zsys_file_mode_default"
  (void @-> returning void)

