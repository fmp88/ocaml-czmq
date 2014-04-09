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

type t = Frame.t list ref

let create () = ref []

let push msg frame = 
  msg := !msg@[frame]

let append msg frame =
  msg := [frame]@(!msg)

let pop msg = match !msg with 
  | x::y -> let data = Some x in
    print_endline (Frame.data x);
    msg := y;
    data
  | _ -> print_endline "Poped none"; None

let wrap msg frame =
  let empty_frame = Frame.create "" in
  msg := !msg@[empty_frame];
  msg := !msg@[frame]

(*
let unwrap
*)

let recv socket = 
  let self = create () in
  let cond = ref true in
  while !cond do
    let frame = Frame.recv socket in
    match frame with
    | None -> cond := false
    | Some x -> append self x
  done;
  self

let send msg socket = 
  let cond = ref true in
  while !cond do
    print_int (List.length (!msg));
    let frame = pop msg in
    match frame with
    | None -> cond := false 
    | Some x -> begin match List.length !msg with 
        | 0 -> let rc = Frame.send x socket in ()
        | _ -> let rc = Frame.send x socket ~flag:Frame.More in ()
      end
  done
(*
let size = foreign "zmsg_size" (t &->
*)
