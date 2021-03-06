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
let auth : t typ = ptr void

let create = foreign "zauth_new"
    ((ptr void) @-> returning (auth))
(*
let destroy authenticator = 
  let destroy_stub = foreign "zauth_destroy"
    (ptr (ptr void) @-> returning void)
  in
  destroy_stub (addr authenticator) 
*)
let allow = foreign "zauth_allow"
    ((auth) @-> string @-> returning void)

let deny = foreign "zauth_deny"
    ((auth) @-> string @-> returning void)

let configure_plain = foreign "zauth_configure_plain"
    ((auth) @-> string @-> string @-> returning void)

let configure_curve = foreign "zauth_configure_curve"
    ((auth) @-> string @-> string @-> returning void)

let set_verbose a flag = 
  let stub = foreign "zauth_set_verbose"
      ((auth) @-> int @-> returning void)
  in
  match flag with 
  | true -> stub a 1
  | false -> stub a 0

