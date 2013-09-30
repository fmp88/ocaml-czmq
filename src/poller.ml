(*
Copyright (c) 2013, Florian Pichlmeier <florian.pichlmeier@mytum.de>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies, 
either expressed or implied, of the FreeBSD Project.
*)

open Ctypes
open PosixTypes
open Foreign
open Unsigned

exception General_Error of string

type t = Structs.zpoller_t Ctypes.structure Ctypes.ptr 

let create reader_list = 
  let stub = foreign "zpoller_new"
    (ptr void @-> returning (ptr Structs._zpoller_t))
  in
  let stub2 = foreign "zpoller_new"
    (ptr void @-> ptr void @-> returning (ptr Structs._zpoller_t))
  in
  let stub3 = foreign "zpoller_new"
    (ptr void @-> ptr void @-> ptr void @-> returning (ptr Structs._zpoller_t))
  in
  let stub4 = foreign "zpoller_new"
    (ptr void @-> ptr void @-> ptr void @-> ptr void @-> returning (ptr Structs._zpoller_t))
  in
  let stub5 = foreign "zpoller_new"
    (ptr void @-> ptr void @-> ptr void @-> ptr void @-> ptr void @-> returning (ptr Structs._zpoller_t))
  in
  match List.length reader_list with 
  | 1 -> stub (List.nth reader_list 0)
  | 2 -> stub2 (List.nth reader_list 0) (List.nth reader_list 1)
  | 3 -> stub3 (List.nth reader_list 0) (List.nth reader_list 1) (List.nth reader_list 2)
  | 4 -> stub4 (List.nth reader_list 0) (List.nth reader_list 1) (List.nth reader_list 2)
    (List.nth reader_list 3)
  | 5 -> stub5 (List.nth reader_list 0) (List.nth reader_list 1) (List.nth reader_list 2)
    (List.nth reader_list 3) (List.nth reader_list 4)
  | _ -> raise (General_Error "To many readers")

let wait = foreign "zpoller_wait"
  ((ptr Structs._zpoller_t) @-> int @-> returning (ptr void))

let expired self = 
  let stub = foreign "zpoller_expired"
    ((ptr Structs._zpoller_t) @-> returning int)
  in
  match stub self with
  | 0 -> false
  | _ -> true
  
let terminated self = 
  let stub = foreign "zpoller_terminated"
    ((ptr Structs._zpoller_t) @-> returning int)
  in
  match stub self with
  | 0 -> false
  | _ -> true

