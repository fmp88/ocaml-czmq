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

type t = Structs.zauth_t Ctypes.structure Ctypes.ptr 

let create = foreign "zauth_new"
  ((ptr Structs._zctx_t) @-> returning (ptr Structs._zauth_t))
(*
let destroy authenticator = 
  let destroy_stub = foreign "zauth_destroy"
    (ptr (ptr Structs._zctx_t) @-> returning void)
  in
  destroy_stub (addr authenticator) 
*)
let allow = foreign "zauth_allow"
  ((ptr Structs._zctx_t) @-> string @-> returning void)

let deny = foreign "zauth_deny"
  ((ptr Structs._zctx_t) @-> string @-> returning void)

let configure_plain = foreign "zauth_configure_plain"
  ((ptr Structs._zctx_t) @-> string @-> string @-> returning void)
  
let configure_curve = foreign "zauth_configure_curve"
  ((ptr Structs._zctx_t) @-> string @-> string @-> returning void)
(*
let set_verbose = foreign "zauth_set_verbose"
  ((ptr _zctx_t) @-> bool @-> returning void)
*) 
