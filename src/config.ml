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

type t = Structs.zconfig_t Ctypes.structure Ctypes.ptr 

let create = foreign "zconfig_new"
  (string @-> (ptr Structs._zconfig_t) @-> returning (ptr Structs._zconfig_t))

let name = foreign "zconfig_name"
  ((ptr Structs._zconfig_t) @-> returning string)

let value = foreign "zconfig_value"
  ((ptr Structs._zconfig_t) @-> returning string)

let put = foreign "zconfig_put"
  ((ptr Structs._zconfig_t) @-> string @-> string @-> returning void)

let set_name = foreign "zconfig_set_name"
  ((ptr Structs._zconfig_t) @-> string @-> returning void)

let set_value = foreign "zconfig_set_value"
  ((ptr Structs._zconfig_t) @-> string @-> returning void)

let child = foreign "zconfig_child"
  ((ptr Structs._zconfig_t) @-> returning (ptr Structs._zconfig_t))

let next = foreign "zconfig_next"
  ((ptr Structs._zconfig_t) @-> returning (ptr Structs._zconfig_t))

let locate = foreign "zconfig_locate"
  ((ptr Structs._zconfig_t) @-> string @-> returning (ptr Structs._zconfig_t))

let resolve = foreign "zconfig_resolve"
  ((ptr Structs._zconfig_t) @-> string @-> string @-> returning string)

let set_path = foreign "zconfig_set_path"
  ((ptr Structs._zconfig_t) @-> string @-> string @-> returning void)

let at_depth = foreign "zconfig_at_depth"
  ((ptr Structs._zconfig_t) @-> int @-> returning (ptr Structs._zconfig_t))

let comment = foreign "zconfig_comment"
  ((ptr Structs._zconfig_t) @-> string @-> returning void)

let load = foreign "zconfig_load"
  (string @-> returning (ptr Structs._zconfig_t))

let dump = foreign "zconfig_dump"
  ((ptr Structs._zconfig_t) @-> returning void)

