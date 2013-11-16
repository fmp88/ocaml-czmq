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

let recv socket = 
  let stub = foreign "zstr_recv"
    ((ptr void) @-> returning string_opt)
  in
  match stub socket with
  | None -> exit 2;
  | Some x -> x

let recv_nowait socket = 
  let stub = foreign "zstr_recv_nowait"
    ((ptr void) @-> returning string_opt)
  in
  match stub socket with
  | None -> exit 2;
  | Some x -> x

let send ctx msg= 
  let send_stub = foreign "zstr_send"
    ((ptr void) @-> string @-> returning int)
  in
  match send_stub ctx msg with
  | _ -> () 

let sendm ctx msg = 
  let stub = foreign "zstr_sendm"
    ((ptr void) @-> string @-> returning int)
  in
  match stub ctx msg with
  | _ -> ()

let sendx socket msg_list =
  let rec iter = function
  | []    -> ()
  | x::[] -> send socket x
  | x::y  -> sendm socket x;
            iter y
  in
  iter msg_list

let recvx socket =
  let rec collect acc = match Socket.rcvmore socket with
  | false -> acc@[recv socket]
  | true  -> collect (acc@[recv socket])
  in
  collect []
