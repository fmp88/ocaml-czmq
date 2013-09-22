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

  type snd_flag = None | Dontwait | Sndmore | Dontwait_Sndmore
  val send : kind t -> ?flag:snd_flag -> string -> unit

  type recv_flag = None | Dontwait
  val recv : ?flag:recv_flag -> kind t -> string

end

module Poll : sig

  type t

  type poll_t

  type event = In | Out | InOut
  type item = (Socket.kind Socket.t * event)

(*val mask : item array -> t*)
  val mask :(unit Ctypes.ptr * event) Ctypes.Array.t ->
           poll_t Ctypes.structure Ctypes.Array.t
(*
  val poll : ?timeout: int -> t event option array
*)
end
  
module Options : sig
  
end

module Clock : sig

  val sleep : int -> unit

  val time : unit -> int64

  val log : string -> unit

  val timestr : unit -> string

end

module Cert : sig
 
  type t
  
  val create : unit -> t

end

module Certstore : sig
 
  type t

  val create : string -> t

  val lookup : t -> string -> Cert.t

  val dump : t -> unit

end

module Auth : sig

  type t 

  val create : Context.t -> t

  val allow : Context.t -> string -> unit

  val deny : Context.t -> string -> unit

  val configure_plain : Context.t -> string -> string -> unit

  val configure_curve : Context.t -> string -> string -> unit

end

module Beacon : sig

  type t

  val create : int -> t

  val hostname : t -> string

  val set_interval : t -> int -> unit

  val noecho : t -> unit

  val silence : t -> unit 

end
