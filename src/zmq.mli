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
  (*
  val set_max_sockets : t -> int -> unit 
  val set_ipv6 : t -> bool -> unit 
  *)
  (*
  (* Getter *)
  val get_io_threads : t -> int
  val get_max_sockets : t -> int
  val get_ipv6 : t -> bool
  *)
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
  val rcvmore : kind t -> int
  val fd : kind t -> int
  val events : kind t -> int 
  val last_endpoint : kind t -> string

  (* Set socket options *)
  val set_ipv6 : kind t -> bool -> unit
  val set_immediate : kind t -> int -> unit
  val set_router_raw : kind t -> int -> unit
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
  val set_zap_domain : kind t -> string -> unit 
  val set_sndhwm : kind t -> int -> unit
  val set_rcvhwm : kind t -> int -> unit
  val set_affinity : kind t -> int -> unit
  val set_subscribe : kind t -> string -> unit
  val set_unsubscribe : kind t -> string -> unit
  val set_identity : kind t -> string -> unit
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

(*
  type snd_flag = None | Dontwait | Sndmore | Dontwait_Sndmore
  val send : kind t -> ?flag:snd_flag -> string -> unit

  type recv_flag = None | Dontwait
  val recv : ?flag:recv_flag -> kind t -> string
*)
end

module Str : sig

  val recv : Socket.kind Socket.t -> string

  val recv_nowait : Socket.kind Socket.t -> string

  val send : Socket.kind Socket.t -> string -> unit

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
  val public_txt : t -> string

  val secret_txt : t -> string

  val set_meta : t -> string -> string -> unit

  val meta : t -> string -> string

  val load : string -> t

  val save : t -> string -> unit

  val save_public : t -> string -> unit

  val apply : t -> Socket.kind Socket.t -> unit
 
  val eq : t -> t -> bool

  val dump : t -> unit

end

module Certstore : sig

  type t

  val create : string -> t
(*
  val lookup : t -> string -> Cert.t
*)
  val dump : t -> unit

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

  val dump : t -> int -> unit

end

module Sys : sig
  
  val set_interface : string -> unit

  val interface : unit -> string

  val file_exists : string -> bool

  val dir_create : string -> unit

  val dir_delete : string -> unit

  val file_mode_private : unit -> unit

  val file_mode_default : unit -> unit

end

module Poller : sig

  type t

  val create : Socket.kind Socket.t list -> t

  val wait : t -> int -> Socket.kind Socket.t

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

  val set_path : t -> string -> string -> unit

  val at_depth :  t -> int -> t

  val comment : t -> string -> unit

  val load : string -> t

  val dump : t -> unit

end
