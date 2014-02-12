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
  match Socket.rcvmore socket with 
  | true -> let rec collect acc = 
    print_endline (string_of_int (List.length acc));
    match Socket.rcvmore socket with
    | true  -> let next_part = recv socket in 
               collect (acc@[next_part])
    | false -> print_endline "before last msg part";
               let last_part = recv socket in 
               Printf.printf "Last msg: %s" last_part;
               acc@[last_part]
    in
  Multipart (collect [])
  | false -> let stub = foreign "zstr_recv"
    ((ptr void) @-> returning string)
    in
  Singlepart (stub socket)

let recv_nowait socket = 
  let stub = foreign "zstr_recv_nowait"
    ((ptr void) @-> returning string_opt)
  in
  match stub socket with
  | None -> exit 2;
  | Some x -> x

let send ctx m = 
  let send_stub = foreign "zstr_send"
    ((ptr void) @-> string @-> returning int)
  in
  match send_stub ctx m with
  | _ -> () 

let sendm ctx msg = 
  let stub = foreign "zstr_sendm"
    ((ptr void) @-> string @-> returning int)
  in
  match stub ctx msg with
  | _ -> ()

let sendx socket msg_list =
  let rec loop = function
  | []    -> ()
  | x::[] -> send socket x
  | x::y  -> sendm socket x;
             loop y
  in
  loop msg_list

let recvx socket =
  let rec collect acc = 
    print_endline (string_of_int (List.length acc));
    match Socket.rcvmore socket with
    | true  -> let next_part = recv socket in 
               collect (acc@[next_part])
    | false -> print_endline "before last msg part";
               let last_part = recv socket in 
               Printf.printf "Last msg: %s" last_part;
               acc@[last_part]
  in
  collect []
