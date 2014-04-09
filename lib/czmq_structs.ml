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

(*
let libczmq =
  let names = ["libzmq.so"; "libczmq.so"; "libsodium.so"] in
  let rec loop = function
(*  | [] -> ()
    failwith "libgsasl: could not load shared library"*)
    | x :: xs ->
      try Dl.dlopen ~filename:x ~flags:[]
      with _ -> loop xs
  in
  loop names

let foreign fname fn =
  foreign ~from:libczmq fname fn
*)

type zctx_t
let _zctx_t : zctx_t structure typ = structure "_zctx_t"

type zcertstore_t
let _zcertstore_t : zcertstore_t structure typ = structure "_zcertstore_t"

type zcert_t
let _zcert_t : zcert_t structure typ = structure "_zcert_t"

type zauth_t
let _zauth_t : zauth_t structure typ = structure "_zauth_t"

type zbeacon_t
let _zbeacon_t : zbeacon_t structure typ = structure "_zbeacon_t"

type zdir_t
let _zdir_t : zdir_t structure typ = structure "_zdir_t"

type zconfig_t
let _zconfig_t : zconfig_t structure typ = structure "_zconfig_t"

type zpoller_t
let _zpoller_t : zpoller_t structure typ = structure "_zpoller_t"

type zmsg_t
let _zmsg_t : zmsg_t structure typ = structure "_zmsg_t"
let content_size = _zmsg_t *:* size_t
