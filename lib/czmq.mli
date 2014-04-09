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

val version : unit -> int * int * int

module Context : sig

  type t 

  (* Create & Destroy *)
  val create : unit -> t
  val destroy : t -> unit 

  (* Setter *)
  val set_io_threads : t -> int -> unit 
  val set_linger : t -> int -> unit
  val set_pipehwm : t -> int -> unit
  val set_sndhwm : t -> int -> unit
  val set_rcvhwm : t -> int -> unit

  val interrupted : bool

end

module Socket : sig

  type 'a t

  type kind = [`Req | `Rep | `Dealer | `Router | `Pub | `Sub | `XPub | `XSub |
               `Push | `Pull | `Pair]

  val create : Context.t -> kind -> kind t
  val destroy : Context.t -> kind t -> unit

  val bind : kind t -> string -> unit
  val unbind : kind t -> string -> unit

  val connect : kind t -> string -> unit  
  val disconnect : kind t -> string -> unit  

  val poll : kind t -> int -> bool

  val type_str : kind t -> string

  (* Get socket options *)
  val ipv6 : kind t -> bool
  val ipv4only : kind t -> bool
  val probe_router : kind t -> bool
  val plain_server : kind t -> bool
  val plain_username : kind t -> string
  val plain_password : kind t -> string
  val curve_server : kind t -> int
  val curve_publickey : kind t -> string
  val curve_secretkey : kind t -> string
  val curve_serverkey : kind t -> string
  val zap_domain : kind t -> string
  val socket_type : kind t -> int
  val sndhwm : kind t -> int
  val rcvhwm : kind t -> int
  val affinity : kind t -> int
  val identity : kind t -> string
  val rate : kind t -> int 
  val recovery_ivl : kind t -> int
  val sndbuf : kind t -> int
  val rcvbuf : kind t -> int
  val linger : kind t -> int
  val reconnect_ivl : kind t -> int
  val reconnect_ivl_max : kind t -> int
  val backlog : kind t -> int
  val maxmsgsize : kind t -> int
  val multicast_hops : kind t -> int
  val rcvtimeo : kind t -> int
  val sndtimeo : kind t -> int
  val tcp_keepalive : kind t -> int
  val tcp_keepalive_idle : kind t -> int
  val tcp_keepalive_cnt : kind t -> int
  val tcp_keepalive_intvl : kind t -> int
  val tcp_accept_filter : kind t -> string
  val rcvmore : kind t -> bool
  val fd : kind t -> int
  val events : kind t -> int 
  val last_endpoint : kind t -> string

  (* Set socket options *)
  val set_ipv6 : kind t -> bool -> unit
  val set_immediate : kind t -> int -> unit
  val set_router_raw : [`Router] t -> int -> unit
  val set_ipv4only : kind t -> int -> unit
  val set_delay_attach_on_connect : kind t -> int -> unit
  val set_router_mandatory : kind t -> int -> unit
  val set_req_relaxed : kind t -> int -> unit
  val set_req_correlate : kind t -> int -> unit
  val set_conflate : kind t -> int -> unit
  val set_plain_server : kind t -> int -> unit
  val set_plain_username : kind t -> string -> unit
  val set_plain_password : kind t -> string -> unit
  val set_curve_server : kind t -> bool -> unit
  val set_curve_publickey : kind t -> string -> unit
  val set_curve_secretkey : kind t -> string -> unit
  val set_curve_serverkey : kind t -> string -> unit
  val set_zap_domain : kind t -> string -> unit 
  val set_sndhwm : kind t -> int -> unit
  val set_rcvhwm : kind t -> int -> unit
  val set_affinity : kind t -> int -> unit
  val set_subscribe : [>`Sub] t -> string -> unit
  val set_unsubscribe : [>`Sub] t -> string -> unit
  val set_identity : [>`Req|`Rep|`Dealer|`Router] t -> string -> unit
  val set_rate : kind t -> int -> unit
  val set_recovery_ivl : kind t -> int -> unit
  val set_sndbuf : kind t -> int -> unit
  val set_rcvbuf : kind t -> int -> unit
  val set_linger : kind t -> int -> unit
  val set_reconnect_ivl : kind t -> int -> unit
  val set_reconnect_ivl_max : kind t -> int -> unit
  val set_backlog : kind t -> int -> unit
  val set_maxmsgsize : kind t -> int -> unit
  val set_multicast_hops : kind t -> int -> unit
  val set_rcvtimeo : kind t -> int -> unit
  val set_sndtimeo : kind t -> int -> unit

end

module Str : sig

  val recv : Socket.kind Socket.t -> string

  val recv_nowait : Socket.kind Socket.t -> string

  val send : Socket.kind Socket.t -> string -> unit

  val sendx : Socket.kind Socket.t -> string list -> unit

  val recvx : Socket.kind Socket.t -> string list

end

module Auth : sig

  type t 

  val create : Context.t -> t
(*
  val destroy : t -> unit
*)
  val allow : t -> string -> unit

  val deny : t -> string -> unit

  val configure_plain : t -> string -> string -> unit

  val configure_curve : t -> string -> string -> unit

  val set_verbose : t -> bool -> unit

end

module Beacon : sig

  type t

  val create : int -> t

  val hostname : t -> string

  val set_interval : t -> int -> unit

  val noecho : t -> unit

  val silence : t -> unit 

  val unsubscribe : t -> unit

  val socket : t -> Socket.kind Socket.t

end

module Cert : sig

  type t

  val create : unit -> t
(*
  val destroy : t -> unit
*)
  val public_key : t -> string

  val public_txt : t -> string

  val secret_txt : t -> string

  val set_meta : t -> string -> string -> unit

  val meta : t -> string -> string

  val load : string -> t

  val save : t -> string -> unit

  val save_public : t -> string -> unit

  val apply : t -> Socket.kind Socket.t -> unit

  val eq : t -> t -> bool
(*
  val dump : t -> unit
*)
end

module Certstore : sig

  type t

  val create : string -> t
(*
  val lookup : t -> string -> Cert.t
  val dump : t -> unit
*)

end

module Clock : sig

  val sleep : int -> unit

  val time : unit -> int64

  val log : string -> unit

  val timestr : unit -> string

end

module Directory : sig

  type t 

  val create : string -> string -> t

  val path : t -> string

(*
  val dump : t -> int -> unit
*)

end
(*
module Sys : sig

  val set_interface : string -> unit

  val interface : unit -> string

  val file_exists : string -> bool

  val dir_create : string -> unit

  val dir_delete : string -> unit

  val file_mode_private : unit -> unit

  val file_mode_default : unit -> unit

end
*)
module Poller : sig

  type t

  val create : Socket.kind Socket.t list -> t

  val wait : t -> int -> Socket.kind Socket.t option

  val expired : t -> bool

  val terminated : t -> bool

end

module Config : sig

  type t

  val create : string -> t -> t

  val name : t -> string

  val value : t -> string

  val put : t -> string -> string -> unit

  val set_name : t -> string -> unit

  val set_value : t -> string -> unit

  val child : t -> t

  val next : t -> t

  val locate : t -> string -> t

  val resolve : t -> string -> string -> string
(*
  val set_path : t -> string -> string -> unit
*)
  val at_depth :  t -> int -> t

(*
  val comment : t -> string -> unit
*)

  val load : string -> t

(*
  val dump : t -> unit
*)

end

module Frame : sig

  type t 

  type flags = Last | More | Dontwait | More_Dontwait

  val create : string -> t

  val data : t -> string

  val recv : Socket.kind Socket.t -> t option

  val recv_nowait : Socket.kind Socket.t -> t option

  val send : t -> Socket.kind Socket.t -> ?flag:flags -> int

  val strhex : t -> string

end

module Msg : sig

  type t

  val create : unit -> t

  val push : t -> Frame.t -> unit 

  val pop : t -> Frame.t option

  val append : t -> Frame.t -> unit

  val wrap : t -> Frame.t -> unit

  val recv : Socket.kind Socket.t -> t

  val send : t -> Socket.kind Socket.t -> unit
(*
  val unwrap : t -> t option
*)
end
