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

include Structs

type t = Structs.zcert_t Ctypes.structure Ctypes.ptr 

let create = foreign "zcert_new"
  (void @-> returning (ptr Structs._zcert_t))
(*
let destroy certificate = 
  let destroy_stub = foreign "zcert_destroy"
    (ptr (ptr _zcert_t) @-> returning void)
  in
  destroy_stub (addr certificate)
*)
let public_txt = foreign "zcert_public_txt"
  ((ptr _zcert_t) @-> returning string)

let secret_txt = foreign "zcert_secret_txt"
  ((ptr _zcert_t) @-> returning string)

let set_meta = foreign "zcert_set_meta"
  ((ptr _zcert_t) @-> string @-> string @-> returning void)

let meta = foreign "zcert_meta"
  ((ptr _zcert_t) @-> string @-> returning string)

let load = foreign "zcert_load"
  (string @-> returning (ptr _zcert_t))

let save self filename = 
  let stub = foreign "zcert_save"
    ((ptr _zcert_t) @-> string @-> returning int) 
  in
  match stub self filename with 
  | _ -> ()

let save_public self filename = 
  let stub = foreign "zcert_save_public"
    ((ptr _zcert_t) @-> string @-> returning int)
  in
  match stub self filename with
  | _ -> ()

let apply = foreign "zcert_apply"
  ((ptr _zcert_t) @-> ptr void @-> returning void)

let dup = foreign "zcert_dup"
  ((ptr _zcert_t) @-> returning (ptr _zcert_t))

let eq self compare = 
  let stub = foreign "zcert_eq"
    ((ptr _zcert_t) @-> (ptr _zcert_t) @-> returning int)
  in
  match stub self compare with
  | 0 -> false
  | _ -> true

let dump = foreign "zcert_dump"
  ((ptr _zcert_t) @-> returning void)
